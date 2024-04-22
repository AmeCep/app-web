
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:muti_store_web_app_v2/views/sidebar_screens/widgets/category_widget_list.dart';



class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key});

  static const String id = '\CategoryScreen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Uint8List? _image;
  String? fileName;
  late String categoryName;

  _pickImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image
    );
    if (result != null) {
      setState(() {
         _image = result.files.first.bytes; //imagen
        fileName = result.files.first.name; //ruta o el path de la imagen
        //print(fileName);
      });
    }
  }

  //Metodo que cargue la imagen al storage
  _upLoadCategoryToStorage(dynamic image) async{
    var ref = _firebaseStorage.ref().child('categories').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    //print(imageURL);
    return imageURL;

  }

  //Cargar la ruta (imageURL) a la base de Datos
  _upLoadToFireStore() async{

    //llamen al upLoadCategoryToStorage
    if(_formKey.currentState!.validate()) {
      try {
        String imageURL = await _upLoadCategoryToStorage(_image);
        //codigo para subirlo a la base de datos
        await _firestore.collection('categories').doc(fileName).set({
          'categoryImage': imageURL,
          'categoryName': categoryName,
        }).whenComplete(() {
          setState(() {
            _image = null;
            _formKey.currentState!.reset();
          });
        });
      }
      catch (e) {
          print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(10)),
                        child:  Center(
                          child: _image != null
                              ? Image.memory(_image!, fit: BoxFit.cover,)
                              : Text('Upload Banner...'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pickImage();
                        },
                        child: Text('Select Image'),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        categoryName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Enter a category Name',
                          hintText: 'Enter a category Name'),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _upLoadToFireStore();
                    },
                    child: Text('Save')),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text('Categories',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            CategoryWidgetList()
          ],
        ),
      ),
    );
  }
}
