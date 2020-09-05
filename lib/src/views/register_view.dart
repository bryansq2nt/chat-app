import 'package:chat_app/src/helpers/show_alert.dart';
import 'package:chat_app/src/providers/auth.dart';
import 'package:chat_app/src/widgets/custom_button.dart';
import 'package:chat_app/src/widgets/custom_input.dart';
import 'package:chat_app/src/widgets/labels.dart';
import 'package:chat_app/src/widgets/logo.dart';
import 'package:chat_app/src/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(title: "Registro",),
                _Form(),
                SizedBox(height: 25,),
                Labels(firstLabel: '¿Ya tienes una cuenta?',secondLabel: 'Ingresa ahora!',route: 'login',),
                SizedBox(height: 25,),
                TermsAndConditions()
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = new TextEditingController();
  final emailCtrl = new TextEditingController();
  final passCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context,listen: false);


    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[

          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            textController: nameCtrl,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyBoardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),



          CustomButton(
            name: 'Ingresar',
            callBack: !authService.authenticating ? (){_signUp();} : null,
          )

        ],
      ),
    );
  }

  _signUp() async {
    final authService = Provider.of<AuthService>(context,listen: false);

    FocusScope.of(context).unfocus();
    final registerOk = await  authService.register(name:nameCtrl.text,email: emailCtrl.text, password: passCtrl.text);
    if(registerOk == true){
      Navigator.pushReplacementNamed(context, 'users');
    }
    else
    {
      showAlert(context, 'Registro fallido', registerOk);
    }
  }
}



