import 'package:flutter/material.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/ProductCardItem.dart';
import 'package:fresh_fruit/widgets/my_app_bar.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';

import 'package:provider/provider.dart';

class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({super.key});

  @override
  State<FavoriteProductsScreen> createState() {
    return _FavoriteProductsScreenState();
  }
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  late UserViewModel _userViewModel;
  @override
  void initState() {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false)
      ..refreshCurrentUser();
    print('favorite screen init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: const CommonAppBar(
        title: "My Favorite",
      ),
      body: Consumer<UserViewModel>(
        builder: (BuildContext context, UserViewModel userVM, Widget? child) {
          return (userVM.isLoggedIn == false)
              ? const Center(
                  child: Text("Vui lòng "
                      "đăng nhập"),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: userVM.currentUser?.favoriteProducts?.length,
                      itemBuilder: (context, index) {
                        var product =
                            userVM.currentUser?.favoriteProducts![index];
                        return ProductCardItem(productModel: product!);
                      }),
                );
        },
      ),
    );
  }
}
