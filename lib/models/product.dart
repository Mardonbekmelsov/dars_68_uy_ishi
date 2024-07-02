import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String title;
  num price;
  String imageUrl;
  String category;
  bool isLiked;
  Product({
    required this.category,
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.title,
    required this.isLiked,
  });

  factory Product.fromJson(QueryDocumentSnapshot query) {
    return Product(
        category: query['category'],
        id: query.id,
        imageUrl: query['imageUrl'],
        price: query['price'],
        title: query['title'],
        isLiked: query['isLiked']);
  }
}
