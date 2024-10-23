import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutButtonWidget extends StatelessWidget {
  final CartController cartController;
  final List<bool> availableList;
  final bool isRestaurantOpen;

  const CheckoutButtonWidget({
    super.key,
    required this.cartController,
    required this.availableList,
    required this.isRestaurantOpen,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = 0;
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: Dimensions.webMaxWidth,
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: Dimensions.paddingSizeDefault,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4), // Deeper shadow for depth
          ),
        ],
      ),
      child: SafeArea(
        child: GetBuilder<RestaurantController>(
          builder: (restaurantController) {
            if (Get.find<RestaurantController>().restaurant != null &&
                Get.find<RestaurantController>().restaurant!.freeDelivery != null &&
                !Get.find<RestaurantController>().restaurant!.freeDelivery! &&
                Get.find<SplashController>().configModel!.freeDeliveryOver != null) {
              percentage =
                  cartController.subTotal / Get.find<SplashController>().configModel!.freeDeliveryOver!;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Free Delivery Progress
                (restaurantController.restaurant != null &&
                    restaurantController.restaurant!.freeDelivery != null &&
                    !restaurantController.restaurant!.freeDelivery! &&
                    Get.find<SplashController>().configModel!.freeDeliveryOver != null &&
                    percentage < 1)
                    ? Padding(
                  padding: EdgeInsets.only(bottom: isDesktop ? Dimensions.paddingSizeLarge : 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(Images.percentTag, height: 20, width: 20),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          PriceConverter.convertAnimationPrice(
                            Get.find<SplashController>().configModel!.freeDeliveryOver! - cartController.subTotal,
                            textStyle: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            'more_for_free_delivery'.tr,
                            style: robotoMedium.copyWith(color: Colors.grey[700]), // Softer gray
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey[300], // Lighter background for progress
                        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                        value: percentage,
                      ),
                    ],
                  ),
                )
                    : const SizedBox(),

                // Subtotal Display
                !isDesktop
                    ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('subtotal'.tr, style: robotoMedium.copyWith(color: Colors.black87)),
                      PriceConverter.convertAnimationPrice(
                        cartController.subTotal,
                        textStyle: robotoRegular.copyWith(color: Colors.black87),
                      ),
                    ],
                  ),
                )
                    : const SizedBox(),

                // Checkout Button
                GetBuilder<CartController>(builder: (cartController) {
                  return CustomButtonWidget(
                    radius: 50,
                    buttonText: 'confirm_delivery_details'.tr,
                    onPressed: cartController.isLoading || restaurantController.restaurant == null
                        ? null
                        : () {
                      _processToCheckoutButtonPressed(restaurantController);
                    },
                    color: Theme.of(context).primaryColor, // Button color based on theme
                    textColor: Colors.white, // Button text color

                  );
                }),
                SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),
              ],
            );
          },
        ),
      ),
    );
  }

  void _processToCheckoutButtonPressed(RestaurantController restaurantController) {
    if (!cartController.cartList.first.product!.scheduleOrder! && cartController.availableList.contains(false)) {
      showCustomSnackBar('one_or_more_product_unavailable'.tr);
    } else if (restaurantController.restaurant!.freeDelivery == null || restaurantController.restaurant!.cutlery == null) {
      showCustomSnackBar('restaurant_is_unavailable'.tr);
    } /* else if(!isRestaurantOpen) {
      showCustomSnackBar('restaurant_is_close_now'.tr);
    } */ else {
      Get.find<CouponController>().removeCouponData(false);
      Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
    }
  }
}
