# Omrah Tracking Map — Route Drawing

> How the provider's route is fetched and drawn as a Google Maps polyline on
> [`UserOmrahMapInspectorPage`](user/presentation/pages/user_omrah_map_inspector_page.dart).
>
> Backend base URL: `https://api.moneeb.io/api/v1` · Swagger: `/api/v1/docs#/Tracking`

---

## 1. What this feature does

Opening the map inspector fetches the provider's tracked GPS trail for the
order and draws it as a line on the Google map, with a marker at the last
known position. While the omrah is still running the line keeps growing from
live socket pings; once it is completed the map shows the finished route as a
closed record.

```
UserOmrahMapInspectorPage(orderId, currentStep)
        │
        ├─ BlocProvider → OmrahMapTrackingCubit(orderId, isOmrahCompleted)..init()
        │                        │
        │                        ├─ REST  → OmrahInspectorRepo → tracking endpoints
        │                        └─ Socket→ OmrahSocket (skipped when completed)
        │
        └─ _UserOmrahMapInspectorBody  ← renders only; no networking
                 ├─ Polyline set (GoogleMap.polylines) → the route line
                 ├─ Marker set   (GoogleMap.markers)   → the provider marker
                 └─ _TrackingStatusBanner              → loading / error / empty pill
```

---

## 2. Endpoint choice

The Tracking tag exposes three read endpoints that could plausibly feed a
polyline. They are **not** interchangeable.

| | `/{orderId}/route` | `/{orderId}/path` | `/{orderId}/history` |
|---|---|---|---|
| Documented purpose | GeoJSON LineString **"ready to draw"** | raw GPS in Redis | paginated audit history |
| Payload | `geometry.coordinates: [[lng,lat],…]` | `points: [{lat,lng,timestamp,…}]` | `items: […]` + `meta` |
| Parsing fit | **one parser call** — a single documented `[lng,lat]` shape | needs conversion | conversion **+ page-walking** |
| Road-snapped | yes (OSRM); falls back to the raw line | no | no |
| Retention | durable | **24 h TTL** | durable |
| Pagination | none | none | up to 5000/page |
| Access | requester, assigned provider, admin, owner | same | same |

**In progress → `/route`.** It is the only endpoint built for rendering. Its
GeoJSON `[lng, lat]` order is normalized exactly once, in
`OmrahRoutePointEntity.fromGeoJsonPair`, so the rendering layer never touches
raw coordinate order. It also degrades internally: fewer than 2 points or an
unavailable matcher returns the raw GPS line with `snapped: false` instead of
failing.

**Completed → `/history`.** The 24 h live window `/path` reads from has expired
by then, and there is no longer a moving trail worth map-matching. History is
the durable record.

`/history` was rejected as the *primary* source because assembling one polyline
from it means walking pages of the same raw points `/path` already returns in
one call.

### Fallback chains

Both branches fall back, because the two stores are written at different times:
`POST /{orderId}/location` writes to **Redis**, while `/history` reads
**Postgres**, so a flush step sits between them.

```
in progress :  /route  ──(empty)──▶  /path
completed   :  /history ─(empty)──▶  /route ──(empty)──▶ /path
```

Swagger does not state which store `/route` reads, and it could not be
determined empirically (see §3), so the in-progress fallback is defensive. The
completed fallback covers a real window: an omrah that finished minutes ago can
still have its points only in Redis.

> ⚠️ Worth confirming with the backend team. If `/route` already reads the live
> store, the `/route → /path` hop is redundant and can be dropped from
> [`getTrackingRoute`](user/data/repo/omrah_inspector_repo.dart).

---

## 3. What the live API actually returns

Checked against the real backend with a requester token. **Every one of the 20
orders on the test account returned empty data from all three endpoints:**

```jsonc
// GET tracking/{orderId}/route
{ "success": true, "statusCode": 200,
  "data": { "geometry": { "type": "LineString", "coordinates": [] },
            "distanceMeters": 0, "durationSeconds": 0,
            "pointsUsed": 0, "snapped": false } }

// GET tracking/{orderId}/path
{ "success": true, "statusCode": 200, "data": { "points": [] } }

// GET tracking/{orderId}/history?page=1&limit=5000
{ "success": true, "statusCode": 200,
  "data": { "items": [], "meta": { "page": 1, "limit": 5000,
                                   "totalItems": 0, "totalPages": 0 } } }
```

No GPS has ever been posted for those orders. Seeding some was not possible:
`POST /{orderId}/location` is **assigned provider / admin / owner only** and the
test token is `REQUESTER`.

