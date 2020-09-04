import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final Function callBack;

  const CustomButton({Key key, @required this.name, @required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(this.name, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
        ),
      ),
      onPressed: this.callBack
    );
  }
}
