part of app_utils;

class ShareUtils {
  //[app] is the pathPrefix
  //when you type [www.[appName].com] it will be directed to the website
  //when you type [www.[appName].com/app] it will be directed to the app
  static const String baseLink = "${Constants.appWebsiteLink}/app";

  static Rect? _getSharePositionOrigin(BuildContext context) {
    //Necessary for IPad, see sharePlus documentation
    if (!context.mounted) {
      return null;
    }

    RenderBox? box = context.findRenderObject() as RenderBox?;

    if (box != null) {
      return box.localToGlobal(Offset.zero) & box.size;
    }

    return null;
  }

  //DEEPLINK SHARES
  static Future<ShareResult> deepLinkShare(String parentId, ShareTypeEnum shareType, BuildContext context) async {
    final link = getShareLink(parentId, shareType);

    return await SharePlus.instance.share(
      ShareParams(
        uri: Uri.tryParse(link),
        subject: _getSharedSubject(shareType),
        sharePositionOrigin: _getSharePositionOrigin(context),
      ),
    );
  }

  static String getShareLink(String parentId,ShareTypeEnum parentModel) {
    return '$baseLink/${parentModel.name}/$parentId';
  }

  static String _getSharedSubject(ShareTypeEnum parentModel){
    switch(parentModel){
      case ShareTypeEnum.post:
        return appLocalizer.sharedPost;
    }
  }

  static Future<void> shareText({
    required String text,
    String? subject,
    BuildContext? context,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: context != null ? _getSharePositionOrigin(context) : null,
      ),
    );
  }

  static Future<void> shareFiles({
    required List<String> filePaths,
    String? text,
    String? subject,
  }) async {
    try {
      final List<XFile> files = [];
      for (String filePath in filePaths) {
        if (filePath.contains('asset')) {
          final assetFile = await convertAssetToXFile(filePath);
          files.add(assetFile);
        } else {
          final file = File(filePath);
          if (await file.exists()) {
            files.add(XFile(file.path));
          }
        }
      }
      await SharePlus.instance.share(ShareParams(files: files,text: text,subject: subject));
    } catch (e) {
      developer.log("[ShareUtils]", error: e.toString());
    }
  }

  static Future<XFile> convertAssetToXFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final temporaryDirectory = await path_provider.getTemporaryDirectory();
    final filePath = '${temporaryDirectory.path}/temp_files/${assetPath.split('/').last}';
    final file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return XFile(
      file.path,
    );
  }

  static Future<void> shareUri(String link) async {
    try {
      final linkUri = Uri.tryParse(link);
      if (linkUri != null) {
        // await Share.shareUri(linkUri);
      } else {
        throw "Share Invalid Link";
      }
    } catch (e) {
      developer.log("[ShareUtils]", error: e);
    }
  }

  // static Future<void> shareApp() async {
  //   const assetAppLogo = 'assets/launcher_icons/user_launcher_icon.png';
  //   const text =
  //       'Welcome to -- \nExplore the kingdoms via crafted trips and experiences!.';
  //   final subject =
  //       'Personalize your trip with professionals and enjoy an unforgettable journey.\nAnytime, anywhere, access your trip itineraries, tickets, and travel documents.'
  //       '\nYou can download our app via \n'
  //       '--------------------------------------\n'
  //       'Visit our website \n[ ${Constants.appWebsiteLink} ]'
  //       '--------------------------------------\n            '
  //       'Visit us via our socials:\n'
  //       'Instagram ${Constants.appInstagramPageLink}\n'
  //       'Facebook ${Constants.appFacebookPageLink}\n'
  //       'Linked ${Constants.appLinkedInPageLink}\n'
  //       'X ${Constants.appXPageLink}';
  //   await ShareUtils.shareFiles(
  //     filePaths: [assetAppLogo],
  //     text: '$text\n$subject',
  //   );
  // }
  static Future<void> shareApp(BuildContext context) async {
    final link = '${appLocalizer.downloadApp}\n${appLocalizer.shareAppTitleContent}\n${Constants.shareApp}';

    await SharePlus.instance.share(ShareParams(uri: Uri.tryParse(link)));
  }
}
