import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/mock_data.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/ProductCardItem.dart';
import 'package:fresh_fruit/widgets/product_card/ProductCardShimmer.dart';
import 'package:provider/provider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/product_model.dart';
import '../../widgets/loading_indicator/LoadingIndicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductViewModel productViewModel;
  late UserViewModel userViewModel;
  static const horizontalPadding = 14.0;
  ScrollController featuredProductScrollController = ScrollController();
  final ScrollController _customScrollController = ScrollController();
  int carouselIndex = 0;

  List<String> listBanners = [AppImageAsset.appBanner1];

  TextEditingController? searchController;
  FocusNode? searchNode;
  bool isAnimatedText = true;

  @override
  void initState() {
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    productViewModel.getProducts();
    searchController = TextEditingController();
    searchNode = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // productViewModel.getProducts();
    //
    // if (userViewModel.isLoggedIn) {
    //   // productViewModel.getProductsAfterUserLoggedIn(
    //   //     userViewModel.currentUser!.favoriteProducts!);
    // }
    super.didChangeDependencies();
  }

  final String appBarBackground = "https://images.unsplash"
      ".com/photo-1616789916437-bbf724d10dae?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3540&q=80";

  // final _productsStream = FirebaseFirestore.instance
  //     .collection('products')
  //     .withConverter<ProductModel>(
  //         fromFirestore: (snapshots, _) =>
  //             ProductModel.fromQuerySnapshot(snapshots.data()!),
  //         toFirestore: (carModel, _) => carModel.toJson());

  Future<void> _onRefreshCallback() {
    productViewModel.getProducts();

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder:
          (BuildContext context, ProductViewModel productVM, Widget? child) {
        return _buildContent(productVM);

        /*Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: productVM.isLoadingProduct
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.3,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          appBarBackground,
                          fit: BoxFit.cover,
                        ),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CartScreen(),
                              ));
                            },
                            icon: const Icon(Icons.shopping_cart))
                      ],
                      floating: true,
                      leading: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      ),
                      centerTitle: false,
                      title: const Text('Car Online'),
                    ),
                    SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 1,
                          ),
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            ProductModel product;
                            // if (userViewModel.isLoggedIn) {
                            //   product = productViewModel
                            //       .productsAfterLoggedIn![index];
                            // } else {
                            //   product = productVM.products![index];
                            // }
                            product = listCars[index];
                            return ProductCardItem(productModel: product);
                          }, childCount: listCars.length
                              // userViewModel.isLoggedIn
                              //     ? productViewModel.productsAfterLoggedIn?.length
                              //     : productViewModel.products?.length,
                              ),
                        )),
                  ],
                ),
        );*/
      },
    );
  }

  Widget _buildContent(ProductViewModel productViewModel) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomRefreshIndicator(
            leadingScrollIndicatorVisible: false,
            trailingScrollIndicatorVisible: false,
            offsetToArmed: 100.0,
            onRefresh: _onRefreshCallback,
            builder: (context, child, controller) {
              return Stack(
                children: [
                  child,
                  PositionedIndicatorContainer(
                    constraints: constraints,
                    controller: controller,
                    child: SimpleIndicatorContent(
                      controller: controller,
                    ),
                  ),
                ],
              );
            },
            child: GestureDetector(
              onTap: () => searchNode?.unfocus(),
              child: CustomScrollView(
                controller: _customScrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    centerTitle: false,
                    title: const Text('Hello'),
                    actions: const [],
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        controller: searchController,
                        focusNode: searchNode,
                        decoration: InputDecoration(
                          label: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.black),
                            textAlign: TextAlign.start,
                            textWidthBasis: TextWidthBasis.longestLine,
                            child: searchNode?.hasFocus == false
                                ? AnimatedTextKit(
                                    repeatForever: true,
                                    animatedTexts: [
                                      RotateAnimatedText('AWESOMEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE'),
                                      RotateAnimatedText('OPTIMISTIC'),
                                      RotateAnimatedText('DIFFERENT'),
                                    ],
                                    
                                  )
                                : const SizedBox(),
                          ),
                          prefixIcon: const Icon(Icons.store),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                        // height: 10,
                        ),
                  ),
                  SliverToBoxAdapter(child: _buildHeaderBanner(context)),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 5,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      child: _buildHeaderTitle(
                        title: locale.language.HOME_SCREEN_NEW_PRODUCTS,
                        onTapViewMore: () {},
                      ),
                    ),
                  ),
                  // s_buildFeaturedProducts(context, productViewModel),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 22,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      child: _buildHeaderTitle(
                        title: locale.language.HOME_SCREEN_BEST_SELLING,
                        onTapViewMore: () {},
                      ),
                    ),
                  ),
                  SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 285.0,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 0.6,
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          ProductModel product;
            
                          product = listCars[index];
                          return ProductCardItem(productModel: product);
                        }, childCount: listCars.length),
                      )),
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 16 / 9,
                onPageChanged: (index, reason) {
                  setState(() {
                    carouselIndex = index;
                  });
                },
              ),
              items: listBanners.map((banner) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          //decoration: const BoxDecoration(color: Colors.amber),
                          child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(banner))),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildCategoryBox(BuildContext context) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Container(
  //         padding:
  //         const EdgeInsets.symmetric(horizontal: horizontalPadding),
  //         child: _buildHeaderTitle(
  //           title: 'Shop By Category',
  //           onTapViewMore: () {},
  //         ),
  //       ),
  //       (state.categories.isEmpty && !state.isLoading)
  //           ? const Center(
  //         child: Text('Categories are Empty'),
  //       )
  //           : (state.isLoading)
  //           ? const CircularProgressIndicator(
  //         color: FundigoColor.blueMain,
  //       )
  //           : SizedBox(
  //         height: 95,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: state.categories.length,
  //           itemBuilder: (context, index) {
  //             var _category = state.categories[index];
  //             return GestureDetector(
  //               onTap: () {
  //                 AnalyticsPlugin.instance.trackEventName(
  //                     'home_category_${_category.name}');
  //                 Navigator.of(context).pushNamed(
  //                     AppRoute.categoryScreen,
  //                     arguments:
  //                     CategoryScreenParams(_category));
  //               },
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                    Padding(
  //                     padding: const EdgeInsets.only(top: 5.0),
  //                     child: Text(
  //                       _category.name,
  //                       textAlign: TextAlign.center,
  //                       style: const TextStyle(
  //                           color: FundigoColor.greyAC),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFeaturedProducts(
      BuildContext context, ProductViewModel productViewModel) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Consumer<ProductViewModel>(
          builder: (context, viewModel, child) {
            return (productViewModel.isLoadingProduct == true)
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding),
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: const ProductCardShimmer());
                    },
                  )
                : (viewModel.products?.isNotEmpty == true)
                    ? ListView(
                        controller: featuredProductScrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding),
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...List.generate(viewModel.products?.length ?? 0,
                                  (index) {
                            var _featuredProducts = viewModel.products![index];
                            return Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: ProductCardItem(
                                  productModel: _featuredProducts,
                                ));
                          }),
                          if (viewModel.isLoadingProductMore == true)
                            const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.greenMain,
                              ),
                            ),
                        ],
                      )
                    : const Center(
                        child: Text("No Featured Products"),
                      );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderTitle({
    required String title,
    required Function() onTapViewMore,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
              onPressed: onTapViewMore,
              child: Text(
                locale.language.HOME_SCREEN_SEE_ALL,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.greenMain, fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
  }
}
