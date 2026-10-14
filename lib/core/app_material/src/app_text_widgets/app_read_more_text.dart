part of app_material;

class AppReadMoreText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final int? trimLines;
  final TextStyle? moreAndLessStyle;
  final ValueNotifier<bool>? isCollapsed;
  final bool isExpandable;

  //TODO: Fix this
  final List<UserBaseEntity>? mentionedUsers;
  // final List<HashtagEntity>? hashtags;

  final double? alignWidthFactor;
  final bool addSelectionArea;
  final bool putTrimTextInNewLine;
  final TextAlign? textAlign;

  const AppReadMoreText({
    super.key,
    required this.text,
    this.textStyle,
    this.trimLines,
    this.moreAndLessStyle,
    this.isCollapsed,
    this.mentionedUsers,
    // this.hashtags,
    this.isExpandable = true,
    this.alignWidthFactor ,
    this.addSelectionArea = true,
    this.putTrimTextInNewLine = false,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = text.getTextDirection;

    final child = Align(
      widthFactor: alignWidthFactor,

      alignment: textAlign == TextAlign.center
          ? Alignment.center
          : textDirection == TextDirection.ltr
              ? Alignment.centerLeft
              : Alignment.centerRight,
      child: ReadMoreText(
        text,
        textDirection: textDirection,
        textAlign: textAlign,
        isExpandable: isExpandable,

        annotations: [
          //TODO: Fix this
/*          if (hashtags != null)
            Annotation(
              regExp: AppRegex.hashtagRegex,
              spanBuilder: ({required String text, TextStyle? textStyle}) =>
                  TextSpan(
                    text: text,
                    style: textStyle?.copyWith(
                        color: context.appColors.primary.shade50,
                        fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //TODO: Fix this
                        // final hashtagEntity = hashtags!.firstWhereOrNull((e) =>
                        // "#${e.name.toLowerCase()}" == text.toLowerCase());
                        // if (hashtagEntity == null) return;
                        // if (!NavObserver.instance
                        //     .isCurrentPage(SearchPage.routeName)) {
                        //   AppRouteNavigator.push(
                        //     context,
                        //     SearchPage.routeName,
                        //     SearchPage(
                        //       hashtagSearchText:"#${hashtagEntity.name}",
                        //     ),
                        //   );
                        // } else {
                        //   try {
                        //     final searchCubit = context.read<SearchViewBloc>();
                        //     final currentHashtagSearchKey = searchCubit.getSearchInput?.filterInput?.searchKey;
                        //     if (currentHashtagSearchKey != hashtagEntity.name) {
                        //       searchCubit.searchTextSubmitter.add("#${hashtagEntity.name}");
                        //     }
                        //   } catch (e) {
                        //     debugPrint("CATCH ERROR :");
                        //   }
                        // }
                      },
                  ),
            ),*/
          if (mentionedUsers != null)
            Annotation(
              regExp: AppRegex.mentionRegex,
              spanBuilder: ({required String text, TextStyle? textStyle}) {
                final normalized = text.trim().toLowerCase();
                final mentionedUser = mentionedUsers!.firstWhereOrNull((user) {
                  final fullName = "@${user.fullName}".toLowerCase();
                  return fullName == normalized;
                });

                return TextSpan(
                  text: text,
                  style: textStyle?.copyWith(
                    color: mentionedUser == null
                        ? context.appColors.neutral.shade900
                        : context.appColors.primary.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (mentionedUser != null) {
                        //TODO: Fix this
                        // CommonNavigation.navigateToProfilePage(
                        //   context: context,
                        //   userId: mentionedUser.id,
                        //   userRole: mentionedUser.role,
                        // );
                      }
                    },
                );
              },
            ),

          Annotation(
              regExp: AppRegex.linkRegExp,
              spanBuilder: ({required String text, TextStyle? textStyle}) {
                return TextSpan(
                  text: text,
                  style: textStyle?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      //TODO: Fix this
                      // appUrlLauncher(context: context, url: text);
                    },
                );
              }),
        ],

        trimLines: trimLines ?? 5,
        trimMode: TrimMode.Line,
        moreStyle: moreAndLessStyle ??
            context.semiBold.copyWith(
                height: 1.6,
                color: context.appColors.primary.shade500
            ),
        lessStyle: moreAndLessStyle ??
            context.semiBold.copyWith(
                height: 1.6,
                color: context.appColors.primary.shade500
            ),
        trimCollapsedText: putTrimTextInNewLine ? "\n${appLocalizer.viewMore}" : appLocalizer.viewMore,
        trimExpandedText: putTrimTextInNewLine ? "\n${appLocalizer.viewLess}" : appLocalizer.viewLess,
        isCollapsed: isCollapsed,
        style: textStyle ?? context.regular,
      ),
    );

    if (addSelectionArea) {
      return SelectionArea(child: child);
    } else {
      return child;
    }
  }
}
