import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musobaqa/controllers/product_controller.dart';
import 'package:musobaqa/models/product.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditProduct extends StatefulWidget {
  Product product;
  EditProduct({super.key, required this.product});


  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  File? imageFile;
  final ProductController productController=ProductController();


  String title = '';

  String price = '';

  String imageUrl = '';

  final _formKey = GlobalKey<FormState>();

  void _add() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }


  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, requestFullMetadata: false, imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, requestFullMetadata: false, imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    title = widget.product.title;
    price = widget.product.price.toString();
    imageUrl = widget.product.imageUrl;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Product"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        openGallery();
                      },
                      icon: Icon(Icons.photo),
                      label: Text("Gallery"),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        openCamera();
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Camera"),
                    ),
                  ],
                ),
            TextFormField(
              initialValue: title,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Iltimos title kiriting";
                }
                return null;
              },
              onSaved: (newValue) {
                if (newValue != null) {
                  title = newValue;
                }
              },
            ),
            TextFormField(
              initialValue: price,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Price',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Iltimos narx kiriting";
                }
                try {
                  double.parse(value);
                } catch (e) {
                  return "Iltimos raqam kiriting";
                }
                return null;
              },
              onSaved: (newValue) {
                if (newValue != null) {
                  price = newValue;
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              _add();
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                productController.editProduct(
                    widget.product.id, title, double.parse(price), imageFile!);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
            child: const Text("O'zgartirish"))
      ],
    );
  }
}
