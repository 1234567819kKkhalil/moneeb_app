# Authentication Feature — Analysis & Migration Blueprint

> Analysis of `lib/features/authentication` as it exists today, the target
> **unified passwordless OTP** backend (`/api/v1/auth/otp/*`), and the plan to
> migrate the app onto it.
>
> Backend base URL: `https://api.moneeb.io/api/v1` · Swagger: `/api/v1/docs#/Auth`

---

## 1. Current Architecture

The feature follows the project's **feature-based clean architecture** with the
**part-of library** pattern. Everything is declared inside a single library
`auth` (see [`authentication_imports.dart`](authentication_imports.dart)); each
source file begins with `part of auth;` and is registered as a `part` there.

```
lib/features/authentication/
├── authentication_imports.dart          ← library auth; + all imports + part directives
└── src/
    ├── data/
    │   ├── endpoints/auth_endpoint.dart          ← path constants
    │   ├── models/register/api_register_result.dart
    │   └── repository/authentication_repositories_imp.dart
    ├── domain/
    │   ├── entities/
    │   │   ├── enums/quran_memorize_enum.dart
    │   │   └── inputs/{login_input, register_input, complete_provider_profile_input}.dart
    │   │   └── resend_otp_input.dart
    │   ├── repositories/authentication_repositories.dart   ← abstract AuthRepository
    │   └── use_cases/  (login, register, complete_provider_profile, logout,
    │                    delete_account, get_user_data, is_user_authenticated,
    │                    send_otp, set_fcm_token, forgot_password,
    │                    verify_forgot_password, reset_password, verify_otp*)
    └── presentation/
        ├── manger/                       ← AuthenticationBloc + state/events + TokenManager
        └── ui/
            ├── common/                   ← EmailWidget, EmailOrPhoneWidget, OtpPinCodeWidget
            ├── get_started/              ← GetStartedPage, ChooseUserTypePage
            ├── decider_page/             ← DeciderPage, SplashPage
            ├── login/                    ← LoginPage + LoginCubit + LoginState
            ├── otp/                      ← OtpVerificationPage + OTPCubit + OTPState
            ├── forgot_password/          ← ForgotPasswordPage, ResetPasswordPage + cubit
            ├── register/user/            ← UserRegisterPage + steps + cubit + input provider
            ├── register/provider/        ← ProviderRegisterPage + cubit
            └── complete_profile/         ← ProviderCompleteProfilePage + steps (post-auth)
```

### State management
- Cubits extend `BaseCubit<State>`; async work runs through `collect(task:, onError:)`
  which handles connectivity + failure conversion + unauthorized dialogs.
- Async state is wrapped in `StateBox<T>` (`initial / loading / success / failure`).
- `AuthenticationBloc` is the app-wide session manager (**Bloc**, not Cubit); the
  per-screen flows (login, otp, register) are **Cubits**.

### App-level routing
`AuthenticationBloc.state.routingState.route` (`AuthRouteEnum`) drives the root
widget in [`builder_screen.dart`](../../builder_screen.dart):

| `AuthRouteEnum` | Root widget |
|---|---|
| `deciderPage`   | `DeciderPage` (splash → decides auth vs guest vs get-started) |
| `getStartedPage`| `GetStartedPage` |
| `guest`         | `MainHostPage` |
| `authenticated` | `MainHostPage`, **or** `ProviderCompleteProfilePage` if provider profile incomplete |

`LoginPage`, `UserRegisterPage`, `ProviderRegisterPage`, `OtpVerificationPage`,
etc. are **pushed on top** via `AppRouteNavigator` — they are not roots. On
success they call `AuthenticationBloc.startDecider()` + `popUntil` so the
`DeciderPage → FetchUserDataEvent → /users/me` cycle re-hydrates the session.

---

## 2. Current User Flow (before this change)

```
GetStartedPage
   └─(Continue)→ ChooseUserTypePage  [radio: User | Provider]  ← TO BE REMOVED
                     └─(Start)→ sets role on AuthenticationBloc, pushReplacement → LoginPage
LoginPage (email/phone + PASSWORD)
   ├─ login()  → AuthEndpoint.login  → token → startDecider() → Home
   ├─ "Forgot password" → ForgotPasswordPage → OtpVerificationPage → ResetPasswordPage
   └─ "Create account" → UserRegisterPage OR ProviderRegisterPage (based on role)
```

