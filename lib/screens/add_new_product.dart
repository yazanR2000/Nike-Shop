import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as i;
class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final Products _products = Products.getInstance();
  final Map<String, dynamic> _info = {
    "imageUrl": null,
    "name": null,
    "description": null,
    "price": null,
  };
  Future _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    _info['imageUrl'] = image;
    setState(() {
      
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool _isWaiting = false;

  Future _addNewProduct(Function reload) async {
    if (_formKey.currentState!.validate() && _info['imageUrl'] != null) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isWaiting = !_isWaiting;
        });
        await _products.addProduct(_info);
        reload();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (err) {}
      setState(() {
        _isWaiting = !_isWaiting;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Function _reload = ModalRoute.of(context)!.settings.arguments as Function;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new product"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await _pickImage();
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: _info['imageUrl'] == null
                        ? const Icon(Icons.add)
                        : Image.file(
                            i.File(_info['imageUrl'].path),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Name"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _info['name'] = value;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Description"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _info['description'] = value;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Price"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _info['price'] = value;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isWaiting ? null : () async {
                        await _addNewProduct(_reload);
                      },
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
