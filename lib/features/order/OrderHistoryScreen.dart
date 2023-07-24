import 'package:flutter/material.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/OrderModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/utils/DateTimeUtils.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/common/CommonCircularLoading.dart';
import 'package:fresh_fruit/widgets/my_app_bar.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../route/AppRoute.dart';
import 'OrderHistoryDetail.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  UserViewModel get userViewModel =>
      Provider.of<UserViewModel>(context, listen: false);

  @override
  void initState() {
    userViewModel.getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.only( top: 10, bottom: 80),
      child: Consumer<UserViewModel>(
        builder: (BuildContext context, UserViewModel userVM, Widget? child) {
          if (!userVM.isLoggedIn) {
            return const Center(
              child: Text("Vui lòng đăng nhập"),
            );
          }
          if (userVM.isGettingOrder) {
            return const Center(
              child: CommonCircularLoading(),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
              itemCount: userVM.listOrders.length,
              itemBuilder: (context, index) {
                var order = userVM.listOrders[index];
                return _buildOrderHistoryItem(order);
              });
        },
      ),
    );
  }

  Widget _buildOrderHistoryItem(OrderModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoute.orderDetailScreen,
            arguments: OrderDetailScreenParams(order));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration:   const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 10,
                color: Color(0xFFD5D5D5),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            children: [_buildItemContent(context, order)],
          )),
    );
  }

  Widget _buildItemContent(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                child: const Icon(
                  Icons.receipt_long,
                  size: 20,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.greenMain.withAlpha(30),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.id ?? "",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 10,
                        color: AppColor.textGrey,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    CurrencyFormatter().toDisplayValue(
                        (double.tryParse((order.totalPrice).toString()) ?? 0)),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "${locale.language.ORDER_DELIVERY_ON}: ${DateTimeUtils.toDisplayString(
                      order.deliveryTime,
                    )}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: AppColor.textGrey,
                        fontWeight: FontWeight.w400),
                  ),

                  Text(
                    "${locale.language.ORDER_PAYMENT_METHOD}: ${DateTimeUtils.toDisplayString(
                      order.orderCheckoutTime,
                    )}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: AppColor.textGrey,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
