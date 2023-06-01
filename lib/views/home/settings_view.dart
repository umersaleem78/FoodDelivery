import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/settings_controller.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/auth/login_view.dart';
import 'package:food_app/views/home/profile_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SettingsView extends HookWidget {
  const SettingsView({super.key});

  Widget fetchSettingsRowWidget(String title, IconData prefixIcon,
      IconData? suffixIcon, Function callback) {
    return InkWell(
      onTap: () => callback(),
      child: Card(
        color: AppColors.lightBlackColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        clipBehavior: Clip.antiAlias,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                prefixIcon,
                size: 24,
                color: AppColors.orangeColor,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: AppWidgets.appTextWithoutClick(title,
                      color: AppColors.textColor, fontSize: 18),
                ),
              ),
              suffixIcon != null
                  ? Icon(
                      suffixIcon,
                      size: 24,
                      color: AppColors.orangeColor,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    var isUserLoggedIn = useState(false);

    void checkLoginStatus() {
      isUserLoggedIn.value = AppState.userModel != null;
    }

    useEffect(() {
      checkLoginStatus();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: VisibilityDetector(
          key: const Key('my-widget-key'),
          onVisibilityChanged: (info) => checkLoginStatus(),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: isUserLoggedIn.value
                ? Column(children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: AppWidgets.appTextWithoutClick(
                            AppStrings.settings,
                            color: AppColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: fetchSettingsRowWidget(
                          AppStrings.profile,
                          Icons.person,
                          Icons.arrow_right_outlined,
                          () => GoNavigation.to(() => const ProfileView())),
                    ),
                    Container(
                      child: fetchSettingsRowWidget(AppStrings.shareApp,
                          Icons.share, null, () => AppUtils.shareApp()),
                    ),
                    Container(
                      child: fetchSettingsRowWidget(
                          AppStrings.logout,
                          Icons.logout,
                          null,
                          () => controller
                              .confirmLogout(() => checkLoginStatus())),
                    )
                  ])
                : Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.all(20),
                        child: AppWidgets.appTextWithoutClick(
                            AppStrings.settings,
                            fontSize: 20,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        child: fetchSettingsRowWidget(
                            AppStrings.login,
                            Icons.login,
                            null,
                            () => GoNavigation.to(() => const LoginView())
                                .then((value) => checkLoginStatus())),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
