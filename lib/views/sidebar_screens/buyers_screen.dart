import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuyersScreen extends StatelessWidget {
  BuyersScreen({super.key});

  static const String id = '\BuyersScreen';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Widget vendorData(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: widget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Business Name')),
              DataColumn(label: Text('City')),
              DataColumn(label: Text('State')),
              DataColumn(label: Text('Approval')),
              DataColumn(label: Text('Actions')),
            ],
            rows: snapshot.data!.docs.map((doc) {
              return DataRow(cells: [
                DataCell(SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(doc['image']),
                )),
                DataCell(Text(doc['businessName'].toString().toUpperCase())),
                DataCell(Text(doc['cityValue'])),
                DataCell(Text(doc['stateValue'])),
                DataCell(doc['approved'] == false
                    ? ElevatedButton(
                        onPressed: () async {
                          await _firebaseFirestore
                              .collection('vendors')
                              .doc(doc['vendorId'])
                              .update({
                            'approved': true,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          //   minimumSize: Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('approved'),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await _firebaseFirestore
                              .collection('vendors')
                              .doc(doc['vendorId'])
                              .update({
                            'approved': false,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          //   minimumSize: Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Reject'),
                      )),
                DataCell(ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    //   minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('View More'),
                )),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}