import 'package:flutter/material.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/utils/currency_formatter.dart';
import 'package:fresh_fruit/utils/toast_util.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/view_model/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'product_select_dialog.dart';

class ProductCardItem extends StatefulWidget {
  final ProductModel productModel;
  final bool isFromHomeScreen;

  const ProductCardItem(
      {Key? key, required this.productModel, this.isFromHomeScreen = true})
      : super(key: key);

  @override
  State<ProductCardItem> createState() {
    return _ProductCardItemState();
  }
}

class _ProductCardItemState extends State<ProductCardItem> {
  ProductModel get product => widget.productModel;
  late ProductViewModel productViewModel;

  @override
  void initState() {
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (BuildContext context, UserViewModel userVM, Widget? child) {
        return GestureDetector(
          onTap: () async {
            await showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    child: ProductSelectDialog(
                      productModel: product,
                    ),
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
              barrierDismissible: true,
              barrierLabel: '',
              context: context,
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return ProductSelectDialog(
                  productModel: product,
                );
              },
            );
          },
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(width: 1, color: Colors.teal),
                    image: DecorationImage(
                        image: NetworkImage(
                          product.imageUrl ?? '',
                        ),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                CurrencyFormatter().toDisplayValue(product.cost,
                                    currency: "VNĐ"),
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Text(
                  product.name ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8),
                  child: GestureDetector(
                    onTap: () async {
                      if (userVM.isLoggedIn) {
                        if (!product.isLiked) {
                          userVM.likeProduct(product.changeLikeStatus());
                          widget.isFromHomeScreen
                              ? productViewModel.updateLikeStatus(product)
                              : productViewModel
                                  .updateLikeStatusInCategory(product);
                        } else {
                          await userVM.unlikeProduct(product);
                          widget.isFromHomeScreen
                              ? productViewModel.updateUnLikeStatus(product)
                              : productViewModel
                                  .updateUnLikeStatusInCategory(product);
                        }
                      } else {
                        ToastUtils.show(msg: 'PLEASE LOGIN');
                      }
                    },
                    child: Icon(
                      product.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: product.isLiked ? Colors.red : null,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
