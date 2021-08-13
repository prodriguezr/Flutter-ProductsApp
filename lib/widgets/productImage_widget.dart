import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? picture;

  const ProductImage({this.picture});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: Container(
        height: 450,
        width: double.infinity,
        decoration: _productImageDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          child: getImage(picture),
        ),
      ),
    );
  }

  BoxDecoration _productImageDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
      color: Colors.red,
    );
  }

  Widget getImage(String? picture) {
    if (picture == null) {
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    }

    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(picture),
        fit: BoxFit.cover,
      );
    }

    if (File(picture).existsSync())
      return Image.file(
        File(picture),
        fit: BoxFit.cover,
      );

    return Image(
      image: AssetImage('assets/no-image.png'),
      fit: BoxFit.cover,
    );
  }
}
