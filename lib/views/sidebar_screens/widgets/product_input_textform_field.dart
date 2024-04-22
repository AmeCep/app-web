import 'package:flutter/material.dart';

class ProductInputTextFormField extends StatelessWidget {
   ProductInputTextFormField({super.key, required this.text,});

  final String text;

  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: text,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0)
          )
      ),
      validator: (value) {
        if(value!.isEmpty){
          return 'Enter a Field';
        }
        return null;
      },
    );
  }
}