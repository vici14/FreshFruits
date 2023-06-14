import 'package:flutter/material.dart';
import 'package:fresh_fruit/features/store/house_ware_tab.dart';
import 'package:fresh_fruit/features/store/meat_tab.dart';
import 'package:fresh_fruit/features/store/vegetable_tab.dart';
import 'package:fresh_fruit/widgets/my_app_bar.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';

class StoreScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? globalScaffoldKey;

  const StoreScreen({Key? key, this.globalScaffoldKey}) : super(key: key);

  @override
  State<StoreScreen> createState() {
    return _StoreScreenState();
  }
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: const CommonAppBar(
        title: "Cửa hàng",
        trailing: SizedBox(),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                labelStyle: Theme.of(context).textTheme.bodyText2,
                indicatorColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).disabledColor,
                isScrollable: false,
                controller: _tabController,
                onTap: (index) {},
                tabs: const [
                  Tab(
                    child: Text('Rau củ quả'),
                  ),
                  Tab(
                    child: Text('Thịt cá'),
                  ),
                  Tab(
                    child: Text('Đồ gia dụng'),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TabBarView(controller: _tabController, children: [
                VegetableTab(),
                MeatTab(),
                HouseWareTab(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
