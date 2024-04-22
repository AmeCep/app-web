import 'package:flutter/material.dart';


class OrdersScreen extends StatelessWidget {
 OrdersScreen({super.key});

 static const String id = "\OrdersScreen";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Orders',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
