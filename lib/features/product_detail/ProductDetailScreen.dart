import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/product_detail/ProductDetailController.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/view_model/CartViewModel.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/ordered_product_model.dart';

class ProductDetailScreenArgs {
  final ProductModel productModel;

  ProductDetailScreenArgs(this.productModel);
}

class ProductDetailScreen extends StatefulWidget {
  final ProductDetailScreenArgs args;

  const ProductDetailScreen({super.key, required this.args});

  @override
  State<ProductDetailScreen> createState() {
    return _ProductDetailScreenState();
  }
}

class _ProductDetailScreenState extends BaseProviderScreenState<
    ProductDetailScreen, ProductDetailController> {
  final double horizontalPadding = 25;
  late CartViewModel cartVM;
  late UserViewModel _userViewModel;

  @override
  void initState() {
    cartVM = Provider.of<CartViewModel>(context, listen: false);
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    super.initState();
  }

  @override
  ProductDetailController initLocalController() {
    return ProductDetailController(widget.args.productModel);
  }

  @override
  String appBarTitle() {
    return "";
  }

  @override
  Widget buildContent(
      BuildContext context, ProductDetailController localState) {
    return Stack(
      children: [
        ListView(
          children: [
            _buildProductImagesBanner(localState),
            _buildNameAndPriceBox(localState),
            _buildDivider(),
            SizedBox(
              height: AppDimen.space18,
            ),
            _buildDescription(localState),
          ],
        ),
        Align(
          alignment: Alignment(0, 0.95),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: PrimaryButton(
              isLoading: cartVM.isAddingToCart,
              text: locale.language.PRODUCT_DETAIL_ADD_TO_CART,
              onTap: () async{
               await cartVM.addToCart(
                    productModel: localState.productModel,
                    quantity: localState.quantity,
                    uid: _userViewModel.currentUser?.uid ?? "");
               showSnackBar(true) ;
               Navigator.of(context).pop();
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDescription(ProductDetailController localState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.language.PRODUCT_DETAIL_DESCRIPTION,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
          ),
          Text(
            localState.productModel.description ?? "",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColor.textGrey),
          )
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      endIndent: horizontalPadding,
      indent: horizontalPadding,
      color: AppColor.textGrey.withOpacity(0.1),
    );
  }

  Widget _buildNameAndPriceBox(ProductDetailController localState) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localState.productModel.name ?? "",
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EasyRichText(
                "" +
                    '\n' +
                    CurrencyFormatter()
                        .toDisplayValue(localState.productModel.cost) +
                    "/${localState.productModel.unit}",
                patternList: [
                  EasyRichTextPattern(
                    targetString: CurrencyFormatter()
                        .toDisplayValue(localState.productModel.cost),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColor.secondary, fontSize: 20),
                  ),
                ],
              ),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (localState.quantity > 1) {
                          localState.quantity--;
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: AppColor.grey)),
                        child: const Center(
                          child: Icon(Icons.remove),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(localState.quantity.toString()),
                    ),
                    InkWell(
                      onTap: () {
                        localState.quantity++;
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: AppColor.grey)),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            color: AppColor.greenMain,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImagesBanner(ProductDetailController localState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.35,
              viewportFraction: 1,
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              onPageChanged: (index, reason) {
                print('onPageChanged:$index');
              },
            ),
            items: [...widget.args.productModel.imageUrls ?? []].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    imageUrl: i,
                    errorWidget: (context, url, error) =>
                        const Center(child: Text("ERROR")),
                    progressIndicatorBuilder: (context, url, progress) =>
                        Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.white10,
                      child: Container(),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment(0, 0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [...widget.args.productModel.imageUrls ?? []].map(
                (media) {
                  var index =
                      widget.args.productModel.imageUrls ?? [].indexOf(media);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: 0 == index
                            ? const Color.fromRGBO(0, 0, 0, 0.9)
                            : const Color.fromRGBO(0, 0, 0, 0.4)),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
