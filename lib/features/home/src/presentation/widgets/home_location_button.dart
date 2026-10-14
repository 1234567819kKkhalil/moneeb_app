part of home;

/// Reactive "Set Location" button shown in the home top bar.
///
/// On first build it asks [LocationService] to resolve the location
/// (cached value shown immediately, otherwise the acquisition flow runs).
/// Tapping it opens a confirmation dialog that re-runs the acquisition flow.
class HomeLocationButton extends StatefulWidget {
  const HomeLocationButton({super.key});

  @override
  State<HomeLocationButton> createState() => _HomeLocationButtonState();
}

class _HomeLocationButtonState extends State<HomeLocationButton> {
  StreamSubscription<StateBox<LocationData>>? _subscription;
  StateBox<LocationData> _state = LocationService.instance.currentLocationState;

  @override
  void initState() {
    super.initState();

    // Rebuild on every location state change and surface failures as snackbars.
    _subscription = LocationService.instance.locationStream.listen((state) {
      if (!mounted) return;
      setState(() => _state = state);
      if (state.isFailure) _handleFailure(state.failure);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleFailure(Failure? failure) {
    if (failure is! LocationFailure) return;

    if (failure.isDeniedForEver) {
      // Permanently denied → direct the user to the app settings.
      AppAlerts.showOpenPermissionsSettingsDialog(
        context,
        onOpenSettingsPressed: () {
          LocationService.instance.openAppLocationSettings();
        },
      );
    } else if (failure.isLocationServiceDisabled) {
      // GPS service off → prompt the user to enable it.
      AppToasts.error(
        context,
        message: appLocalizer.enableLocationServicePrompt,
      );
    }
  }

  Future<void> _onTap() async {
    final String label = _state.data?.label ?? '';

    await AppAlerts.showDecisionDialog(
      context,
      title: appLocalizer.updateLocationTitle,
      description:
          appLocalizer.updateLocationConfirmation +
          (label.isNotEmpty ? "\n\n(${label})" : ''),
      actionButtons: [
        DecisionButtonModel(
          title: appLocalizer.yesUpdate,
          isPrimary: true,
          onTap: (ctx) {
            AppRouteNavigator.pop(ctx);
            // Re-runs the flow; the stream drives the loading indicator below.
            LocationService.instance.refreshLocation();
          },
        ),
        DecisionButtonModel(
          title: appLocalizer.cancel,
          onTap: (ctx) => AppRouteNavigator.pop(ctx),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color gold = context.appColors.secondary.shade300;
    final String label = _state.data?.label ?? appLocalizer.selectLocationHint;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 14, color: gold),
          const SizedBox(width: 4),
          if (_state.isLoading)
            Skeletonizer(enabled: true, child: Text('Loading.........!'))
          else
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: gold,
                ),
              ),
            ),
          const SizedBox(width: 2),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: gold),
        ],
      ),
    );
  }
}
