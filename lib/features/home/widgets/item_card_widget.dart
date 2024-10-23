import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_favourite_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ItemCardWidget extends StatelessWidget {
  final Product product;
  final bool? isBestItem;
  final bool? isPopularNearbyItem;
  final bool isCampaignItem;
  final double width;
  const ItemCardWidget({super.key, required this.product, this.isBestItem, this.isPopularNearbyItem = false, this.isCampaignItem = false, this.width = 190});

  @override
  Widget build(BuildContext context) {
    double price = product.price!;
    double discount = product.discount!;
    double discountPrice = PriceConverter.convertWithDiscount(price, discount, product.discountType)!;

    CartModel cartModel = CartModel(
      null, price, discountPrice, (price - discountPrice),
      1, [], [], isCampaignItem, product, [], product.cartQuantityLimit, [],
    );

    return Container(
      width: isPopularNearbyItem! ? double.infinity : width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: CustomInkWellWidget(
        onTap: () {
          ResponsiveHelper.isMobile(context)
              ? Get.bottomSheet(
            ProductBottomSheetWidget(product: product, isCampaign: isCampaignItem),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          )
              : Get.dialog(
            Dialog(child: ProductBottomSheetWidget(product: product, isCampaign: isCampaignItem)),
          );
        },
        radius: Dimensions.radiusDefault,
        child: Column(
          children: [
            // Partie Image du produit
            Expanded(
              flex: ResponsiveHelper.isDesktop(context) ? 5 : 6,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: isCampaignItem
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                    child: ClipRRect(
                      borderRadius: isCampaignItem
                          ? BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusLarge), topRight: Radius.circular(Dimensions.radiusLarge))
                          : BorderRadius.circular(Dimensions.radiusExtraLarge),
                      child: CustomImageWidget(
                        image: !isCampaignItem ? '${product.imageFullUrl}' : '${product.imageFullUrl}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        isFood: true,
                      ),
                    ),
                  ),

                  // Tag de réduction
                  DiscountTagWidget(
                    discount: product.restaurantDiscount! > 0 ? product.restaurantDiscount : product.discount,
                    discountType: product.restaurantDiscount! > 0 ? 'percent' : product.discountType,
                    fromTop: isCampaignItem ? 5 : 10, fontSize: Dimensions.fontSizeSmall, paddingVertical: 5, fromLeft: -5,
                  ),

                  // Bouton d'ajout au panier (plus moderne)
                  Positioned(
                    bottom: Dimensions.paddingSizeSmall,
                    right: Dimensions.paddingSizeSmall,
                    child: GetBuilder<ProductController>(builder: (productController) {
                      return GetBuilder<CartController>(builder: (cartController) {
                        int cartQty = cartController.cartQuantity(product.id!);
                        return cartQty != 0
                            ? Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          ),
                          child: Row(children: [
                            IconButton(
                              onPressed: cartController.isLoading ? null : () {
                                if (cartController.cartList[cartController.isExistInCart(product.id, null)].quantity! > 1) {
                                  cartController.setQuantity(false, cartModel);
                                } else {
                                  cartController.removeFromCart(cartController.isExistInCart(product.id, null));
                                }
                              },
                              icon: Icon(Icons.remove, size: 18, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Text(cartQty.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white)),
                            ),
                            IconButton(
                              onPressed: cartController.isLoading ? null : () {
                                cartController.setQuantity(true, cartModel);
                              },
                              icon: Icon(Icons.add, size: 18, color: Colors.white),
                            ),
                          ]),
                        )
                            : InkWell(
                          onTap: () {
                            // Remove the isCampaignItem condition to make sure onTap works for all products
                            Get.bottomSheet(
                              ProductBottomSheetWidget(product: product, isCampaign: isCampaignItem),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.add_shopping_cart, color: Theme.of(context).primaryColor, size: 24),
                          ),
                        );

                      });
                    }),
                  ),
                ],
              ),
            ),

            // Partie texte du produit (nom, rating, prix)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nom du restaurant
                    Text(
                      product.restaurantName ?? '',
                      style: robotoRegular.copyWith(color: Colors.grey.shade800, fontSize: Dimensions.fontSizeSmall),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // Nom du produit
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.name ?? '',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        // Indicateur Veg/Non-Veg
                        if (Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                          Image.asset(
                            product.veg == 0 ? Images.nonVegImage : Images.vegImage,
                            height: 14,
                            width: 14,
                          ),
                      ],
                    ),

                    // Rating du produit
                    Row(
                      children: [
                        Text(
                          product.avgRating!.toStringAsFixed(1),
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Icon(Icons.star, color: Theme.of(context).primaryColor, size: 16),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '(${product.ratingCount})',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.grey.shade600),
                        ),
                      ],
                    ),

                    // Prix avec réduction affichée
                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (discountPrice < price)
                          Text(
                            PriceConverter.convertPrice(price),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        if (discountPrice < price)
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          PriceConverter.convertPrice(discountPrice),
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.green.shade800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  void _showCartSnackBar() {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: ResponsiveHelper.isDesktop(Get.context) ?  EdgeInsets.only(
        right: Get.context!.width * 0.7,
        left: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall,
      ) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      action: SnackBarAction(label: 'view_cart'.tr, textColor: Colors.white, onPressed: () {
        Get.toNamed(RouteHelper.getCartRoute());
      }),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      content: Text(
        'item_added_to_cart'.tr,
        style: robotoMedium.copyWith(color: Colors.white),
      ),
    ));
  }
}


class ItemCardShimmer extends StatelessWidget {
  final bool? isPopularNearbyItem;
  const ItemCardShimmer({super.key, this.isPopularNearbyItem});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: ResponsiveHelper.isDesktop(context) ? 285 : 280,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: (isPopularNearbyItem! && ResponsiveHelper.isMobile(context)) ? 1 : 5,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: ResponsiveHelper.isDesktop(context) ? 200 : MediaQuery.of(context).size.width * 0.53,
                    height: ResponsiveHelper.isDesktop(context) ? 285 : 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).shadowColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: ResponsiveHelper.isDesktop(context) ? 5 : 6,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                              child: Shimmer(child: Container(color: Theme.of(context).shadowColor)),
                            ),
                          ),
                        ),
              
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: Shimmer(
                                    child: Container(height: 15, width: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: Shimmer(
                                    child: Container(height: 10, width: 120, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: Shimmer(
                                    child: Container(height: 12, width: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: Shimmer(
                                    child: Container(height: 10, width: 170, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
      ),
    );
  }
}
