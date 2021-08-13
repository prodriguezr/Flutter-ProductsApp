import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:products_app/models/models.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/ui/ui.dart';
import 'package:products_app/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(product: productsService.selectedProduct),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final Product product;

  const _ProductScreenBody({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(picture: this.product.picture),
                Positioned(
                  top: 60,
                  left: 30,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 40,
                  child: IconButton(
                    onPressed: () async {
                      final imagePicker = ImagePicker();

                      final XFile? pickedFile = await imagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 100);

                      if (pickedFile == null) {
                        print('You have not selected any image');
                        return;
                      }
                      print('We have a picture ${pickedFile.path}');
                      productsService
                          .updateSelectedProductImage(pickedFile.path);
                    },
                    icon: Icon(
                      Icons.photo_camera_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            _ProductForm(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productsService.isSaving
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Icon(Icons.save_outlined),
        onPressed: productsService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;

                final String? imageUrl = await productsService.uploadImage();

                if (imageUrl != null) productForm.product.picture = imageUrl;

                await productsService.saveOrCreateProduct(productForm.product);
              },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: _productFormDecoration(),
        child: Form(
          key: productsService.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: productsService.product.name,
                  onChanged: (value) => productsService.product.name = value,
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return 'Product name is required';
                    }
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Product name',
                    labelText: 'Name:',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: productsService.product.price.toString(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      productsService.product.price = 0;
                    } else {
                      productsService.product.price = int.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '\$ 0.-',
                    labelText: 'Price: ',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: productsService.product.stock.toString(),
                  onChanged: (value) {
                    if (int.tryParse(value) == null) {
                      productsService.product.stock = 0;
                    } else {
                      productsService.product.stock = int.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '0',
                    labelText: 'Stock: ',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                  value: productsService.product.available ?? false,
                  title: Text(
                    'Available',
                  ),
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: productsService.updateAvailability,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _productFormDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black12, offset: Offset(0, 7), blurRadius: 5),
      ],
    );
  }
}
