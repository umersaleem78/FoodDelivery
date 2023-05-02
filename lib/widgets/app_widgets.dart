import 'package:flutter/material.dart';
import 'package:food_app/utils/app_strings.dart';
import 'package:food_app/utils/app_utils.dart';
import '../utils/app_colors.dart';
import 'package:get/get.dart';

class AppWidgets {
  static Widget appText(String text,
      {Color color = Colors.black,
      double fontSize = 15,
      bool isBold = false,
      bool isClickable = false,
      bool isEllipsisText = false,
      Function? callBack}) {
    var fontType = FontWeight.normal;
    if (isBold) fontType = FontWeight.bold;
    return InkWell(
      onTap: () {
        if (isClickable && callBack != null) {
          callBack();
        }
      },
      child: Text(
        text,
        style: TextStyle(
            overflow:
                isEllipsisText ? TextOverflow.ellipsis : TextOverflow.visible,
            color: color,
            fontSize: fontSize,
            fontWeight: fontType),
      ),
    );
  }

  static Widget appTextWithoutClick(String text,
      {Color color = Colors.black,
      double fontSize = 15,
      bool isBold = false,
      bool isEllipsisText = false}) {
    var fontType = FontWeight.normal;
    if (isBold) fontType = FontWeight.bold;
    return Text(
      text,
      style: TextStyle(
          overflow:
              isEllipsisText ? TextOverflow.ellipsis : TextOverflow.visible,
          color: color,
          fontSize: fontSize,
          fontWeight: fontType),
    );
  }

