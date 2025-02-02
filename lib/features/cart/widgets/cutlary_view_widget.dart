import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class CutleryViewWidget extends StatelessWidget {
  final RestaurantController restaurantController;
  final CartController cartController;

  const CutleryViewWidget({super.key, required this.restaurantController, required this.cartController});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return (restaurantController.restaurant != null && restaurantController.restaurant!.cutlery != null && restaurantController.restaurant!.cutlery!)
        ? Container(
      decoration: BoxDecoration(
        color: Colors.white, // Clean white background
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), // Uniform padding
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.flatware_rounded, size: isDesktop ? 35 : 30, color: Theme.of(context).primaryColor), // Slightly larger icon
          const SizedBox(width: Dimensions.paddingSizeDefault), // Increased spacing

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'add_cutlery'.tr,
                  style: robotoBold.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeLarge, // Larger text
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(
                  'do_not_have_cutlery'.tr,
                  style: robotoRegular.copyWith(
                    color: Colors.grey[600], // Darker grey for better contrast
                    fontSize: Dimensions.fontSizeDefault, // Slightly larger text
                  ),
                ),
              ],
            ),
          ),

          Transform.scale(
            scale: 1.1, // Increased scale for better visibility
            child: CupertinoSwitch(
              value: cartController.addCutlery,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? value) {
                cartController.updateCutlery();
              },
              trackColor: Theme.of(context).primaryColor.withOpacity(0.3), // Softer track color
            ),
          ),
        ],
      ),
    )
        : const SizedBox();
  }
}
