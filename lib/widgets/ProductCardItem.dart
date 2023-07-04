import 'package:flutter/material.dart';
import 'package:fresh_fruit/features/product_detail/ProductDetailScreen.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/product_select_dialog.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

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
          onTap: () async{
            // Navigator.of(context).pushNamed(AppRoute.productDetailScreen,
            //     arguments: ProductDetailScreenArgs(widget.productModel));
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
          child: Container(
            width: 175,
            decoration: AppTheme.roundedStandardGreyBorder,
            child: Stack(children: [
              Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTopImagePart(),
                  _buildMiddleTitlePart(),
                  _buildBottomMoneyPart(),
                ],
              ),
              Positioned(right: 13,bottom: 15,child: _buildAddButton() )
            ]),
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.surface),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 17,
      ),
    );
  }

  Widget _buildTopImagePart() {
    return Flexible(
      flex: 6,
      fit: FlexFit.tight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: SizedBox.square(
                child: product.avatar != null
                    ? ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: product.avatar??"",
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported),
                          progressIndicatorBuilder: (context, url, progress) =>
                              Shimmer.fromColors(
                            baseColor: Colors.grey[200]!,
                            highlightColor: Colors.white10,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: AppDimen.iconSizeCenterLarge,
                            color: AppColor.grey,
                          ),
                          Text(
                            'Image Missing',
                            style: TextStyle(
                                fontSize: AppDimen.fontSize10,
                                color: AppColor.grey),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 16,
            child: InkWell(
                onTap: () {
                  if (product.isLiked) {}
                },
                child: !product.isLiked
                    ? const Icon(
                        Icons.favorite_border_outlined,
                        color: AppColor.grey,
                      )
                    : Icon(
                        Icons.favorite_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddleTitlePart() {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    product.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.1, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${product.unit ?? ""}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.1,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: AppColor.textGrey),
                    ),
                  ),
                ]),
              ],
            ),
          )),
    );
  }

  Widget _buildBottomMoneyPart() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  CurrencyFormatter().toDisplayValue(product.cost),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
