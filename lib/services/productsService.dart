import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-97252-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  File? newPictureFile;

  ProductsService() {
    this.loadProducts();
  }

  Future loadProducts() async {
    this.isLoading = true;

    this.products.clear();

    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(response.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;

      this.products.add(tempProduct);
    });

    this.isLoading = false;

    notifyListeners();
  }

  Future saveOrCreateProduct(Product product) async {
    this.isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await this.createProduct(product);
    } else {
      await this.updateProduct(product);
    }

    this.isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');

    await http.put(url, body: product.toJson());

    final index =
        this.products.indexWhere((element) => element.id == product.id);

    this.products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.post(url, body: product.toJson());
    final decodedData = json.decode(response.body);

    product.id = decodedData['name'];

    this.products.add(product);

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dyvaaubkr/image/upload?upload_preset=preset_products');

    final request = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', this.newPictureFile!.path);

    request.files.add(file);

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 || response.statusCode != 201) {
      print('Algo falló');
      print(response.body);

      return null;
    }

    final decodedData = json.decode(response.body);

    this.newPictureFile = null;

    return decodedData['secure_url'];
  }
}
