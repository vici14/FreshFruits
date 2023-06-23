import 'package:flutter/material.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/utils/ToastUtil.dart';
import 'package:fresh_fruit/view_model/ProductDetailViewModel.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';

import 'package:provider/provider.dart';

class ProductSelectDialog extends StatefulWidget {
  final ProductModel productModel;

  const ProductSelectDialog({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductSelectDialog> createState() {
    return _ProductSelectDialogState();
  }
}

class _ProductSelectDialogState extends State<ProductSelectDialog> {
  late ProductDetailViewModel _productDetailViewModel;
  late UserViewModel _userViewModel;

  @override
  void initState() {
    _productDetailViewModel = ProductDetailViewModel(widget.productModel);
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductDetailViewModel>(
      create: (BuildContext context) => _productDetailViewModel,
      child: Consumer<ProductDetailViewModel>(
        builder: (BuildContext context, ProductDetailViewModel productDetailVM,
            Widget? child) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border:
                                    Border.all(width: 1, color: Colors.teal),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      productDetailVM.productModel.imageUrl ??
                                          '',
                                    ),
                                    fit: BoxFit.fill)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productDetailVM.productModel.name ?? ''),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money_outlined,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    productDetailVM.productModel.cost
                                        .toString(),
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Giới thiệu'),
                    ),
                    Container(
                      color: Colors.grey,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Scrollbar(
                        child: ListView(
                          children: [
                            Text(productDetailVM.productModel.description ?? '')
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  productDetailVM.decreaseQuantity();
                                },
                                icon: const Icon(Icons.remove)),
                            Text(productDetailVM.quantity.toString()),
                            IconButton(
                                onPressed: () {
                                  productDetailVM.increaseQuantity();
                                },
                                icon: const Icon(Icons.add))
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_userViewModel.isLoggedIn) {
                              productDetailVM.addToCart(
                                  productModel: productDetailVM.productModel,
                                  quantity: productDetailVM.quantity,
                                  uid: _userViewModel.currentUser?.uid ?? '');
                              ToastUtils.show(msg: 'Add to cart success');
                            } else {
                              ToastUtils.show(msg: 'please login');
                            }
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              width: 100,
                              child: Center(
                                  child: Text(
                                CurrencyFormatter().toDisplayValue(
                                    productDetailVM.totalCost,
                                    currency: 'VNĐ'),
                                style: const TextStyle(color: Colors.white),
                              ))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
