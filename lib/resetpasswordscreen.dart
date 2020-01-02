import 'package:flutter/material.dart';
import 'forgotpassscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:lab_2/loginscreen.dart';
import 'dart:async';
import 'package:lab_2/forgotpassscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';

String urlPassword = "http://myondb.com/myapp/php/reset_pass.php";

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  ResetPasswordScreen({Key key, this.email}) : super(key: key);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
            backgroundColor: Colors.red,
            title: Text('Reset Password'),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: ResetWidget(email: widget.email),
              ),
            ),
          ),
        ));
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPassScreen(),
        ));

    return Future.value(false);
  }
}

class ResetWidget extends StatefulWidget {
  final String email;
  ResetWidget({Key key, this.email}) : super(key: key);

  @override
  _ResetWidgetState createState() => _ResetWidgetState(email);
}

class _ResetWidgetState extends State<ResetWidget> {
   GlobalKey<FormState> _globalKey = new GlobalKey();
  bool _autoValidate = false;
  String email;
  _ResetWidgetState(this.email);

  String temppass = "";
  final TextEditingController _tempasscontroller = TextEditingController();

  String newpass= "";
  final TextEditingController _passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
       Text(widget.email),
        SizedBox(
          height: 20,
        ),
        Text("Please enter the temporary password",
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _tempasscontroller,
          autovalidate: _autoValidate,
          validator: validatePassword,
          decoration: InputDecoration(
            labelText: 'Temporary Password',
            icon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 50,
        ),
        Text("Please enter your own password",
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _passcontroller,
          autovalidate: _autoValidate,
          validator: validatePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            icon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 40,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 200,
          height: 50,
          child: Text('Reset Password'),
          color: Color.fromRGBO(250, 50, 12, 1),
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onVerify,
        ),
      ],
    );
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length <6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }


  void _onVerify() {
    email = widget.email;
    temppass = _tempasscontroller.text;
    newpass = _passcontroller.text;
    if (newpass.length > 5) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Reset password");
      pr.show();

      http.post(urlPassword, body: {
        "email": email,
        "temppass": temppass,
        "newpass": newpass,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body == "Success") {
          pr.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Please check your email for the temporary password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
