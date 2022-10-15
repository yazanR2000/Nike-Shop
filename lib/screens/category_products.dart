import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ltuc_shop/widgets/product_info.dart';
import 'package:ltuc_shop/widgets/search.dart';
import '../widgets/products.dart';
import '../providers/products.dart' as p;

class CategoryProducts extends StatefulWidget {
  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final p.Products _products = p.Products.getInstance();

  void _addNewProduct(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final String category = _products.collection!;
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(category).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          _products.addProducts(snapshot.data!.docs);
          return const Search();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_new_product',arguments: _addNewProduct);
        },
        backgroundColor: const Color(0xff483838),

        child: const Icon(Icons.add),
      ),
    );
  }
}