  static Widget appField(String hintText, TextEditingController controller,
      {double fontSize = 15,
      TextInputAction action = TextInputAction.done,
      bool isPasswordField = false,
      TextInputType inputType = TextInputType.text,
      IconData? prefixIcon,
      bool showSuffixIcon = false,
      int maxLines = 1}) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.primaryDarkColor,
      textInputAction: action,
      obscureText: isPasswordField,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
          prefixIcon: null == prefixIcon ? null : Icon(prefixIcon),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  BorderSide(color: AppColors.primaryDarkColor, width: 2)),
          hintText: hintText),
      style: TextStyle(fontSize: fontSize),
    );
  }

  static Widget appFieldNew(String hintText, TextEditingController? controller,
      {double fontSize = 15,
      TextInputAction action = TextInputAction.done,
      bool isPasswordField = false,
      TextInputType inputType = TextInputType.text,
      IconData? prefixIcon,
      bool showSuffixIcon = false,
      bool isEditable = true,
      int maxLines = 1}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 100),
            child: Container(
              decoration: BoxDecoration(color: AppColors.dividerColor),
              alignment: Alignment.center,
              child: Text(
                hintText,
                style: TextStyle(color: AppColors.offWhiteColor, fontSize: 15),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: isEditable
                  ? AppColors.offWhiteColor
                  : AppColors.lightBlueGrey,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: controller,
                cursorColor: AppColors.primaryDarkColor,
                textInputAction: action,
                obscureText: isPasswordField,
                keyboardType: inputType,
                enabled: isEditable,
                maxLines: maxLines,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: null == prefixIcon ? null : Icon(prefixIcon)),
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget appFieldWithTitle(String hintText, String name,
      {double fontSize = 15,
      TextInputAction action = TextInputAction.done,
      bool isPasswordField = false,
      TextInputType inputType = TextInputType.text,
      IconData? prefixIcon,
      bool showSuffixIcon = false,
      bool isEditable = true,
      int maxLines = 1}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: AppColors.dividerColor),
            alignment: Alignment.center,
            width: 120,
            child: Text(
              hintText,
              style: TextStyle(color: AppColors.offWhiteColor, fontSize: 18),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              color: AppColors.lightBlueGrey,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AppWidgets.appTextWithoutClick(name, fontSize: fontSize),
            ),
          )
        ],
      ),
    );
  }

  static Widget appFieldNewPhone(
      String hintText, TextEditingController controller,
      {double fontSize = 15,
      TextInputAction action = TextInputAction.done,
      bool isPasswordField = false,
      TextInputType inputType = TextInputType.text,
      IconData? prefixIcon,
      bool showSuffixIcon = false,
      int maxLines = 1}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 100),
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.dividerColor),
              alignment: Alignment.center,
              child: Text(
                hintText,
                style: TextStyle(color: AppColors.offWhiteColor, fontSize: 18),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            child: appTextWithoutClick("+92",
                color: AppColors.dividerColor, fontSize: 14, isBold: true),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: controller,
                cursorColor: AppColors.primaryDarkColor,
                textInputAction: action,
                obscureText: isPasswordField,
                keyboardType: inputType,
                maxLines: maxLines,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: null == prefixIcon ? null : Icon(prefixIcon)),
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget appPassowrdField(String hintText,
      TextEditingController controller, bool obscureText, Function callBack,
      {double fontSize = 15,
      TextInputAction action = TextInputAction.done,
      int maxLines = 1}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 100),
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.dividerColor),
              alignment: Alignment.center,
              child: Text(
                hintText,
                style: TextStyle(color: AppColors.offWhiteColor, fontSize: 15),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: controller,
                cursorColor: AppColors.primaryDarkColor,
                textInputAction: action,
                obscureText: obscureText,
                keyboardType: TextInputType.text,
                maxLines: maxLines,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => callBack(),
                    ),
                    border: InputBorder.none),
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget addIconButton(Function callback) {
    return IconButton(
        onPressed: () => callback(), icon: const Icon(Icons.add_circle));
  }

  static Widget removeIconButton(Function callback) {
    return IconButton(
        onPressed: () => callback(), icon: const Icon(Icons.remove_circle));
  }

  static Widget fetchIncrementDecrementCounter(Function callback,
      {int? initialValue}) {
    final number = (initialValue ?? 1).obs;
    const maxQuantity = 30;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.primaryTextColor),
                shape: BoxShape.rectangle,
                color: AppColors.offWhiteColor,
                borderRadius: BorderRadius.circular(5)),
            child: IconButton(
                onPressed: () {
                  final newNumber = number.value - 1;
                  if (newNumber > 0) {
                    number.value = newNumber;
                    callback(newNumber);
                  } else {
                    callback(0);
                  }
                },
                icon: const Icon(
                  Icons.remove,
                  size: 12,
                )),
          ),
          Obx(
            () => AppWidgets.appText(number.value.toString(),
                fontSize: 16, color: AppColors.primaryTextColor, isBold: true),
          ),
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.primaryTextColor),
                shape: BoxShape.rectangle,
                color: AppColors.offWhiteColor,
                borderRadius: BorderRadius.circular(5)),
            child: IconButton(
                onPressed: () {
                  final newNumber = number.value + 1;
                  if (newNumber <= maxQuantity) {
                    number.value = number.value + 1;
                    callback(newNumber);
                  } else {
                    AppUtils.showSnackbar(
                        AppStrings.info, AppStrings.maxQuantityReached);
                  }
                },
                icon: const Icon(
                  Icons.add,
                  size: 12,
                )),
          )
        ],
      ),
    );
  }

  static Widget appButton(String text, Function callBack, {Color? bgColor}) {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => callBack(),
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              backgroundColor:
                  MaterialStateProperty.all(bgColor ?? AppColors.primaryColor)),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ));
  }

  static Widget appHeader(String title, Function callBack,
      {Color textColor = Colors.black26}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
      child: Row(
        children: [
          IconButton(
              onPressed: () => callBack(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryTextColor,
              )),
          appText(title, isBold: true, fontSize: 20, color: textColor)
        ],
      ),
    );
  }

  static Widget appLoader(context) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.primaryLightColor,
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          color: AppColors.primaryDarkColor,
        ),
      ),
    );
  }

  static Widget appErrorWidget(context, String title, String message) {
    return SizedBox(
      width: 300,
      height: 120,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appText(title, isBold: true, fontSize: 15),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close))
            ],
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: appText(message, fontSize: 17))
        ],
      ),
    );
  }

  static void appErrorView(context, String title, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              content: Builder(builder: (context) {
                return appErrorWidget(context, title, message);
              }),
            ));
  }

  static void openYesNoAlertDialog(
      String title, String description, Function callback) {
    Widget noBtn = TextButton(
        onPressed: () {
          Navigator.of(Get.context as BuildContext).pop();
          callback(false);
        },
        child: Text(AppStrings.no));
    Widget yesBtn = TextButton(
        onPressed: () {
          Navigator.of(Get.context as BuildContext).pop();
          callback(true);
        },
        child: Text(AppStrings.yes));

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [noBtn, yesBtn],
    );

    showDialog(
        context: Get.context as BuildContext,
        builder: ((context) => alertDialog));
  }
}
