import 'package:flutter/material.dart';
import 'package:fresh_fruit/model/OrderModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/my_app_bar.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  UserViewModel get userViewModel =>
      Provider.of<UserViewModel>(context, listen: false);
  @override
  void initState() {
    userViewModel.refreshCurrentUser();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding:
      const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
      child: Consumer<UserViewModel>(
        builder: (BuildContext context, UserViewModel userVM, Widget? child) {
          if (!userVM.isLoggedIn) {
            return const Center(
              child: Text("Vui lòng đăng nhập"),
            );
          }
          return ListView.builder(
              itemCount: userVM.currentUser?.orderHistory?.length ?? 0,
              itemBuilder: (context, index) {
                var order = userVM.currentUser?.orderHistory![index];
                return _buildOrderHistoryItem(order!);
              });


        },
      ),
    );
  }

  Widget _buildOrderHistoryItem(OrderModel cartModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(color: Colors.green, width: 1)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tên người nhận:'),
              Text(cartModel.customerName ?? '')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Số điện thoai:'),
              Text(cartModel.customerPhone ?? '')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Địa chỉ:'),
              Text(cartModel.destination?.getDisplayAddress ?? '')
            ],
          ),
          const Divider(
            color: Colors.black,
            endIndent: 5,
            indent: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng đơn hàng'),
              Text(CurrencyFormatter()
                  .toDisplayValue(cartModel.totalPrice, currency: 'VNĐ'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ngày thanh toán:'),
              // Text(DateFormat("yMd").format(DateTime.fromMicrosecondsSinceEpoch(
              //     cartModel.orderCheckoutTime ?? 0))),
            ],
          ),
        ],
      ),
    );
  }
}
