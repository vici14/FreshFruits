import 'package:flutter/material.dart';
import 'package:fresh_fruit/features/store/base_product_category_screen.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/widgets/ProductCardItem.dart';

import 'package:provider/provider.dart';

class MeatTab extends StatefulWidget {
  @override
  _MeatTabState createState() => _MeatTabState();
}

class _MeatTabState extends BaseProductCategoryScreen<MeatTab> {
  @override
  void initState() {
    super.getProductByCategory('meat');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder:
          (BuildContext context, ProductViewModel productVM, Widget? child) {
        if (productVM.isLoadingMeat) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (productVM.meatProducts.isEmpty) {
          return const Center(
            child: Text("Danh sách trống"),
          );
        }
        return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1,
            ),
            itemCount: super.userVM.isLoggedIn
                ? productVM.meatProductsAfterLoggedIn.length
                : productVM.meatProducts.length,
            itemBuilder: (context, index) {
              ProductModel product;

              if (super.userVM.isLoggedIn) {
                product = super.productVM.meatProductsAfterLoggedIn[index];
              } else {
                product = super.productVM.meatProducts[index];
              }
              return ProductCardItem(
                productModel: product,
                isFromHomeScreen: false,
              );
            });
      },
    );
  }
}
