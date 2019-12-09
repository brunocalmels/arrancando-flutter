import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double height;

  LoadingWidget({
    this.height = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == 0 ? MediaQuery.of(context).size.height * 0.9 : height,
      child: Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
