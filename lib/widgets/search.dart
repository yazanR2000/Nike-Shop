import 'package:flutter/material.dart';
import './products.dart';
import '../providers/products.dart' as p;
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final p.Products _products = p.Products.getInstance();
  String? _search = "";
  List<p.Product> _filterSearch(){
    if(_search!.isEmpty){
      return _products.products;
    }
    final List<p.Product> filter = [];
    _products.products.forEach((element) {
      bool startWith = 
      element.product['title'].toString().toLowerCase().startsWith(_search!.toLowerCase());
      if(startWith){
        filter.add(element);
      }
    });
    return filter;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffF9F6F7)),
            child:  TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search..",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value){
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
          Products(_filterSearch(), _products.collection!),
        ],
      ),
    );
  }
}
