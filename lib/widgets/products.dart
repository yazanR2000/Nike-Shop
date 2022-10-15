import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ltuc_shop/widgets/product_info.dart';
import '../providers/products.dart';
class Products extends StatelessWidget {
  final List<Product> data;
  final String category;
  Products(this.data, this.category);

  final List<Color> _colors = const [
    Color(0xffD2D79F),
    Color(0xff90B77D),
    Color(0xff42855B),
    Color(0xff483838),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          final product = data[index].product;
          return Container(
            padding: const EdgeInsets.all(20),
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _colors[index % _colors.length].withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color:
                              _colors[index % _colors.length].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      Center(
                        child: Image.network(
                          product['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    product['title'],
                  ),
                  subtitle: Text("NIKE $category"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product['price']}",
                      style: const TextStyle(fontSize: 30),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _colors[index % _colors.length].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            backgroundColor: Colors.grey.shade50,
                          
                            builder: (ctx) {
                              return ProductInfo(ctx, data[index],_colors[index % _colors.length]);
                            },
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        color: _colors[index % _colors.length],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: data.length,
      ),
    );
  }
}
