import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/buyers_screen.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/categories_screen.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/dashboard_screen.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/orders_screen.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/products_screen.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/upload_banner_screen.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/vendors_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget _selectedScreen = VendorsScreen();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Management'),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Vendors',
            route: VendorsScreen.id,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrdersScreen.id,
            icon: Icons.shopping_cart_outlined,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: CategoryScreen.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            route: UploadBannerScreen.id,
            icon: Icons.add,
          ),
          AdminMenuItem(
            title: 'Products',
            route: ProductsScreen.id,
            icon: Icons.shopping_basket,
          ),
        ],
        selectedRoute: VendorsScreen.id,
        onSelected: (item) {

          if(item.route == BuyersScreen.id){
            setState(() {
              _selectedScreen = BuyersScreen();
            });
          }
          else if(item.route == CategoryScreen.id){
            setState(() {
              _selectedScreen = CategoryScreen();
            });
          }
          else if(item.route == DashBoardScreen.id){
            setState(() {
              _selectedScreen = DashBoardScreen();
            });
          }
          else if(item.route == OrdersScreen.id){
            setState(() {
              _selectedScreen = OrdersScreen();
            });
          }
          else if(item.route == ProductsScreen.id){
            setState(() {
              _selectedScreen = ProductsScreen();
            });
          }
          else if(item.route == UploadBannerScreen.id){
            setState(() {
              _selectedScreen = UploadBannerScreen();
            });
          }
          else if(item.route == VendorsScreen.id){
            setState(() {
              _selectedScreen = VendorsScreen();
            });
          }

        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'header',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedScreen,
    );
  }
}
