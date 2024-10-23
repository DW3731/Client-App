import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stackfood_multivendor/common/widgets/custom_tool_tip.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final double? charge;
  final bool? isFree;
  final double total;
  final String? chargeForView;
  final JustTheController? deliveryFeeTooltipController;
  final double badWeatherCharge;
  final double extraChargeForToolTip;

  const DeliveryOptionButton({
    super.key,
    required this.value,
    required this.title,
    required this.charge,
    required this.isFree,
    required this.total,
    this.chargeForView,
    this.deliveryFeeTooltipController,
    required this.badWeatherCharge,
    required this.extraChargeForToolTip,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (checkoutController) {
        bool select = checkoutController.orderType == value;
        return InkWell(
          onTap: () {
            checkoutController.setOrderType(value);
            checkoutController.setInstruction(-1);

            if (checkoutController.orderType == 'take_away') {
              checkoutController.addTips(0);
              if (checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1) {
                double tips = 0;
                try {
                  tips = double.parse(checkoutController.tipController.text);
                } catch (_) {}
                checkoutController.checkBalanceStatus(total, discount: charge! + tips);
              }
            } else {
              checkoutController.updateTips(
                Get.find<AuthController>().getDmTipIndex().isNotEmpty ? int.parse(Get.find<AuthController>().getDmTipIndex()) : 0,
                notify: false,
              );

              if (checkoutController.isPartialPay) {
                checkoutController.changePartialPayment();
              } else {
                checkoutController.setPaymentMethod(-1);
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: select ? Colors.white : Colors.grey[50],
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(
                color: select ? Theme.of(context).primaryColor : Colors.transparent,
                width: 1.0,
              ),
              boxShadow: select
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [],
              gradient: select
                  ? LinearGradient(
                colors: [Theme.of(context).primaryColor.withOpacity(0.1), Theme.of(context).primaryColor.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
            child: Row(
              children: [
                // Custom toggle button
                GestureDetector(
                  onTap: () {
                    checkoutController.setOrderType(value);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: select ? Theme.of(context).primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      select ? 'Selected'.tr : 'Select',
                      style: TextStyle(color: select ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                    Row(
                      children: [
                        Text(
                          value == 'delivery' ? '${'charge'.tr}: +$chargeForView' : 'free'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        value == 'delivery' && checkoutController.extraCharge != null && (chargeForView! != '0') && extraChargeForToolTip > 0
                            ? CustomToolTip(
                          message: '${'this_charge_include_extra_vehicle_charge'.tr} ${PriceConverter.convertPrice(extraChargeForToolTip)} ${badWeatherCharge > 0 ? '${'and_bad_weather_charge'.tr} ${PriceConverter.convertPrice(badWeatherCharge)}' : ''}',
                          tooltipController: deliveryFeeTooltipController,
                          preferredDirection: AxisDirection.right,
                          child: const Icon(Icons.info, color: Colors.blue, size: 14),
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
              ],
            ),
          ),
        );
      },
    );
  }
}
