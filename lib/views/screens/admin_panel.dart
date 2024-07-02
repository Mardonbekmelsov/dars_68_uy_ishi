import 'package:flutter/material.dart';
import 'package:musobaqa/controllers/product_controller.dart';
import 'package:musobaqa/models/product.dart';
import 'package:musobaqa/views/widgets/add_product.dart';
import 'package:musobaqa/views/widgets/admin_item.dart';
import 'package:musobaqa/views/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class AdminPanel extends StatelessWidget {
  AdminPanel({super.key});

  final ProductController productController = ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Panel",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: StreamBuilder(
          stream: productController.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final products = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = Product.fromJson(products[index]);
                return AdminItem(product: product);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(),
              ));
        },
      ),
    );
  }
}
