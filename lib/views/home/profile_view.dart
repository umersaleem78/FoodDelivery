import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/state/app_state.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_images.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/go_navigation.dart';
import 'package:food_app/views/auth/login_view.dart';
import 'package:food_app/views/auth/sign_up_view.dart';
import 'package:food_app/widgets/app_widgets.dart';
import 'package:get/get.dart';

class ProfileView extends HookWidget {
  const ProfileView({super.key});

  Widget fetchLoginAndSignUpView(Function callback) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: AppWidgets.appText(AppStrings.notLoggedInMessage)),
          AppWidgets.appButton(AppStrings.login, () async {
            var response = await GoNavigation.to(() => const LoginView());
            callback(response);
          }),
          AppWidgets.appButton(AppStrings.signUp, () async {
            var response = await GoNavigation.to(() => const SignUpView());
            callback(response);
          }),
          SizedBox(
              width: 100,
              child: AppWidgets.appButton(AppStrings.close, () {
                Get.back();
              }, bgColor: AppColors.colorGrey))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = useState('');
    final email = useState('');
    final phone = useState('');

    var isUserLoggedIn = useState(false);

    void checkLoginState() async {
      var userData = AppState.userModel;
      isUserLoggedIn.value = userData != null;
      if (isUserLoggedIn.value) {
        name.value = userData?.name ?? "";
        email.value = userData?.email ?? "";
        phone.value = userData?.phoneNumber ?? "";
      }
    }

    useEffect(() {
      checkLoginState();
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: isUserLoggedIn.value == true
            ? Column(
                children: [
                  AppWidgets.appHeader(AppStrings.profile, () => Get.back(),
                      textColor: AppColors.primaryTextColor),
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage(AppImages.profilePlaceholder),
                        radius: 50,
                      )),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: AppWidgets.appFieldWithTitle(
                        AppStrings.name, name.value,
                        isEditable: false),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: AppWidgets.appFieldWithTitle(
                        AppStrings.email, email.value,
                        isEditable: false),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: AppWidgets.appFieldWithTitle(
                        AppStrings.phone, phone.value,
                        isEditable: false),
                  ),
                ],
              )
            : fetchLoginAndSignUpView((data) {
                checkLoginState();
              }),
      ),
    );
  }
}
