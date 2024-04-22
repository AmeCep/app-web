import 'package:flutter/material.dart';

class VendorsScreen extends StatelessWidget {
  VendorsScreen({super.key});

  static const String id = "\VendorsScreen";


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Vendors',
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
