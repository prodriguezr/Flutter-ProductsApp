import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:products_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 60),
        width: double.infinity,
        height: 400,
        decoration: _productCardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(
              picture: this.product.picture,
            ),
            _ProductDetails(
              id: this.product.id!,
              name: this.product.name,
            ),
            Positioned(
              child: _ProductPrice(
                price: this.product.price,
              ),
              top: 0,
              right: 0,
            ),
            Positioned(
              child: _ProductStock(
                stock: this.product.stock ?? 0,
                available: this.product.available ?? false,
              ),
              top: 0,
              left: 0,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _productCardBorders() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          )
        ]);
  }
}

class _ProductStock extends StatelessWidget {
  final bool available;
  final int stock;

  const _ProductStock({required this.stock, required this.available});

  @override
  Widget build(BuildContext context) {
    String legend = '';
    Color? color;

    if (this.available && this.stock > 0) {
      legend = 'Buy it!';
      color = Colors.yellow[900];
    } else if (!this.available || this.stock < 1) {
      legend = 'Not available';
      color = Colors.grey;
    }

    return Container(
      width: 130,
      height: 70,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Text(
          legend,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }
}

class _ProductPrice extends StatelessWidget {
  final int? price;

  const _ProductPrice({this.price = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: _priceDecoration(),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$$price',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: _priceDecoration(color: Theme.of(context).primaryColor),
      alignment: Alignment.center,
    );
  }

  BoxDecoration _priceDecoration({Color? color}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        bottomLeft: Radius.circular(25),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String id;
  final String name;

  const _ProductDetails({required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 60),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration:
            _detailsBoxDecoration(color: Theme.of(context).primaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${this.name}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${this.id}',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _detailsBoxDecoration({Color? color}) => BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ));
}

class _BackgroundImage extends StatelessWidget {
  final String? picture;

  const _BackgroundImage({this.picture});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: this.picture == null
            ? Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(this.picture!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
