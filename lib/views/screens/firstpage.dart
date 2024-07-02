import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musobaqa/controllers/product_controller.dart';
import 'package:musobaqa/models/product.dart';
import 'package:musobaqa/views/screens/third_screen.dart';
import 'package:musobaqa/views/widgets/cart_widget.dart';
import 'package:musobaqa/views/widgets/categories.dart';
import 'package:musobaqa/views/widgets/custom_drawer.dart';
import 'package:musobaqa/views/widgets/firstcategorywidget.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final ProductController productController=ProductController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade200,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return const CadrWidget();
              });
        },
        child: const Icon(CupertinoIcons.cart),
      ),
      drawer: const CustomDrawer(),
      appBar: AppBar(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.notifications_active,
                size: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              const Icon(
                Icons.search,
                size: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://hackspirit.com/wp-content/uploads/2021/06/Copy-of-Rustic-Female-Teen-Magazine-Cover.jpg'),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Firstcategorywidget(
                      categoryName: "living",
                      imageUrl:
                          'https://media.architecturaldigest.com/photos/64f71af50a84399fbdce2f6a/16:9/w_2560%2Cc_limit/Living%2520with%2520Lolo%2520Photo%2520Credit_%2520Life%2520Created%25204.jpg',
                      name: 'Living Room'),
                  Firstcategorywidget(
                      categoryName: "wall",
                      imageUrl:
                          'https://foyr.com/learn/wp-content/uploads/2023/10/Best-wall-decor-idea-24-Tell-a-story-1024x768.jpg',
                      name: 'Wall Decoration'),
                  Firstcategorywidget(
                      categoryName: "table",
                      imageUrl:
                          'https://jumanji.livspace-cdn.com/magazine/wp-content/uploads/2018/03/27162018/Table-decoration_tray.jpg',
                      name: 'Table Decoration'),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Categories(category: 'Popular'),
                  Categories(category: 'New'),
                  Categories(category: 'Best Selling'),
                  Categories(category: 'Worst Selling'),
                  Categories(category: 'Popular'),
                  Categories(category: 'Popular'),
                  Categories(category: 'Popular'),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: StreamBuilder(
              stream: productController.getProducts(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                if(!snapshot.hasData){
                  return Center(
                    child: Text("Mahsulotlar yoq"),
                  );
                }
                final products=snapshot.data!.docs;
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 2),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = Product.fromJson(products[index]);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ThirdScreen(
                                      product: product,
                                    )));
                      },
                      child: Card(
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(product.imageUrl),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    index.toString(),
                                    style: const TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                              Text(
                                product.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${product.price}',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      productController.isLiked(product.id);
                                    },
                                    child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green.shade200),
                                        child: Icon(
                                          Icons.favorite_outlined,
                                          color: product.isLiked
                                              ? Colors.red
                                              : Colors.white,
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
