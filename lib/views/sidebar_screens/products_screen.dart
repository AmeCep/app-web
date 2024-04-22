import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static const String id = "\ProductsScreen";

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _editingController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool showSizeButton = false;
  late String productName;
  late double productPrice;
  late String productDescription;
  late int discount;
  late int quantity;
  List<String> __imagesUrls = [];
  final List<String> _categoriesList = [];
  String? _selectedCategory;
  List<String> sizeList = [];
  final List<Uint8List?> _images = [];

  _uploadProductsImagesToStorage() async {
    for (var image in _images) {
      Reference ref = _firebaseStorage
          .ref()
          .child('productImages')
          .child(const Uuid().v4());
      await ref.putData(image!).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            __imagesUrls.add(value);
          });
        });
      });
    }
  }

  _uploadProductsToFirebaseFirestore() async {
    await _uploadProductsImagesToStorage();
    if (__imagesUrls.isNotEmpty) {
      final productId = Uuid().v4();
      await _firebaseFirestore.collection('products').doc(productId).set({
        'productId': productId,
        'productName': productName,
        'productSize': sizeList,
        'productPrize': productPrice,
        'description': productDescription,
        'discount': discount,
        'category':_selectedCategory,
        'quantity': quantity,
        'productImages': __imagesUrls
      }).whenComplete(() => _formKey.currentState!.reset());
    }
  }

  _pickImage() async {
    FilePickerResult? results = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (results != null) {
      setState(() {
        for (var image in results!.files) {
          _images.add(image.bytes); //imagen
        }

        //print(fileName);
      });
    }
  }

  //Metodo para traer todas las categorias
  _getCategories() async {
    return _firebaseFirestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        setState(() {
          _categoriesList.add(element['categoryName']);
        });
      }
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Product Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productName = value;
                },
                decoration: InputDecoration(
                    labelText: 'Product Information',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a Field';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      onChanged: (value) {
                        productPrice = double.parse(value);
                      },
                      decoration: InputDecoration(
                          labelText: 'Enter Price',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Field';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: DropdownButtonFormField(
                      onChanged: (value) {
                        _selectedCategory = value;
                      },
                      items: _categoriesList.map((category) {
                        return DropdownMenuItem(
                            value: category, child: Text(category));
                      }).toList(),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLines: 4,
                maxLength: 800,
                onChanged: (value) {
                  productDescription = value;
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a Field';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  quantity = int.parse(value);
                },
                decoration: InputDecoration(
                    labelText: 'Quantity',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a Field';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  discount = int.parse(value);
                },
                decoration: InputDecoration(
                    labelText: 'Discount',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a Field';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _editingController,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              showSizeButton = false;
                            } else {
                              showSizeButton = true;
                            }
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Add Size',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: showSizeButton
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            child: const Text('Add'),
                            onPressed: () {
                              setState(() {
                                sizeList.add(_editingController.text);
                                _editingController.clear();
                              });
                            },
                          )
                        : null,
                  ))
                ],
              ),
              sizeList.isNotEmpty
                  ? SizedBox(
                      height: 50,
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  sizeList.removeAt(index);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      sizeList[index],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: sizeList.length,
                          scrollDirection: Axis.horizontal),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _images.length + 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            onPressed: () {
                              _pickImage();
                            },
                            icon: const Icon(Icons.add),
                          ),
                        )
                      : Image.memory(_images[index - 1]!);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _uploadProductsToFirebaseFirestore();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Add Product'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
