import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' as i;

class Products {
  static final Products _pro = Products();
  Products() {}
  static Products getInstance() => _pro;
  final List<Product> _products = [];
  String? _collection;
  List<Product> get products => _products;
  String? get collection => _collection;
  void addProducts(List<QueryDocumentSnapshot<Map<String, dynamic>>> products) {
    _products.clear();
    products.forEach((element) {
      _products.add(
        Product(element),
      );
    });
  }

  set collection(String? value) {
    _collection = value;
  }

  Future addProduct(Map<String, dynamic> details) async {
    try {
      final db = FirebaseFirestore.instance;
      final ref = FirebaseStorage.instance
          .ref()
          .child(_collection!)
          .child("${_products.length + 1}");
      final UploadTask uploadTask =
          ref.putFile(i.File(details['imageUrl']!.path));
      String? dowurl;
      await uploadTask.whenComplete(() async {
        dowurl = await ref.getDownloadURL();
      });
      await db.collection("Shirts").add({
        "imageUrl": dowurl,
        "title": details['name'],
        "price": double.parse(details['price']),
        "description": details['description'],
      });
    } catch (err) {
      print("err");
    }
  }
}

class Product {
  final QueryDocumentSnapshot<Map<String, dynamic>> _product;
  Product(this._product);
  QueryDocumentSnapshot<Map<String, dynamic>> get product => _product;

  Future delete() async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(_product.reference);
    });
  }

  Future edit(String name, String description, double price) async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.update(_product.reference,
          {"title": name, "description": description, "price": price});
    });
  }
}
