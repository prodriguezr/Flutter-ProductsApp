import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    print(value);

    product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.name);
    print(product.id);
    print(product.price);
    print(product.stock);
    print(product.available);

    return formKey.currentState?.validate() ?? false;
  }
}