Key point: **login today is password-based**, and role is chosen *up front* on
`ChooseUserTypePage`, then read from `AuthenticationBloc.getUserRole` throughout
register.

---

## 3. Data / Domain layer today

### Endpoints ([`auth_endpoint.dart`](src/data/endpoints/auth_endpoint.dart))
`register`, `login`, `setFcmToken`, `getProviderData`, `getUserData`,
`provideCompleteProfile`, `forgotPassword`, `verifyForgotPassword`, `resetPassword`.
**No OTP-auth endpoints exist yet.**

### Repository ([`AuthRepository`](src/domain/repositories/authentication_repositories.dart) + impl)
- `login(LoginInput)` → `POST auth/login {emailOrPhone, password}` → `ApiTokenModel` → `TokenEntity`.
- `register(RegisterInput)` → `POST auth/register` → token.
- `completeProviderProfile`, `getUserData` (`/users/me`, then `/providers/me` if provider),
  `forgotPassword`/`verifyForgotPassword`/`resetPassword`.
- **Stubs / dead code:** `sendOTP()`, `logout()`, `updateFcmToken()`,
  `deleteAccount()` are all `//todo:` no-ops.

### Inputs
- `LoginInput{email, password, fcmToken?}` → `toJson: {emailOrPhone, password}`.
- `RegisterInput{role, fullName, email, password, phoneNumber, countryCode, languageCode, isHafiz?}`
  → `toJson: {role: role.toApi(), fullName, email, password, phone, countryCode, languageCode, isHafiz?}`.
- `ResendOtpInput` exists but is only tied to `passwordReset`/`emailUpdate`.

### Models
- `ApiTokenModel{accessToken, expiresIn, refreshToken}` → `TokenEntity` (saved
  via `TokenManager.setTokenToLocalStorage`, encrypted in SharedPreferences).
- `ApiRegisterResult` (token + optional user) — defined, not actively used.

### Roles ([`UserRoleEnum`](../../common/domain/models/enums/user_role_enum.dart))
`user ↔ "REQUESTER"`, `provider ↔ "PROVIDER"`, `guest ↔ "GUEST"`.
⚠️ The unified register endpoint's role enum is `OWNER | ADMIN | REQUESTER | PROVIDER | GUEST`.

---

## 4. Presentation layer today

- **LoginCubit** → `LoginUseCase` (saves token + best-effort FCM). Password-based.
- **OTPCubit / OtpVerificationPage** — ⚠️ currently **repurposed for the
  forgot-password flow only**: `sendOTP` calls `ForgotPasswordUseCase`,
  `verifyOtp` calls `VerifyForgotPasswordUseCase` and navigates to
  `ResetPasswordPage`. Resend row is commented out. Not a general OTP screen.
- **`verify_otp_use_case.dart` is entirely commented out** (legacy).
- **UserRegister**: `UserRegisterPage` → `UserRegisterStepOne` (name, email,
  phone, gender, password, confirm) → `UserRegisterCubit` → `UserRegisterUseCase`
  → `register`. Inputs collected via `RegisterInputProvider`.
- **ProviderRegister**: `ProviderRegisterPage` (name, email, phone, country,
  gender, password, confirm, quran/hafiz) → `ProviderRegisterCubit` →
  reuses `UserRegisterUseCase`. Role hard-coded `UserRoleEnum.provider`.
- **Reusable widgets:** `EmailOrPhoneWidget` (auto-detects email vs Saudi phone),
  `EmailWidget`, `OtpPinCodeWidget` (pinput, length 6), `PhoneField`
  (`core/app_material/src/intel_phone/phone_field.dart`, intl country picker),
  and `TabBarWidget` (`core/ui/tab_bar_switcher/`) — a pill/segmented toggle we
  can reuse for the **Email | Phone** switch in the screenshots.

---

