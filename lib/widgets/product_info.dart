// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../providers/products.dart';

class ProductInfo extends StatefulWidget {
  final BuildContext ctx;
  final Product product;
  final Color _color;
  ProductInfo(this.ctx, this.product, this._color);

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.product.product['title'];
    _descriptionController.text = widget.product.product['description'];
    _priceController.text = widget.product.product['price'].toString();
    super.initState();
  }

  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget._color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Image.network(
                widget.product.product['imageUrl'],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                label: const Text("Name"),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              maxLines: 4,
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                label: const Text("Description"),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                label: const Text("Price"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget._color,
                    ),
                    onPressed: _isWaiting
                        ? null
                        : () async {
                            setState(() {
                              _isWaiting = !_isWaiting;
                            });
                            try {
                              await widget.product.edit(
                                _nameController.text,
                                _descriptionController.text,
                                double.parse(_priceController.text),
                              );
                              setState(() {
                                _isWaiting = !_isWaiting;
                              });
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Updated Successfully!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(err.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              print(err);
                            }
                          },
                    child: _isWaiting
                        ? const CircularProgressIndicator()
                        : const Text("Update"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: _isWaiting
                      ? null
                      : () async {
                          try {
                            setState(() {
                              _isWaiting = !_isWaiting;
                            });
                            await widget.product.delete();
                            // ignore: use_build_context_synchronously
                            Navigator.of(widget.ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Deleted Successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
