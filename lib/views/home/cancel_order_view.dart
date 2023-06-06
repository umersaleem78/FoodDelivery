// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/cancel_order_controller.dart';
import 'package:food_app/models/cancel_order_model.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:food_app/utils/app_utils.dart';
import 'package:food_app/views/home/dashboard_view.dart';
import 'package:get/get.dart';

import '../../utils/app_strings.dart';
import '../../widgets/app_widgets.dart';

class CancelOrderView extends HookWidget {
  const CancelOrderView({super.key});

  Widget fetchReasonsItem(
      CancelOrderModel model, Function callback, bool state) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          InkWell(
            onTap: () => callback(model.id),
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: model.isSelected
                      ? AppColors.orangeColor
                      : Colors.transparent,
                  border: Border.all(color: AppColors.orangeColor)),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: AppWidgets.appTextWithoutClick(model.name,
                color: AppColors.textColor, fontSize: 15),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CancelOrderController>();
    TextEditingController reasonController = TextEditingController();
    final orderId = Get.arguments['data'];
    final reasonsList = useState(AppUtils.fetchCancelOrdersList());
    final updateReasonsView = useState(false);
    final selectedReasonModel =
        useState(CancelOrderModel(id: -1, name: "", isSelected: false));

    void callCancelOrderApi() {
      print('Selected reason => ${selectedReasonModel.value}');
      if (selectedReasonModel.value.id != -1) {
        // status id for 'other'
        if (selectedReasonModel.value.id == 5) {
          selectedReasonModel.value.name = reasonController.text;
        }
        controller.sendCancelOrderCall(orderId, selectedReasonModel.value.name,
            () {
          Get.offAll(() => const DashboardView());
        });
      } else {
        EasyLoading.showError(AppStrings.pleaseSelectReason);
      }
    }

    void updateSelection(int newId) {
      for (var item in reasonsList.value) {
        if (item.id == newId) {
          item.isSelected = true;
          selectedReasonModel.value = item;
        } else {
          item.isSelected = false;
        }
      }
      print('Selection change => ${selectedReasonModel.value}');
      reasonsList.value = reasonsList.value;
      updateReasonsView.value = !updateReasonsView.value;
    }

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            AppWidgets.appHeader(AppStrings.cancelOrder, () => Get.back()),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 20, top: 25),
              child: AppWidgets.appText(AppStrings.cancelOrderTitle,
                  color: AppColors.textColor, fontSize: 15),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Divider(
                height: 5,
                color: AppColors.textColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 185,
              child: ListView.builder(
                itemCount: reasonsList.value.length,
                itemBuilder: (context, index) {
                  return fetchReasonsItem(reasonsList.value[index],
                      (id) => updateSelection(id), updateReasonsView.value);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.topLeft,
              child: AppWidgets.appTextWithoutClick(AppStrings.otherReason,
                  color: AppColors.orangeColor),
            ),
            Container(
                alignment: Alignment.topLeft,
                child: AppWidgets.appFieldMoreText(
                  AppStrings.otherReason,
                  reasonController,
                )),
            Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.all(20),
                child: AppWidgets.appButton(
                    AppStrings.submit, () => callCancelOrderApi())),
          ],
        )),
      ),
    );
  }
}