## 5. Target Backend — Unified Passwordless OTP (`/auth/otp/*`)

This is the flow we migrate onto. All under base `.../api/v1`.

### `GET /auth/otp-config` — which channels to show (public, no auth)
```jsonc
{ "channels": { "whatsapp": true, "sms": true, "call": false, "email": true },
  "registration": { "allowDirect": true } }
```
Drives the channel bottom sheet. For a **phone** identifier show the enabled
subset of `whatsapp | sms | call`; for an **email** identifier the only channel
is `email` (the `channel` param is ignored server-side).

### `POST /auth/otp/start` — step 1: send the code
Request (`OtpAuthStartDto`):
| field | req | notes |
|---|---|---|
| `email` | one-of | provide this **OR** `phoneCountryCode`+`phoneNumber` |
| `phoneCountryCode` | one-of | e.g. `+20`, `+966` |
| `phoneNumber` | one-of | national number |
| `channel` | optional | `whatsapp`(default) \| `sms` \| `call`; ignored for email |

Response: `{ otpToken, channel, accountExists, message }`. A code is sent whether
or not the account exists (never 404). `accountExists` lets us show "welcome
back" vs "let's create your account".

### `POST /auth/otp/verify` — step 2: verify the code
Request (`OtpAuthVerifyDto`): `{ otpToken, code }`.
Response is **one of**:
- **authenticated** (account exists): `{ status: "authenticated", <token pair>, user, permissions }`
- **registration_required** (new): `{ status: "registration_required", signupToken, identifier, channel }`

`400` invalid session/code · `401` account deactivated / provider rejected.

### `POST /auth/otp/register` — step 3: complete signup for a new user
Request (`OtpAuthRegisterDto`):
| field | req | notes |
|---|---|---|
| `signupToken` | ✅ | from verify |
| `role` | ✅ | `OWNER \| ADMIN \| REQUESTER \| PROVIDER \| GUEST` |
| `fullName` | ✅ | |
| `email` | cond. | required when the account was **verified via phone** |
| `phoneCountryCode`+`phoneNumber` | cond. | required when **verified via email** |
| `password` | optional | omit for OTP-only login |
| `countryCode` | optional | ISO alpha-2 (e.g. `SA`) |
| `languageCode` | ✅ | e.g. `ar` |
| `isHafiz` | optional | provider only |

Response: token pair + user (account created, contact verified). `409` if the
*other* contact is already in use.

### `POST /auth/otp/resend` — resend on the same channel
Request: `{ otpToken }` → `{ channel, message }`. `429` = cooldown.
(To resend on a **different** channel, call `otp/start` again with a new `channel`.)

> Also available but not used by the new flow: legacy `auth/register*`,
> `auth/login` (password), `auth/login-otp/*` (WhatsApp-only), the
> `forgot-password/*` + `reset-password` set (keep for the existing forgot-password
> screens), and `auth/refresh` (already wired in `TokenManager`).

---

## 6. Gap Analysis (current → target)

| Concern | Today | Target |
|---|---|---|
| Login credential | email/phone **+ password** | passwordless **OTP** (channel-based) |
| Role selection | up-front `ChooseUserTypePage` | implicit: default **REQUESTER**; **PROVIDER** via a dedicated button |
| Channel choice | none | bottom sheet from `GET /auth/otp-config` |
| Send OTP | stub `sendOTP()` | `POST /auth/otp/start` |
| Verify OTP | forgot-password only | `POST /auth/otp/verify` (authenticated vs registration_required) |
| Resend | commented out | `POST /auth/otp/resend` (+ re-`start` to change channel) |
| New-user detect | n/a | `verify` returns `registration_required` + `signupToken` |
| Register | password register with all fields | `POST /auth/otp/register` prefilled from verified identifier |
| Identifier input | `EmailOrPhoneWidget` (Saudi-only heuristic) | explicit **Email | Phone** toggle (screenshots) w/ intl phone |

---

## 7. Proposed Implementation Plan

### 7.1 Remove the user-type gate
- `GetStartedPage` "Continue" → **push `LoginPage` directly** (drop
  `ChooseUserTypePage` from the flow). Default role becomes `REQUESTER`.
