import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaddingWidget extends StatelessWidget {
  final String name;
  final Color colors;
  final Function navigate;

  const PaddingWidget(this.name, this.colors, this.navigate);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colors,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: navigate,
          //Go to login screen.
          minWidth: 200.0,

          height: 42.0,

          child: Text(
            name,
          ),
        ),
      ),
    );
  }
}
