import 'package:flutter/material.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/my_app_bar.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: const CommonAppBar(
        title: "Lịch sử đơn hàng",
      ),
      body: Container(
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(userVM.currentUser!.orderHistory!.length,
                      (index) {
                    var cart = userVM.currentUser!.orderHistory![index];
                    return _buildOrderHistoryItem(cart);
                  })
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderHistoryItem(CartModel cartModel) {
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
              Text(cartModel.customerAddress ?? '')
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
                  .toDisplayValue(cartModel.totalCost, currency: 'VNĐ'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ngày thanh toán:'),
              Text(DateFormat("yMd").format(DateTime.fromMicrosecondsSinceEpoch(
                  cartModel.orderCheckoutTime ?? 0))),
            ],
          ),
        ],
      ),
    );
  }
}