- Update the other caller `settings_widgets.dart:_viewUserProfile` (guest branch)
  to push `LoginPage` instead of `ChooseUserTypePage`.
- Keep the `choose_user_type_page.dart` file but unlink it from navigation
  (or delete after confirming no other refs). It is **not** part-of `auth`.

### 7.2 Data / domain additions (part-of `auth`)
- **Endpoints:** `otpConfig`, `otpStart`, `otpVerify`, `otpRegister`, `otpResend`.
- **Enums:** `OtpChannel { whatsapp, sms, call, email }` (+ `fromApi/toApi`);
  `OtpIdentifierType { email, phone }`.
- **Models:**
  - `OtpConfig { Set<OtpChannel> channels; bool allowDirectRegister }`.
  - `OtpStartResult { String otpToken; OtpChannel channel; bool accountExists }`.
  - `OtpVerifyResult` — sealed-ish: `authenticated(TokenEntity)` |
    `registrationRequired(String signupToken, String identifier, OtpChannel channel)`.
- **Inputs:** `OtpStartInput { email? / phoneCountryCode?+phoneNumber?; OtpChannel? channel }`,
  `OtpVerifyInput { otpToken, code }`, `OtpRegisterInput { signupToken, role,
  fullName, email?, phone?, password?, countryCode?, languageCode, isHafiz? }`.
- **Repository:** add `getOtpConfig()`, `otpStart()`, `otpVerify()`,
  `otpRegister()`, `otpResend()` to `AuthRepository` + impl. Implement the
  currently-stubbed `logout()`/`deleteAccount()` opportunistically if in scope.
- **Use cases:** `GetOtpConfigUseCase`, `OtpStartUseCase`, `OtpVerifyUseCase`
  (saves token on `authenticated`), `OtpRegisterUseCase` (saves token + FCM),
  `OtpResendUseCase`. Replace the dead `send_otp` / `verify_otp` use cases.

### 7.3 Presentation
- **`AuthIdentifierForm`** (shared): Email | Phone toggle (reuse `TabBarWidget`),
  email field or intl `PhoneField`, and a "Send code" (`إرسال الرمز`) button.
  Used by both Login and Provider-registration step 1.
- **`LoginPage`** rebuild: header + `AuthIdentifierForm`; on submit → open
  **`ChannelPickerBottomSheet`** (loads `otp-config`, lists available channels,
  select one) → `otp/start` → push `OtpVerificationPage`. Add a secondary button
  **"Register as a Service Provider"** → `ProviderIdentityVerificationPage`.
- **`ChannelPickerBottomSheet`** via `AppBottomSheets.showAppBottomSheet`; shows
  only channels enabled in config (+ valid for the identifier type). Handles the
  loading/failure StateBox.
- **New `OtpAuthCubit` + state** (do **not** overload the forgot-password
  `OTPCubit`): owns `otpToken`, `channel`, `identifier`, `role`, `accountExists`;
  exposes `start`, `verify`, `resend`, `changeChannel`. `verify` emits
  `authenticated` (→ save token → `startDecider()` → Home) or
  `registrationRequired` (→ push the matching register screen with `signupToken`
  + verified identifier).
- **Generalize `OtpVerificationPage`** to accept an injected `OtpAuthCubit`, show
  the identifier, a resend affordance (with cooldown), and route on result.
  Keep the existing forgot-password path working (separate entry).
