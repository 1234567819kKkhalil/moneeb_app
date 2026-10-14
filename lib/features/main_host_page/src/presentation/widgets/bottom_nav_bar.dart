part of main_host_page;

class MainHostBottomNavBar extends StatelessWidget {
  final Function(MainHostPageTabsEnum currentTap) onTap;
  final MainHostPageTabsEnum currentTab;

  const MainHostBottomNavBar({
    super.key,
    required this.onTap,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<AuthenticationBloc>().getUserRole;

    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          // left: 16.0,
          // right: 16.0,
          // bottom: 16.0,
          top: 4.0,
        ),
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: context.appColors.primary.shade300,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarItem(
                currentTab: currentTab,
                tabValue: MainHostPageTabsEnum.home,
                onTap: onTap,
              ),

              if(userRole != UserRoleEnum.guest)
              _NavBarItem(
                currentTab: currentTab,
                tabValue: MainHostPageTabsEnum.orders,
                onTap: onTap,
              ),

              if(userRole == UserRoleEnum.user)
              _NavBarItem(
                currentTab: currentTab,
                tabValue: MainHostPageTabsEnum.requestOmra,
                onTap: onTap,
              ),

              _NavBarItem(
                currentTab: currentTab,
                tabValue: MainHostPageTabsEnum.zad,
                onTap: onTap,
              ),

              _NavBarItem(
                currentTab: currentTab,
                tabValue: MainHostPageTabsEnum.profile,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final void Function(MainHostPageTabsEnum value) onTap;
  final MainHostPageTabsEnum currentTab;
  final MainHostPageTabsEnum tabValue;

  const _NavBarItem({
    required this.onTap,
    required this.currentTab,
    required this.tabValue,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentTab == tabValue;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Feedback.forTap(context);
          onTap(tabValue);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              if (isSelected)
                Positioned(
                  top: -4,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.appColors.secondary.shade500,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.appColors.secondary.shade500
                                .withValues(alpha: 0.6),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tabValue.getIcon(isSelected: isSelected),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      tabValue.getName(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: isSelected
                          ? context.regular.copyWith(
                              fontSize: Dimensions.normal + 1,
                              color: context.appColors.secondary.shade500,
                            )
                          : context.regular.copyWith(
                              fontSize: Dimensions.normal,
                              color: context.appColors.neutral.shade900,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
