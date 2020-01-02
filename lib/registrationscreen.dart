import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:lab_2/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

String pathAsset = 'assets/images/profile.png';
String urlUpload = "http://myondb.com/myapp/php/user_register.php";
File _image;
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();

String _name, _email, _password, _phone;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
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
            title: Text('Registration'),
          ),
          body: SingleChildScrollView(
         child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: RegisterWidget(),
              ),
            ),
          ),
     ) ));
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  GlobalKey<FormState> _globalKey = new GlobalKey();
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 190,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        Text('Click on image above to take profile picture'),
        new TextFormField(
            controller: _emcontroller,
            autovalidate: _autoValidate,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(labelText: 'Email', icon: Icon(Icons.email))),

        new TextFormField(
            controller: _namecontroller,
            autovalidate: _autoValidate,
            validator: _validateName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),

        new TextFormField(
          controller: _passcontroller,
          autovalidate: _autoValidate,
          validator: _validatePassword,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),

        new TextFormField(
            controller: _phcontroller,
            autovalidate: _autoValidate,
            validator: _validatePhone,
            keyboardType: TextInputType.phone,

            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 270,
          height: 50,
          child: Text('Register'),
          color: Color.fromRGBO(250, 50, 12, 1),
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register',
                style: TextStyle(
                  fontSize: 16,
                ))),
      ],
    );
  }

  void _choose() async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(40),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    _image =
                        await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 80,maxHeight: 450,maxWidth: double.infinity);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,imageQuality: 80,maxHeight: 450,maxWidth: double.infinity);
                    setState(() {});
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
   // _image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 80,maxHeight: 450,maxWidth: double.infinity);
    //setState(() {});
    //_image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  String _validateEmail(String value) {
    // The form is empty
    if (value.length == 0) {
      return "Please enter your email";
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  String _validateName(String value) {
    if (value.length == 0) {
      return "Please enter your name";
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    if (value.length == 0) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  String _validatePhone(String value) {
    String p = r'(^[0-9]*$)';
     RegExp regExp = new RegExp(p);
     if(value.length == 0){
       return "Please enter your phone number";
     } else if (value.length <9 || value.length > 11) {
       return "Phone number must 10-11 digits";
     }else if (!regExp.hasMatch(value)){
       return "Please enter correct phone number";
     }
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "registered") {
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _image = null;
        savepref(_email, _password);
        _namecontroller.text = '';
        _emcontroller.text = '';
        _phcontroller.text = '';
        _passcontroller.text = '';
        pr.dismiss();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
     // Toast.show("Check your registration information", context,
         // duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }
}
  


