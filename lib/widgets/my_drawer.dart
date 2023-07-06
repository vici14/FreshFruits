import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/features/favourite/favorite_products_screen.dart';
import 'package:fresh_fruit/utils/ToastUtil.dart';

import 'package:provider/provider.dart';
import '../features/account/UserScreen.dart';
import '../features/order/OrderHistoryScreen.dart';
import '../view_model/product_view_model.dart';
import '../view_model/UserViewModel.dart';

class MyDrawer extends StatelessWidget {
  late UserViewModel userViewModel;
  late ProductViewModel productViewModel;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(color: Colors.black),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserScreen()));
            },
            child: const Text(
              'Tài khoản',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderHistoryScreen()));
              },
              child: const Text('Lịch sử đơn hàng',
                  style: TextStyle(color: Colors.white))),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FavoriteProductsScreen()));
              },
              child: const Text('Sản phẩm yêu thích',
                  style: TextStyle(color: Colors.white))),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
              onTap: () async {
                if (userViewModel.currentUser != null) {
                  var _resp = await userViewModel.logOut();
                  if (_resp) {
                    ToastUtils.show(msg: "Đăng xuất thành công!");
                    productViewModel.getProducts();
                    productViewModel.getHouseWareProducts();
                    productViewModel.getMeatProducts();
                    productViewModel.getVegetableProducts();
                  }
                } else {
                  ToastUtils.show(msg: "Bạn chưa đăng nhập");
                }
              },
              child: const Text('Đăng xuất', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
