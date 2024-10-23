import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationBannerViewWidget extends StatelessWidget {
  const LocationBannerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
        vertical: Dimensions.paddingSizeSmall,
      ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(themeController.darkTheme ? 0.5 : 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 /* Text(
                    'find_nearby'.tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),*/
                  SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(
                    'restaurant_near_from_you'.tr,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(RouteHelper.getMapViewRoute()),
              child: Icon(
                Icons.near_me_outlined,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
           /* CustomButtonWidget(
              buttonText: 'see_location'.tr,
              width: 140,
              height: 46,
              fontSize: Dimensions.fontSizeLarge,
              radius: Dimensions.radiusDefault,
              onPressed: () => Get.toNamed(RouteHelper.getMapViewRoute()),
            ),*/

          ],
        ),
      ),
    );
  }
}
