import 'package:chat_app/src/helpers/show_alert.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/widgets/custom_button.dart';
import 'package:chat_app/src/widgets/custom_input.dart';
import 'package:chat_app/src/widgets/labels.dart';
import 'package:chat_app/src/widgets/logo.dart';
import 'package:chat_app/src/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.96,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(title: "Messenger",),
                _Form(),
                SizedBox(height: 25,),
                Labels(firstLabel: '¿No tienes una cuenta?',secondLabel: 'Crea una',route: 'register',),
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
  final emailCtrl = new TextEditingController();
  final passCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
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
           callBack: !authService.authenticating ? (){ _login(); } : null,
         )

        ],
      ),
    );
  }


   _login() async {
    final authService = Provider.of<AuthService>(context,listen: false);
    final socketService = Provider.of<SocketService>(context,listen: false);

    FocusScope.of(context).unfocus();
    final loginOk = await  authService.login(email: emailCtrl.text, password: passCtrl.text);
    if(loginOk == true){
      socketService.connect();
      Navigator.pushReplacementNamed(context, 'contacts');
    }
    else
    {
      showAlert(context, 'Login incorrecto', 'Revise sus credenciales');
    }
  }

}


