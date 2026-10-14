part of zad;

class OccasionZadItem extends StatelessWidget {
  final EventModel? event;
  const OccasionZadItem({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    if (event == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        AppRouteNavigator.push(
          context,
          EventsPage.routeName,
          const EventsPage(),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Stack(
          children: [
            AppImage(
              path: event!.imageUrl != null && event!.imageUrl!.isNotEmpty
                  ? Constants.baseUrl + event!.imageUrl!
                  : '',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(16),
              errorPlaceHolder: () => Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(AssetPaths.moneebLogo, fit: BoxFit.contain),
              ),
            ),
            Container(
              width: double.infinity,
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Container(
              height: 150,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: context.appColors.primary.shade500,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AssetPaths.iconEvents,
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event!.name,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: context.appColors.neutral.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizer.daysLeft(
                            event!.daysRemaining.toString(),
                          ),
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: context.appColors.neutral.shade900,
                          ),
                        ),
                        /* const SizedBox(height: 4),
                        Text(
                          event!.date,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 10,
                            color: context.appColors.neutral.shade900
                                .withValues(alpha: 0.7),
                          ),
                        ), */
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              bottom: 8,
              end: 8,
              // alignment: AlignmentDirectional.bottomEnd,
              child: ZadActionButton(
                context: context,
                title: appLocalizer.details,
                onTap: () => AppRouteNavigator.push(
                  context,
                  EventsPage.routeName,
                  const EventsPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
