import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidgetList extends StatelessWidget {
   CategoryWidgetList({super.key});

  final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance.collection('categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return GridView.builder(
          shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 6,
              crossAxisSpacing: 8
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.network(snapshot.data!.docs[index]['categoryImage'],
                  width: 100,
                    height: 100,
                  ),
                  Text(snapshot.data!.docs[index]['categoryName'])
                ],
              );
            },);
      },
    );
  }
}
