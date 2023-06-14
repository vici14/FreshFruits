import 'package:flutter/material.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/utils/currency_formatter.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/view_model/user_viewmodel.dart';
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
          onTap: () {
            // AnalyticsPlugin.instance
            //     .trackEventName('product', data: product.toJson());
            // Navigator.of(context).pushNamed(
            //   AppRoute.productDetailScreen,
            //   arguments: ProductDetailScreenParams(
            //       product: product,
            //       tapOnFavoriteIcon: widget.tapOnFavoriteIcon,
            //       isNavigateSecondaryLevel: isNavigateSecondaryLevel()),
            // );
          },
          child: Container(
            width: 200,
            decoration: AppTheme.roundedStandardGreyBorder,
            child: Flex(
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
          ),
        );
      },
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
                child: product.imageUrl != null
                    ? ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: product.imageUrl!,
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
        ],
      ),
    );
  }

  Widget _buildMiddleTitlePart() {
    return Flexible(
      flex: 4,
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: AppColor.blueMain),
                  ),
                ]),
              ],
            ),
          )),
    );
  }

  Widget _buildBottomMoneyPart() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.grey))),
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
                      .bodySmall
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            InkWell(
                onTap: () {
                  if (product.isLiked) {}
                },
                child: Icon(!product.isLiked
                    ? Icons.favorite_border_outlined
                    : Icons.favorite_outlined)),
          ],
        ),
      ),
    );
  }
}
