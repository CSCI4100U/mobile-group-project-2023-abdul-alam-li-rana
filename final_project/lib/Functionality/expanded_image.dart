import 'package:flutter/material.dart';

class ExpandedImageView extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;
  final VoidCallback onUnexpand;

  ExpandedImageView({
    required this.imageUrl,
    required this.onDelete,
    required this.onUnexpand,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;


      return Stack(
        children: [
          GestureDetector(
            onTap: onUnexpand,
            child: Container(
              color: Colors.black,
              child: Center(
                child: Hero(
                  tag: 'image${imageUrl.hashCode}',
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,  // 5% from the top
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: onUnexpand,
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,  // 5% from the top
            right: 20,
            child: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: onDelete,
            ),
          ),
        ],
    );
  }
}
