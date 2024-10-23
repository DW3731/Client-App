import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunningOrderViewWidget extends StatelessWidget {
  final List<OrderModel> reversOrder;
  final Function() onMoreClick;

  const RunningOrderViewWidget({
    super.key,
    required this.reversOrder,
    required this.onMoreClick,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return Container(
          height: context.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
              topRight: Radius.circular(Dimensions.paddingSizeExtraLarge),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: reversOrder.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    bool isFirstOrder = index == 0;
                    String? orderStatus = reversOrder[index].orderStatus ?? '';
                    int status = _getOrderStatus(orderStatus);

                    return InkWell(
                      onTap: () async {
                        await Get.toNamed(
                          RouteHelper.getOrderDetailsRoute(reversOrder[index].id),
                          arguments: OrderDetailsScreen(
                            orderId: reversOrder[index].id,
                            orderModel: reversOrder[index],
                          ),
                        );
                        if (orderController.showBottomSheet) {
                          orderController.showRunningOrders();
                        }
                      },
                      child: _buildOrderCard(context, index, isFirstOrder, status),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _getOrderStatus(String? orderStatus) {
    if (orderStatus == AppConstants.pending) return 1;
    if (orderStatus == AppConstants.accepted || orderStatus == AppConstants.processing || orderStatus == AppConstants.confirmed) return 2;
    if (orderStatus == AppConstants.handover || orderStatus == AppConstants.pickedUp) return 3;
    return 0;
  }

  Widget _buildOrderCard(BuildContext context, int index, bool isFirstOrder, int status) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildOrderStatusImage(context, status),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: _buildOrderDetails(context, index, isFirstOrder),
            ),
            _buildMoreOptionsButton(context, isFirstOrder),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusImage(BuildContext context, int status) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          _getOrderStatusImage(status),
          height: 60,
          width: 60,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  String _getOrderStatusImage(int status) {
    if (status == 2) {
      return Images.processingGif;
    } else if (status == 3) {
      return Images.handoverGif;
    } else {
      return Images.pendingGif;
    }
  }

  Widget _buildOrderDetails(BuildContext context, int index, bool isFirstOrder) {
    return Column(
      mainAxisAlignment: isFirstOrder ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: isFirstOrder ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isFirstOrder ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Text(
              '${'your_order_is'.tr} ',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
            Text(
              reversOrder[index].orderStatus!.tr,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(
          '${'order'.tr} #${reversOrder[index].id}',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (isFirstOrder) _buildTrackingIndicators(context, index),
      ],
    );
  }

  Widget _buildTrackingIndicators(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      child: Row(
        children: List.generate(4, (i) => Expanded(child: _trackView(context, i < index + 1))),
      ),
    );
  }

  Widget _buildMoreOptionsButton(BuildContext context, bool isFirstOrder) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: isFirstOrder && !(reversOrder.length < 2)
          ? InkWell(
        onTap: onMoreClick,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+${reversOrder.length - 1}',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
            ),
            Text(
              'more'.tr,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      )
          : Icon(Icons.arrow_forward, size: 18, color: Theme.of(context).primaryColor),
    );
  }

  Widget _trackView(BuildContext context, bool status) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: status ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
    );
  }
}
