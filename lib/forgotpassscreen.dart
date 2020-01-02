import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lab_2/loginscreen.dart';
import 'package:lab_2/resetpasswordscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:lab_2/mainscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

String urlPassword="http://myondb.com/myapp/php/forgot.php";


class ForgotPassScreen extends StatefulWidget {
  final String email;
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
  const ForgotPassScreen({Key key, this.email}) : super(key: key);
}

class _ForgotPasswordScreenState extends State<ForgotPassScreen> {
   @override
  void initState() {
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor:  Colors.red,
          title: Text('Forgot Password'),
        ), 
        body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: PasswordWidget(),
          ),
        ),
      ),
     ));
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class PasswordWidget extends StatefulWidget {
  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
   final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Forgot Password?",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold, 
                    fontSize: 20)),

         SizedBox(
            height: 20,
                ),

                  Text("Please enter your registered email",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold, 
                    fontSize: 15)),

        SizedBox(
          height: 10,
        ),

        TextField(
            controller: _emcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
            SizedBox(
                  height: 50,
                ),

                  MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 200,
                  height: 50,
                  child: Text('Submit'),
                  color: Color.fromRGBO(250, 50, 12, 1),
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onPressed,
                ),

      ],
    );
  }

 void _onPressed() {
    _email = _emcontroller.text;
    if (_isEmailValid(_email)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Verifying your email");
      pr.show();

      http.post(urlPassword, body: {
        "email": _email,
      }).then((res){
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           if (res.body == "Please check your mailbox") {
          pr.dismiss();
          Navigator.push(
            context, MaterialPageRoute(builder: (BuildContext context)=> ResetPasswordScreen(email: _email))); 
            }else{
         pr.dismiss();
        
        }

      }).catchError((err){
          pr.dismiss();
          print(err);
    });
  } else{
    Toast.show("Please enter a correct email", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}

   
  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  } 

}