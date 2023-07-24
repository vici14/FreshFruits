import 'package:flutter/material.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/utils/DateTimeUtils.dart';

import 'package:intl/intl.dart';

import '../../model/OrderModel.dart';
import '../../theme/AppColor.dart';
import '../../utils/CurrencyFormatter.dart'; //for date format

class OrderDetailScreenParams {
  final OrderModel order;

  OrderDetailScreenParams(this.order);
}

class OrderDetailScreen extends StatefulWidget {
  final OrderDetailScreenParams? params;

  const OrderDetailScreen({Key? key, this.params}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderModel _order;

  @override
  void initState() {
    _order = widget.params!.order;
    super.initState();
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      locale.language.ORDER_DETAIL_HEADER,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.greyScaffoldBackground,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        title: _buildTitle(context),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            _buildTotalPaid(context),
            _buildListItems(context),
            _buildPaymentMethod(
              context,
              leftText: "Payment Method",
              rightText: _order.paymentMethod!.toContent(),
            ),
            _buildDeliveryAddress(context),
            _buildDeliveryOn(context),
            _buildCreateAt(context),
            _buildOrderNo(context),
          ],
        ),
      ),
    );
  }


  Widget _buildTotalPaid(BuildContext context) {
    return _borderBox(context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.language.ORDER_TOTAL_PAID,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              CurrencyFormatter().toDisplayValue(_order.totalPrice),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
            )
          ],
        ),
        borderOnlyBottom: false);
  }

  Widget _buildDeliveryAddress(BuildContext context) {
    var child = _buildRowContent(context,
        leftText: locale.language.CHECK_OUT_SCREEN_DELIVERY_ADDRESS,
        rightText:_order.destination?.getDisplayAddress ?? "",
        isRightTextBold: true);
    return _borderBox(context, child: child, borderOnlyBottom: true);
  }

  Widget _buildListItems(BuildContext context) {
    var widget = Column(
      children: List.generate(_order.orderedItems?.length ?? 0, (index) {
        var item = _order.orderedItems![index];
        return Container(
          // margin: const EdgeInsets.only(bottom: 10),
          margin: EdgeInsets.only(
              bottom: index == _order.orderedItems!.length - 1 ? 0 : 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${item.quantity}x ${item.name}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                CurrencyFormatter().toDisplayValue(item.cost ?? 0),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      }),
    );
    return _borderBox(context, child: widget, borderOnlyBottom: true);
  }

  Widget _buildDeliveryOn(BuildContext context) {
    var child = _buildRowContent(context,
        leftText: locale.language.ORDER_DELIVERY_ON,
        rightText: DateTimeUtils.toDisplayString(
          _order.deliveryTime,
        ),
        isRightTextBold: true);
    return _borderBox(context, child: child, borderOnlyBottom: true);
  }

  Widget _buildCreateAt(BuildContext context) {
    var child = _buildRowContent(context,
        leftText: locale.language.ORDER_CREATE_AT,
        rightText: DateTimeUtils.toDisplayString(
          _order.orderCheckoutTime,
        ),
        isRightTextBold: true);
    return _borderBox(context, child: child, borderOnlyBottom: true);
  }

  Widget _buildOrderNo(BuildContext context) {
    var child = _buildRowContent(context,
        leftText: "Order No.",
        rightText: "#${_order.id}",
        isRightTextBold: true);
    return _borderBox(context, child: child, borderOnlyBottom: true);
  }

  Widget _borderBox(BuildContext context,
      {required Widget child, required bool borderOnlyBottom}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: borderOnlyBottom
              ? const Border(bottom: BorderSide(color: AppColor.grey))
              : const Border.symmetric(
                  horizontal: BorderSide(color: AppColor.grey),
                ),
        ),
        padding: const EdgeInsets.all(20),
        child: child);
  }

  Widget _buildRowContent(
    BuildContext context, {
    required String leftText,
    required String rightText,
    bool isLeftTextBold = false,
    bool isRightTextBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: (isLeftTextBold) ? FontWeight.w700 : FontWeight.w500),
        ),
        Expanded(
          child: Text(
            rightText,
            textAlign: TextAlign.end,
            maxLines: null,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight:
                    (isRightTextBold) ? FontWeight.w700 : FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context, {
    required String leftText,
    required String rightText,
    bool isLeftTextBold = false,
    bool isRightTextBold = false,
  }) {
    var child = _buildRowContent(context,
        leftText: locale.language.ORDER_PAYMENT_METHOD,
        rightText: _order.paymentMethod!.toContent(),
        isRightTextBold: true);
    return _borderBox(context, child: child, borderOnlyBottom: true);

  }
}
