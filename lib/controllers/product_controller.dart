import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:musobaqa/models/product.dart';

class ProductController {
  final List<Product> _list = [];

  final productCollection = FirebaseFirestore.instance.collection("products");
  final productsImageStorage=FirebaseStorage.instance;

  Stream<QuerySnapshot> getProducts() async* {
    yield* productCollection.snapshots();
  }

  void addProduct(String title, double price, File imageFile)async{
    final imageReference = productsImageStorage
        .ref()
        .child("cars")
        .child("images")
        .child("$title.jpg");
    final uploadTask = imageReference.putFile(
      imageFile,
    );

    uploadTask.snapshotEvents.listen((status) {
      //? faylni yuklash holati
      print(status
          .state); // running - yuklanmoqda; success - yuklandi; error - xatolik

      //? faylni yuklash foizi
      double percentage =
          (status.bytesTransferred / imageFile.lengthSync()) * 100;

      print("$percentage%");
    });

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await productCollection.add({
        'title': title,
        'price': price,
        "imageUrl": imageUrl,
        'category': "Lamp",
        'isLiked': false,

      });
    });
  }

  List<Product> get list => [..._list];

  isLiked(String id) {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].id == id) {
        _list[i].isLiked = !_list[i].isLiked;
      }
    }
  }

  void deleteProduct(String id) {
   productCollection.doc(id).delete();
  }

  int productCategoryCount(String category) {
    int count = 0;
    for (var element in _list) {
      if (element.category == category) {
        count++;
      }
    }
    return count;
  }

  void editProduct(
      String id, String newTitle, double newPrice, File imageFile) async {
        final imageReference = productsImageStorage
        .ref()
        .child("$newTitle.jpg");
    final uploadTask = imageReference.putFile(
      imageFile,
    );

    uploadTask.snapshotEvents.listen((status) {
      //? faylni yuklash holati
      print(status
          .state); // running - yuklanmoqda; success - yuklandi; error - xatolik

      //? faylni yuklash foizi
      double percentage =
          (status.bytesTransferred / imageFile.lengthSync()) * 100;

      print("$percentage%");
    });

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await productCollection.doc(id).update({
        'title': newTitle,
        'price': newPrice,
        "imageUrl": imageUrl,
        'category': "Lamp",
        'isLiked': false,

      });
    });
  }

 
}
