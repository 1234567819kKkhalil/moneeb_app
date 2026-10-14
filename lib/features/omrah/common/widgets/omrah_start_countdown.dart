import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

/// Rebuilds every second with the time left until an umrah may begin, and
/// stops ticking as soon as that moment passes (the last build gets
/// [Duration.zero]). Orders without a target date are already "started".
class OmrahCountdownBuilder extends StatefulWidget {
  final DateTime? targetDate;
  final Widget Function(BuildContext context, Duration remaining) builder;

  const OmrahCountdownBuilder({
    super.key,
    required this.targetDate,
    required this.builder,
  });

  @override
  State<OmrahCountdownBuilder> createState() => _OmrahCountdownBuilderState();
}

class _OmrahCountdownBuilderState extends State<OmrahCountdownBuilder> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _readRemaining();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant OmrahCountdownBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetDate != widget.targetDate) {
      _remaining = _readRemaining();
      _startTimerIfNeeded();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration _readRemaining() =>
      OmrahSchedule.remaining(widget.targetDate) ?? Duration.zero;

  void _startTimerIfNeeded() {
    _timer?.cancel();
    if (_remaining == Duration.zero) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = _readRemaining();
      if (next == Duration.zero) _timer?.cancel();
      if (mounted) setState(() => _remaining = next);
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _remaining);
}

/// One-line "starts in 6 days and 3 hours" text, live. Renders nothing once
/// the time has come.
class OmrahCountdownLabel extends StatelessWidget {
  final DateTime? targetDate;
  final TextStyle? style;

  const OmrahCountdownLabel({super.key, required this.targetDate, this.style});

  static String _two(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return OmrahCountdownBuilder(
      targetDate: targetDate,
      builder: (context, remaining) {
        if (remaining == Duration.zero) return const SizedBox.shrink();

        final String text = remaining.inDays > 0
            ? appLocalizer.startsInDaysHours(
                remaining.inDays,
                remaining.inHours % 24,
              )
            : appLocalizer.startsInClock(
                '${_two(remaining.inHours)}:${_two(remaining.inMinutes % 60)}'
                ':${_two(remaining.inSeconds % 60)}',
              );

        return Text(text, style: style);
      },
    );
  }
}

/// Countdown card shown to whoever is waiting for the umrah day: the provider
/// (who may not start earlier) and the requester (who follows the wait).
/// Flips to a "time has come" state by itself when the day arrives.
class OmrahStartCountdownCard extends StatelessWidget {
  final DateTime? targetDate;
  final bool isProvider;

  /// Optional line under the title, e.g. the beneficiary name.
  final String? subtitle;
  final VoidCallback? onTap;

  const OmrahStartCountdownCard({
    super.key,
    required this.targetDate,
    required this.isProvider,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gold = context.appColors.secondary.shade500;

    return GestureDetector(
      onTap: onTap,
      child: OmrahCountdownBuilder(
        targetDate: targetDate,
        builder: (context, remaining) {
          final bool arrived = remaining == Duration.zero;
          final accent = arrived ? context.appColors.success.shade500 : gold;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.appColors.primary.shade400,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context, accent, arrived),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: arrived
                      ? _arrivedMessage(context, accent)
                      : _timeBoxes(context, remaining),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, Color accent, bool arrived) {
    final startDate = OmrahSchedule.startOf(targetDate);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withValues(alpha: 0.15),
            border: Border.all(color: accent.withValues(alpha: 0.6)),
          ),
          child: Icon(
            arrived ? Iconsax.tick_circle : Iconsax.timer_1,
            size: 18,
            color: accent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isProvider
                    ? appLocalizer.omrahStartsIn
                    : appLocalizer.omrahStartsInUser,
                style: context.bold.copyWith(
                  fontSize: 12,
                  color: context.appColors.neutral.shade900,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.regular.copyWith(fontSize: 10, color: accent),
                ),
              ],
              if (startDate != null) ...[
                const SizedBox(height: 2),
                Text(
                  appLocalizer.omrahStartDate(startDate.toDDMMMyyyy),
                  style: context.regular.copyWith(
                    fontSize: 10,
                    color: context.appColors.neutral.shade900.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeBoxes(BuildContext context, Duration remaining) {
    return Row(
      key: const ValueKey('boxes'),
      children: [
        _TimeBox(value: remaining.inDays, label: appLocalizer.countdownDays),
        const SizedBox(width: 8),
        _TimeBox(
          value: remaining.inHours % 24,
          label: appLocalizer.countdownHours,
        ),
        const SizedBox(width: 8),
        _TimeBox(
          value: remaining.inMinutes % 60,
          label: appLocalizer.countdownMinutes,
        ),
        const SizedBox(width: 8),
        _TimeBox(
          value: remaining.inSeconds % 60,
          label: appLocalizer.countdownSeconds,
        ),
      ],
    );
  }

  Widget _arrivedMessage(BuildContext context, Color accent) {
    return Container(
      key: const ValueKey('arrived'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isProvider
            ? appLocalizer.omrahTimeArrivedProvider
            : appLocalizer.omrahTimeArrivedUser,
        style: context.medium.copyWith(
          fontSize: 11,
          height: 1.5,
          color: context.appColors.neutral.shade900,
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final int value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final gold = context.appColors.secondary.shade500;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: gold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: gold.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                value.toString().padLeft(2, '0'),
                key: ValueKey(value),
                style: context.bold.copyWith(fontSize: 20, color: gold),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: context.regular.copyWith(
                fontSize: 9,
                color: context.appColors.neutral.shade900.withValues(
                  alpha: 0.75,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows [child] once the umrah day has arrived, and a locked page with the
/// countdown until then. Guards screens that must not be usable earlier, e.g.
/// the provider's rituals, whichever route the provider took to reach them.
class OmrahStartGate extends StatelessWidget {
  final DateTime? targetDate;
  final Widget child;

  const OmrahStartGate({
    super.key,
    required this.targetDate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return OmrahCountdownBuilder(
      targetDate: targetDate,
      builder: (context, remaining) {
        if (remaining == Duration.zero) return child;

        final startDate = OmrahSchedule.startOf(targetDate)!;

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.lock_1,
                  size: 44,
                  color: context.appColors.secondary.shade500,
                ),
                const SizedBox(height: 16),
                Text(
                  appLocalizer.omrahNotStartedYet(startDate.toDDMMMyyyy),
                  textAlign: TextAlign.center,
                  style: context.medium.copyWith(fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 24),
                OmrahStartCountdownCard(targetDate: targetDate, isProvider: true),
              ],
            ),
          ),
        );
      },
    );
  }
}