Note that `GET /orders/{id}/assumed-track` *does* return data — but that is the
**planned** ritual route (miqat → tawaf → sa'i waypoints), not a tracked trail.
It is not used here.

Because of this, the populated-response path is implemented against the
documented Swagger schemas but has **not** been exercised against real backend
data. See §9.

---

## 4. Files

```
lib/features/omrah/
├── common/data/endpoints/omrah_endpoint.dart          ← +trackingRoute, +trackingHistory
└── user/
    ├── data/repo/omrah_inspector_repo.dart            ← +3 methods
    ├── domain/models/tracking/
    │   └── omrah_route_entity.dart                    ← NEW · entity + 3 parsers
    └── presentation/
        ├── manager/
        │   ├── omrah_map_tracking_cubit.dart          ← NEW
        │   └── omrah_map_tracking_state.dart          ← NEW
        └── pages/user_omrah_map_inspector_page.dart   ← rewritten
```

Localization: `loadingRoute`, `noRouteRecorded` added to both ARB files.

### Endpoints

```dart
static String trackingRoute(String orderId)   => 'tracking/$orderId/route';
static String trackingPath(String orderId)    => 'tracking/$orderId/path';
static String trackingHistory(String orderId) => 'tracking/$orderId/history';
```

### Model

`OmrahRouteEntity` holds the route; `OmrahRoutePointEntity` holds one point.
Both are deliberately free of any map-SDK type, so the data and domain layers
do not depend on the rendering SDK — the presentation layer maps to the Google
Maps `LatLng`. (This is what made the Mapbox → Google Maps swap a
presentation-only change.)

| Member | Purpose |
|---|---|
| `fromRouteJson` | parses `geometry.coordinates` (`[lng, lat]` pairs) |
| `fromPathJson` | parses `points` (`{lat, lng}` objects) |
| `fromHistoryJson` | parses `items` (`{lat, lng}` objects) |
| `totalPagesOf` | reads `meta.totalPages` so the repo knows how far to walk |
| `fromHistoryPages` | joins walked pages into one route |
| `isDrawable` | `points.length >= 2` — the polyline guard |
| `isValid` (point) | range check + rejects the `(0,0)` "null island" fix |

`_parsePoints` drops anything malformed and collapses consecutive duplicates,
so a stationary provider does not bloat the line.

> The GeoJSON parser is the one to be careful with: `/route` returns
> `[lng, lat]`, the reverse of the `{lat, lng}` objects the other two return —
> and also the reverse of the `LatLng(lat, lng)` constructor order. Silently
> swapping them puts the route in the wrong hemisphere.

### Repository

| Method | Behaviour |
|---|---|
| `getTrackingRoute` | `/route`, falling back to `/path` |
| `getCompletedOmrahRoute` | `getTrackingHistory`, falling back to `getTrackingRoute` |
| `getTrackingHistory` | walks `/history` pages and joins them |
| `_getTrackingPayload` | single place every tracking request fetches and unwraps |

History paging is bounded: `_historyPageSize = 5000` (the endpoint maximum) and
`_maxHistoryPages = 20`. Exceeding the cap `log()`s what was dropped rather than
truncating silently.

### Cubit / state

`OmrahMapTrackingCubit(orderId, {isOmrahCompleted})` owns **both** data sources,
so the page holds no networking logic. `init()` loads the route, then subscribes
to the socket — unless the omrah is completed, in which case there is no
provider left to stream.

| State member | Meaning |
|---|---|
| `route` | `StateBox<OmrahRouteEntity>` — the fetched route |
| `livePoints` | points received over the socket since the page opened |
| `polylinePoints` | `route.points + livePoints` — what actually gets drawn |
| `canDrawPolyline` | at least 2 points |
| `lastKnownLocation` | end of `polylinePoints`; drives the marker |
| `hasLiveLocation` | a live ping has arrived |
| `hasNoTrackingData` | settled, nothing drawable, nothing live |

---

## 5. Completed vs in progress

The page takes `OmrahStepsEnum? currentStep`. `OmrahStepsEnum.finished` means
completed; `null` is treated as in progress.

```dart
UserOmrahMapInspectorPage(
  orderId: widget.orderId,
  currentStep: state.currentStep.data,   // from OmrahInspectorCubit
)
```

| | completed | in progress |
|---|---|---|
| Source | `/history` → `/route` → `/path` | `/route` → `/path` |
| Socket | not connected | connected |
| Empty-state pill | `noRouteRecorded` | `waitProviderLocation` |

`OmrahStepsEnum.finished` was chosen over the real `UserOrderStatus.completed`
because it is already available wherever the map is opened —
`OmrahInspectorCubit.currentStep` resolves to `finished` when every ritual step
is done. Threading the true order status would mean changing ~6 upstream
callers, several of which only ever hold an `orderId`.

### Call sites

- [`omrah_inspector.dart`](user/presentation/pages/omrah_inspector.dart) — passes
  `state.currentStep.data`. The map button used to be hidden once the omrah
  finished; that early return is now disabled so a completed route is viewable.
- [`omrah_media_inspector_page.dart`](user/presentation/pages/omrah_media_inspector_page.dart)
  — passes nothing. Its map button only renders while the step is still
  `pending`, so the omrah is by definition not completed there.

---

## 6. Rendering

Uses `google_maps_flutter` declaratively: the route line and the provider
marker are `Set<Polyline>` / `Set<Marker>` built from the cubit state on every
build, and `GoogleMap` diffs them itself. Live growth is just the same
`PolylineId` re-emitted with more points.

```dart
Polyline(
  polylineId: const PolylineId('route'),
  points: points,                 // List<LatLng> from state.polylinePoints
  color: AppColors.primary400,
  width: 5,
  zIndex: 1,
  jointType: JointType.round,
),
```

Google Maps polylines have no border property, so the old 1px white outline is
preserved manually: a second white polyline with `width: 7` is drawn underneath
the route (`route_border`, lower z-index).

The marker icon is the same `AssetPaths.mapMarker` bytes, rendered at
`width: 78` — the 25px asset at the 3.1× scale the Mapbox map drew it at —
anchored bottom-center. If loading the asset fails, the default pin steps in
so the last known position is never silently hidden.

### The map-ready race

Tracking data can land **before or after** the map finishes initialising.
Annotations no longer care (they are declarative), so only the **camera**
still needs syncing: `_syncCamera()` runs from `onMapCreated` and from every
state change, and no-ops until the controller exists. The old
`_isSyncing` / `_isSyncPending` serialisation is gone — there are no
imperative annotation creates left to duplicate.

### Camera

The full route is framed exactly once (`_hasFramedRoute`) via
`CameraUpdate.newLatLngBounds`, and only while no live ping has arrived. After
that, live updates take over and animate to the provider at zoom 17 —
following the provider beats re-framing a route they have already left.

Two porting notes:

- **Zoom levels are +1 versus the old Mapbox values** (Google renders 256px
  tiles where Mapbox GL renders 512px), so initial 7.5 → 8.5 and follow
  16 → 17 show the same area.
- `newLatLngBounds` only takes uniform padding (70), not the per-edge insets
  the Mapbox camera used (100/40/160/40) — the framing is marginally tighter
  at the bottom.

---

## 7. Error and empty states

| Condition | Map | Bottom pill |
|---|---|---|
| Loading | usable, no line | `loadingRoute` |
| Request failed | usable, no line | error message + **retry** |
| Empty, in progress | usable, no line | `waitProviderLocation` |
| Empty, completed | usable, no line | `noRouteRecorded` |
| Fewer than 2 valid points | **no line drawn** | as above |
| Live ping received | line + marker follow | hidden |

Additional guards:

- invalid coordinates (out of range, `(0, 0)`) are filtered at parse time;
- consecutive duplicate points are collapsed;
- a socket failure is logged and leaves the fetched route on screen;
- every camera call into the map platform is wrapped — a camera error logs and
  returns instead of taking the page down.

The map always remains functional. No tracking data never means a crash.

---

## 8. Security

The page authenticates through `DioHelper`, which already injects
`Bearer ${token.accessToken}` from `TokenManager`. **No token is hard-coded
anywhere**, and the tracking endpoints need no handling beyond that standard
mechanism.

---

## 9. Testing status

There are currently **no automated tests** for this feature, and it has never
run against real GPS data (§3). Both gaps are worth closing.

If tests are added, the cases that actually matter:

- each parser against the Swagger example payloads **and** the empty responses
  in §3;
- GeoJSON `[lng, lat]` order asserted explicitly;
- malformed pairs, truncated pairs, `null`s, out-of-range values, the `(0,0)`
  fix, consecutive duplicates;
- a single point parses but is **not** drawable;
- history pagination: meta consistency, walking every page rebuilding the trail
  exactly once, a page past the end returning empty rather than throwing.

For a manual preview without a backend that has data, the practical approach is
a debug-only switch inside `_getTrackingPayload` that returns Swagger-shaped
sample payloads — injected there rather than higher up, so the real parsers,
duplicate-collapsing and page-walking all still run. Gate it behind
`kDebugMode` so it can never affect a release build.

---

## 10. Open items

1. **Never seen with real data.** No order in the system has any GPS, so the
   populated path is unverified end-to-end. The first order with real tracking
   data is the real test.
2. **Which store does `/route` read?** Undocumented. Confirm with the backend
   team; if it already reads Redis, the `/route → /path` fallback is redundant.
3. **`noRouteRecorded` is an addition.** The requirement was only to hide the
   waiting hint for a completed omrah; showing a distinct message was a judgment
   call to avoid a silent blank map. Drop the branch in `_TrackingStatusBanner`
   if not wanted.
4. **The socket moved into the cubit.** It previously lived in the page. This
   was needed so live pings extend the same polyline — otherwise the drawn route
   freezes at page-entry while the marker walks away from it. Existing behaviour
   (marker, camera follow, waiting pill) is preserved.
5. **No synthetic live pings.** The socket is real in every path, so the
   live-append behaviour cannot be exercised without an actual provider posting
   locations.

---

_Last updated: 2026-09-07 (migrated from Mapbox to Google Maps)._
