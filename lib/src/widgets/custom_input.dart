import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeHolder;
  final TextEditingController textController;
  final TextInputType keyBoardType;
  final bool isPassword;
  final Function onSubmitted;
  const CustomInput({Key key, @required this.icon, @required this.placeHolder, @required this.textController, this.keyBoardType = TextInputType.text, this.isPassword = false, this.onSubmitted }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0,5),
                  blurRadius: 5
              )
            ]
        ),
        child: TextField(
          controller: this.textController,
          autocorrect: false,
          keyboardType: this.keyBoardType,
          obscureText: this.isPassword,
          onSubmitted: this.onSubmitted != null ? this.onSubmitted : null,
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: this.placeHolder
          ),
        )
    );
  }
}
