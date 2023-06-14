import 'package:flutter/material.dart';
import 'package:fresh_fruit/features/store/base_product_category_screen.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/widgets/ProductCardItem.dart';

import 'package:provider/provider.dart';
import '../../mock_data.dart';

class VegetableTab extends StatefulWidget {
  @override
  _VegetableTabState createState() => _VegetableTabState();
}

class _VegetableTabState extends BaseProductCategoryScreen<VegetableTab> {
  @override
  void initState() {
    super.getProductByCategory('vegetable');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder:
          (BuildContext context, ProductViewModel productVM, Widget? child) {
        if (productVM.isLoadingVegetable) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (productVM.vegetableProducts.isEmpty) {
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
                ? productVM.vegetableProductsAfterLoggedIn.length
                : productVM.vegetableProducts.length,
            itemBuilder: (context, index) {
              ProductModel product;

              if (super.userVM.isLoggedIn) {
                product = super.productVM.vegetableProductsAfterLoggedIn[index];
              } else {
                product = super.productVM.vegetableProducts[index];
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
