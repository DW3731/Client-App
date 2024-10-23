import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/helper/cart_helper.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/quantity_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  final bool isRestaurantOpen;

  const CartProductWidget({
    super.key,
    required this.cart,
    required this.cartIndex,
    required this.isAvailable,
    required this.addOns,
    required this.isRestaurantOpen,
  });

  @override
  Widget build(BuildContext context) {
    String addOnText = CartHelper.setupAddonsText(cart: cart) ?? '';
    String variationText = CartHelper.setupVariationText(cart: cart);

    double? discount = cart.product!.restaurantDiscount == 0 ? cart.product!.discount : cart.product!.restaurantDiscount;
    String? discountType = cart.product!.restaurantDiscount == 0 ? cart.product!.discountType : 'percent';

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveHelper.isDesktop(context)
                ? Dimensions.paddingSizeSmall
                : Dimensions.paddingSizeDefault,
          ),
          child: GetBuilder<CartController>(
            builder: (cartController) {
              return Slidable(
                key: UniqueKey(),
                enabled: !cartController.isLoading,
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) => cartController.removeFromCart(cartIndex),
                      backgroundColor: Colors.redAccent, // Bright red for delete action
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      icon: Icons.delete,
                      label: 'Delete',
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), // Subtle shadow
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CustomInkWellWidget(
                    onTap: () {
                      ResponsiveHelper.isMobile(context)
                          ? showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => ProductBottomSheetWidget(
                          product: cart.product,
                          cartIndex: cartIndex,
                          cart: cart,
                        ),
                      )
                          : showDialog(
                        context: context,
                        builder: (con) => Dialog(
                          child: ProductBottomSheetWidget(
                            product: cart.product,
                            cartIndex: cartIndex,
                            cart: cart,
                          ),
                        ),
                      );
                    },
                    radius: Dimensions.radiusDefault,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall,
                        horizontal: Dimensions.paddingSizeDefault,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              cart.product!.imageFullUrl != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: CustomImageWidget(
                                  image: cart.product!.imageFullUrl!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  isFood: true,
                                ),
                              )
                                  : const SizedBox(),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            cart.product!.name!,
                                            style: robotoMedium.copyWith(
                                              fontSize: Dimensions.fontSizeLarge,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                        CustomAssetImageWidget(
                                          cart.product!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                                          height: 15,
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      PriceConverter.convertPrice(
                                        cart.product!.price,
                                        discount: discount,
                                        discountType: discountType,
                                      ),
                                      style: robotoBold.copyWith(
                                        color: Colors.green[700], // Dark green for price
                                        fontSize: Dimensions.fontSizeDefault,
                                      ),
                                    ),
                                    if (addOnText.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          '${'addons'.tr}: $addOnText',
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    if (variationText.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          '${'variations'.tr}: $variationText',
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GetBuilder<CartController>(
                            builder: (cartController) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      QuantityButton(
                                        onTap: cartController.isLoading
                                            ? null
                                            : () {
                                          if (cart.quantity! > 1) {
                                            cartController.setQuantity(false, cart);
                                          } else {
                                            cartController.removeFromCart(cartIndex);
                                          }
                                        },
                                        isIncrement: false,
                                        showRemoveIcon: cart.quantity == 1,
                                        color: Theme.of(context).primaryColorLight, // Lighter color for minus button
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: AnimatedFlipCounter(
                                          duration: const Duration(milliseconds: 600),
                                          value: cart.quantity!.toDouble(),
                                          textStyle: robotoBold.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Colors.black87, // Larger font for quantity
                                          ),
                                        ),
                                      ),
                                      QuantityButton(
                                        onTap: cartController.isLoading
                                            ? null
                                            : () => cartController.setQuantity(true, cart),
                                        isIncrement: true,
                                        color: Theme.of(context).primaryColor, // Primary color for plus button
                                      ),
                                    ],
                                  ),

                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );


  }
}
