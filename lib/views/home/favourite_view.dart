import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_app/controllers/favourites_controller.dart';
import 'package:food_app/models/items_model.dart';
import 'package:food_app/state/response_state.dart';
import 'package:food_app/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../utils/app_strings.dart';
import '../../widgets/app_widgets.dart';

class FavouriteView extends HookWidget {
  const FavouriteView({super.key});

  Widget fetchFavouriteItem(ItemsModel model, Function callback) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.lightBlackColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 15, 5, 15),
            child: Image.network(
              model.image ?? "",
              width: 75,
              height: 75,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: AppWidgets.appTextWithoutClick(model.name ?? "",
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        child: AppWidgets.appTextWithoutClick(
                            "${model.currency} ${model.price}",
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: AppWidgets.appTextWithoutClick(
                        model.description ?? "",
                        color: AppColors.lightWhiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () => callback(model),
                      icon: Icon(
                        Icons.favorite,
                        color: AppColors.statusColorPending,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavouritesController>();
    final state = useState(ResponseState.loading);
    final favouritesList = useState([]);
    final fetchUpdatedList = useState(false);

    useEffect(() {
      state.value = ResponseState.loading;
      controller.fetchFavourites().then((value) {
        if (value != null && value.length > 0) {
          favouritesList.value = value;
          state.value = ResponseState.completed;
        } else {
          state.value = ResponseState.noDataFound;
        }
      });
      return null;
    }, [fetchUpdatedList]);

    void updateFavouritesList(String id) {
      for (var i = 0; i < favouritesList.value.length; i++) {
        final item = favouritesList.value[i];
        if (item.id == id) {
          favouritesList.value.removeAt(i);
        }
      }
      if (favouritesList.value.isEmpty) {
        state.value = ResponseState.noDataFound;
      }
      fetchUpdatedList.value = !fetchUpdatedList.value;
    }

    Widget fetchNoDataFoundView() {
      return Center(
          child: AppWidgets.appText(AppStrings.noFavouritesFound,
              color: AppColors.textColor,
              fontSize: 25,
              fontWeight: FontWeight.w600));
    }

    Widget fetchFavouriteView() {
      return Column(children: [
        Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: AppWidgets.appTextWithoutClick(AppStrings.favourites,
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500)),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: favouritesList.value.length,
              itemBuilder: (BuildContext context, int index) {
                final model = favouritesList.value[index];
                return fetchFavouriteItem(model, (model) async {
                  await controller.removeFromFavourites(model);
                  updateFavouritesList(model.id);
                });
              },
            ),
          ),
        )
      ]);
    }

    Widget fetchMainView(ResponseState status) {
      if (status == ResponseState.loading) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.orangeColor,
          ),
        );
      } else if (status == ResponseState.completed) {
        return fetchFavouriteView();
      }
      // default:: no data found state
      return fetchNoDataFoundView();
    }

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
          // ignore: invalid_use_of_protected_member
          child: fetchMainView(state.value)),
    );
  }
}