- **Register screens** consume `signupToken` + verified identifier:
  - Regular user (`registration_required`, role `REQUESTER`) → `UserRegisterPage`
    with the verified contact prefilled/locked; submit via `otp/register`.
  - Provider → `ProviderRegisterPage` with verified contact prefilled; submit via
    `otp/register` with role `PROVIDER` (+ `isHafiz`). Then the existing
    `ProviderCompleteProfilePage` continues (driven by `builder_screen`).
  - Refactor register cubits/`RegisterInputProvider` to build `OtpRegisterInput`
    (drop password requirement; the *other* contact is what's collected).

### 7.4 Provider registration (2 steps)
1. **Identity verification** — `ProviderIdentityVerificationPage` reuses
   `AuthIdentifierForm` + channel sheet + OTP, with `role = PROVIDER`. On
   `registration_required` → go to step 2; if `authenticated` (already a
   provider) → `startDecider()` → app.
2. **Registration** — existing `ProviderRegisterPage`, prefilled with the
   verified identifier, finishing via `otp/register`.

### 7.5 Regular user
`Login → otp/start → otp/verify`:
- `authenticated` → token saved → `startDecider()` → Home.
- `registration_required` → `UserRegisterPage` (role REQUESTER) prefilled →
  `otp/register` → token → Home.

---

## 7b. Implementation Status (done)

The plan above has been implemented. Resolved product decisions:
- **Login is passwordless** — the password field and inline "forgot password"
  link were removed from `LoginPage`.
- **Registration keeps password fields, but optional** — an OTP-only account is
  created if left blank; confirm-password only validates when a password is set.
- **`otp-config` is used globally** (only channel-listing endpoint), filtered by
  identifier type in the picker sheet.

New files (all `part of auth`, registered in `authentication_imports.dart`):
- `src/domain/entities/enums/otp_channel_enum.dart`
- `src/domain/entities/inputs/otp_identifier.dart`, `otp_start_input.dart`,
  `otp_verify_input.dart`, `otp_register_input.dart`
- `src/data/models/otp/otp_auth_results.dart` (`OtpConfig`, `OtpStartResult`,
  sealed `OtpVerifyResult` → `OtpAuthenticated` | `OtpRegistrationRequired`)
- `src/domain/use_cases/{get_otp_config,otp_start,otp_verify,otp_register,otp_resend}_use_case.dart`
- `src/presentation/ui/otp_auth/cubit/otp_auth_cubit.dart` + `otp_auth_state.dart`
- `src/presentation/ui/otp_auth/widgets/auth_identifier_form.dart` (Email|Phone
  toggle) + `channel_picker_bottom_sheet.dart`
- `src/presentation/ui/otp_auth/otp_auth_verification_page.dart`
- `src/presentation/ui/register/provider/provider_identity_verification_page.dart`

Changed: `auth_endpoint.dart` (+otp paths), `AuthRepository` (+5 methods) & impl,
`login_page.dart` (passwordless + provider button), `email_widget.dart` (+readOnly),
`user_register_*` & `provider_register_page.dart` (prefill/lock verified contact,
`otp/register`, optional password), `get_started_page.dart` & settings guest entry
(→ `LoginPage` instead of `ChooseUserTypePage`), en/ar ARB (+15 keys).

`choose_user_type_page.dart` is **unlinked from navigation** (kept on disk, not
deleted). `LoginCubit`/`LoginState`/`LoginUseCase` remain but are now unused.

> ✅ `flutter analyze lib` → **0 errors**; `build_runner` regenerated DI with all
> 5 OTP use cases. ⚠️ Not yet exercised on a device against the live backend —
> runtime QA (real OTP delivery per channel, token shape of the `otp/verify`
> "authenticated" response) is the remaining verification step.

---

## 8. Risks / Decisions to confirm

1. **Passwordless replaces password login?** The screenshots + spec imply the
   login screen becomes "identifier → send code" with **no password**. Proposed:
   remove the password field & the inline "forgot password" link from `LoginPage`
   (forgot-password screens remain reachable only if still needed elsewhere).
2. **`otp-config` is global**, not per-user; it's the only channel-listing
   endpoint, so the "available channels" sheet uses it (filtered by identifier
   type). Confirm this matches product intent.
3. **Phone shape**: `otp/start` wants `phoneCountryCode` (`+20`) + `phoneNumber`
   separately — use `PhoneField`/intl picker rather than the Saudi-only heuristic
   in `EmailOrPhoneWidget`.
4. **Role enum** gains `OWNER/ADMIN`; the app only sends `REQUESTER`/`PROVIDER`.
5. Register now sends the **other** contact (email when verified by phone, and
   vice-versa); `password` becomes optional.

---

_Last updated: 2026-07-12._
