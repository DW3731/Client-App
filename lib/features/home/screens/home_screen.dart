import 'package:flutter/rendering.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/features/home/controllers/advertisement_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/cashback_dialog_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cashback_logo_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/highlight_widget_view.dart';
import 'package:stackfood_multivendor/features/home/widgets/refer_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/web_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurant_filter_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurants_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/bad_weather_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/best_review_item_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cuisine_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/enjoy_off_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/location_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/new_on_stackfood_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/order_again_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_foods_nearby_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/refer_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/screens/theme1_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/today_trends_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/common/widgets/customizable_space_bar_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/story_view_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  static Future<void> loadData(bool reload) async {
    Get.find<HomeController>().getBannerList(reload);
    Get.find<CategoryController>().getCategoryList(reload);
    Get.find<CuisineController>().getCuisineList();
    Get.find<AdvertisementController>().getAdvertisementList();
    if(Get.find<SplashController>().configModel!.popularRestaurant == 1) {
      Get.find<RestaurantController>().getPopularRestaurantList(reload, 'all', false);
    }
    Get.find<CampaignController>().getItemCampaignList(reload);
    if(Get.find<SplashController>().configModel!.popularFood == 1) {
      Get.find<ProductController>().getPopularProductList(reload, 'all', false);
    }
    if(Get.find<SplashController>().configModel!.newRestaurant == 1) {
      Get.find<RestaurantController>().getLatestRestaurantList(reload, 'all', false);
    }
    if(Get.find<SplashController>().configModel!.mostReviewedFoods == 1) {
      Get.find<ReviewController>().getReviewedProductList(reload, 'all', false);
    }
    Get.find<RestaurantController>().getRestaurantList(1, reload);
    if(Get.find<AuthController>().isLoggedIn()) {
      await Get.find<ProfileController>().getUserInfo();
      Get.find<RestaurantController>().getRecentlyViewedRestaurantList(reload, 'all', false);
      Get.find<RestaurantController>().getOrderAgainRestaurantList(reload);
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<AddressController>().getAddressList();
      Get.find<HomeController>().getCashBackOfferList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();
  final ConfigModel? _configModel = Get.find<SplashController>().configModel;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();
    HomeScreen.loadData(false).then((value) {
      Get.find<SplashController>().getReferBottomSheetStatus();

      if((Get.find<ProfileController>().userInfoModel?.isValidForDiscount ?? false) && Get.find<SplashController>().showReferBottomSheet) {
        Future.delayed(const Duration(milliseconds: 500), () => _showReferBottomSheet());
      }

    });

    _scrollController.addListener(() {
      if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(Get.find<HomeController>().showFavButton){
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800), ()=> Get.find<HomeController>().changeFavVisibility());
        }
      }else {
        if(Get.find<HomeController>().showFavButton){
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800), ()=> Get.find<HomeController>().changeFavVisibility());
        }
      }
    });

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showReferBottomSheet() {
    ResponsiveHelper.isDesktop(context) ? Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(22),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: const ReferBottomSheetWidget(),
    ),
      useSafeArea: false,
    ).then((value) => Get.find<SplashController>().saveReferBottomSheetStatus(false)) : showModalBottomSheet(
      isScrollControlled: true, useRootNavigator: true, context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: const ReferBottomSheetWidget(),
        );
      },
    ).then((value) => Get.find<SplashController>().saveReferBottomSheetStatus(false));
  }


  @override
  Widget build(BuildContext context) {

    double scrollPoint = 0.0;

    return GetBuilder<HomeController>(builder: (homeController) {
      return GetBuilder<LocalizationController>(builder: (localizationController) {
        return Scaffold(
          appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
          endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            top: (Get.find<SplashController>().configModel!.theme == 2),
            child: RefreshIndicator(
              onRefresh: () async {
                await Get.find<HomeController>().getBannerList(true);
                await Get.find<CategoryController>().getCategoryList(true);
                await Get.find<CuisineController>().getCuisineList();
                Get.find<AdvertisementController>().getAdvertisementList();
                await Get.find<RestaurantController>().getPopularRestaurantList(true, 'all', false);
                await Get.find<CampaignController>().getItemCampaignList(true);
                await Get.find<ProductController>().getPopularProductList(true, 'all', false);
                await Get.find<RestaurantController>().getLatestRestaurantList(true, 'all', false);
                await Get.find<ReviewController>().getReviewedProductList(true, 'all', false);
                await Get.find<RestaurantController>().getRestaurantList(1, true);
                if(Get.find<AuthController>().isLoggedIn()) {
                  await Get.find<ProfileController>().getUserInfo();
                  await Get.find<NotificationController>().getNotificationList(true);
                  await Get.find<RestaurantController>().getRecentlyViewedRestaurantList(true, 'all', false);
                  await Get.find<RestaurantController>().getOrderAgainRestaurantList(true);

                }
              },
              child: ResponsiveHelper.isDesktop(context) ? WebHomeScreen(
                scrollController: _scrollController,
              ) : (Get.find<SplashController>().configModel!.theme == 2) ? Theme1HomeScreen(
                scrollController: _scrollController,
              ) : CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [

                  /// App Bar
                  SliverAppBar(
                    pinned: true, toolbarHeight: 10, expandedHeight: ResponsiveHelper.isTab(context) ? 80 : GetPlatform.isWeb ? 72 : 50,
                    floating: false, elevation: 0, /*automaticallyImplyLeading: false,*/
                    backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        centerTitle: true,
                        expandedTitleScale: 1,
                        title: CustomizableSpaceBarWidget(
                          builder: (context, scrollingRate) {
                            scrollPoint = scrollingRate;
                            return Center(child: Container(
                              width: Dimensions.webMaxWidth, color:Colors.black,
                              padding: const EdgeInsets.only(top: 30),
                              child: Opacity(
                                opacity: 1 - scrollPoint,
                                child: Row(children: [

                                  Expanded(
                                    child: Transform.translate(
                                      offset: Offset(0, -(scrollingRate * 20)),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                          child: GetBuilder<LocationController>(builder: (locationController) {
                                            return SingleChildScrollView( // Wrap the column here
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (scrollingRate < 0.2)
                                                    Row(
                                                      children: [
                                                        AuthHelper.isLoggedIn()
                                                            ? Icon(
                                                          AddressHelper.getAddressFromSharedPref()!.addressType == 'home'
                                                              ? Icons.home_filled
                                                              : AddressHelper.getAddressFromSharedPref()!.addressType == 'office'
                                                              ? Icons.work
                                                              : Icons.location_on,
                                                          size: 18,
                                                          color: Colors.white,
                                                        )
                                                            : Icon(
                                                          Icons.location_on,
                                                          size: 18,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                        Flexible(
                                                          child: Text(
                                                            AuthHelper.isLoggedIn()
                                                                ? AddressHelper.getAddressFromSharedPref()!.addressType!.tr
                                                                : 'your_location'.tr,
                                                            style: robotoMedium.copyWith(
                                                              color: Colors.white,
                                                              fontSize: Dimensions.fontSizeSmall,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  SizedBox(height: (scrollingRate < 0.15) ? 5 : 0),
                                                  if (scrollingRate < 0.8)
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            AddressHelper.getAddressFromSharedPref()!.address!,
                                                            style: robotoRegular.copyWith(
                                                              color: Colors.white,
                                                              fontSize: Dimensions.fontSizeSmall,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Theme.of(context).cardColor,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Transform.translate(
                                  offset: Offset(0, -(scrollingRate * 10)),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.toNamed(RouteHelper.getMapViewRoute()),
                                        child: Icon(
                                          Icons.near_me_outlined,
                                          size: 25,
                                            color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 10), // Add some spacing between the icons
                                      InkWell(
                                        child: GetBuilder<NotificationController>(
                                          builder: (notificationController) {
                                            return Container(

                                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                              child: Stack(
                                                children: [
                                                  Transform.translate(
                                                    offset: Offset(0, -(scrollingRate * 10)),
                                                    child: Icon(
                                                      Icons.notifications_on_outlined,
                                                      size: 25,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                  if (notificationController.hasNotification)
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).primaryColor,
                                                          shape: BoxShape.circle,
                                                          border: Border.all(width: 1, color: Theme.of(context).cardColor),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
                                      ),
                                    ],
                                  ),
                                ),


                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                ]),
                              ),
                            ));
                          },
                        )
                    ),
                    actions: const [SizedBox()],
                  ),

                  // Search Button
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverDelegate(height: 70,child: Center(child: Stack(
                      children: [
                        Container(
                          transform: Matrix4.translationValues(0, -1, 0),
                          height: 70, width: Dimensions.webMaxWidth,
                         // color: Theme.of(context).colorScheme.surface,
                          color: Colors.black,

                          child: Column(children: [
                            Expanded(child: Container(color: Colors.black)),
                            Expanded(child: Container(color: Colors.transparent)),
                          ]),
                        ),

                        Positioned(
                          left: 10, right: 10, top: 8, bottom: 5,
                          child: Container(

                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Colors.white, // Arrière-plan blanc
                              borderRadius: BorderRadius.circular(10), // Forme de pillule
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3), // Ombre plus prononcée
                                  spreadRadius: 2,
                                  blurRadius: 15,
                                  offset: const Offset(0, 5), // Décalage pour plus de profondeur
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.search, size: 24, color: Theme.of(context).primaryColor), // Icône de recherche
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12), // Ajuster l'espacement vertical
                                      hintText: 'are_you_hungry'.tr,
                                      hintStyle: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Colors.grey.withOpacity(0.6),
                                      ),
                                      border: InputBorder.none, // Supprimer la bordure par défaut
                                    ),
                                  ),
                                ),
                                // Icône de nettoyage visible uniquement si du texte est présent
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: IconButton(
                                    icon: Icon(Icons.clear, size: 24, color: Theme.of(context).primaryColor.withOpacity(0.6)),
                                    onPressed: () {
                                      // Ajoutez la logique pour effacer le texte ici
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )




                      ],
                    ))),
                  ),
                  SliverToBoxAdapter(
                    child: Center(

                      child: SizedBox(

                        width: Dimensions.webMaxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 300, // Increased height to provide more space
                              color: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 10.0), // Added padding for more space
                              child: StoryViewWidget(),
                            ),
                            const BannerViewWidget(),
                            const PromotionalBannerViewWidget(),
                            const HighlightWidgetView(),
                            const BadWeatherWidget(),

                            // const WhatOnYourMindViewWidget(),

                            const TodayTrendsViewWidget(),

                           // const LocationBannerViewWidget(),

                            // Move the CuisineViewWidget before HighlightWidgetView
                            const CuisineViewWidget(),


                            _isLogin ? const OrderAgainViewWidget() : const SizedBox(),

                            _configModel!.mostReviewedFoods == 1 ? const BestReviewItemViewWidget(isPopular: false) : const SizedBox(),

                            _configModel.popularRestaurant == 1 ? const PopularRestaurantsViewWidget() : const SizedBox(),

                            const ReferBannerViewWidget(),

                            _isLogin ? const PopularRestaurantsViewWidget(isRecentlyViewed: true) : const SizedBox(),

                            _configModel.popularFood == 1 ? const PopularFoodNearbyViewWidget() : const SizedBox(),

                            _configModel.newRestaurant == 1 ? const NewOnStackFoodViewWidget(isLatest: true) : const SizedBox(),

                           // const PromotionalBannerViewWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),


                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverDelegate(
                      height: 85,
                      child: const AllRestaurantFilterWidget(),
                    ),
                  ),


                  SliverToBoxAdapter(child: Center(child: FooterViewWidget(
                    child: Padding(
                      padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
                      child: AllRestaurantsWidget(scrollController: _scrollController),
                    ),
                  ))),

                ],
              ),
            ),
          ),

          floatingActionButton: AuthHelper.isLoggedIn() && homeController.cashBackOfferList != null && homeController.cashBackOfferList!.isNotEmpty ?
          homeController.showFavButton ? Padding(
            padding: EdgeInsets.only(bottom: ResponsiveHelper.isDesktop(context) ? 50 : 0, right: ResponsiveHelper.isDesktop(context) ? 20 : 0),
            child: InkWell(
              onTap: () => Get.dialog(const CashBackDialogWidget()),
              child: const CashBackLogoWidget(),
            ),
          ) : null : null,

        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 50});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}
