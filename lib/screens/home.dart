import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/products.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: const Icon(
            Icons.logout,
          ),
        ),
        title: Image.asset(
          "images/shop_logo.png",
          height: 30,
          width: 40,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                final Products products = Products.getInstance();
                products.collection = data[index]['name'];
                Navigator.of(context).pushNamed('/products');
              },
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  //color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(data[index]['imageUrl']),
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 300,
                  child: Text(
                    data[index]['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
