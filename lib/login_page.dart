import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:api_example/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  bool _validate = false;
  bool _isLoading = false;
  bool _showPassword = false;

  Widget buildEmailField() {
    return TextField(
      controller: emailController,
      focusNode: emailNode,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(passwordNode);
      },
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
        ),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.4)),
        //   //  when the TextFormField in unfocused
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.amberAccent.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return TextField(
      controller: passwordController,
      focusNode: passwordNode,
      obscureText: !_showPassword,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      keyboardType: TextInputType.visiblePassword,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          color: this._showPassword ? Colors.blue : Colors.grey,
          onPressed: () {
            setState(() => _showPassword = !_showPassword);
          },
        ),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.4)),
        //   //  when the TextFormField in unfocused
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.amberAccent.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return ButtonTheme(
      height: 50,
      minWidth: double.infinity,
    
      child: RaisedButton(
        child: Text('SIGN IN',style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),),
        onPressed: _isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    print('connected');
                    if (emailController.text.toString() == 'test@test.test' &&
                        passwordController.text.toString() == '123456') {
                      performLogin();
                      setState(() {
                        _isLoading = true;
                      });
                    } else {
                      showErrToast();
                      //throw Exception('');
                    }
                  }
                } on SocketException catch (_) {
                  print('not connected');
                  Fluttertoast.showToast(msg: "Check Your Connection");
                }
              },
      ),
    );
  }

  showErrToast() {
    Fluttertoast.showToast(
        msg: "Email or Password was incorrect",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  performLogin() async {
    var params = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
    };
    print(params);
    try {
      await http
          .post("https://rcapp.utech.dev/api/auth/login",
              body: json.encode(params),
              headers: {"Content-Type": "application/json"})
          .timeout(Duration(seconds: 10))
          .then(
            (value) {
              print("status code Token: ${value.statusCode}");
              print(value.body);
              // final data = json.encode(value.body);
              if (value.statusCode == 200) {
                setState(() {
                  _isLoading = false;
                });
                var data = json.decode(value.body);
                String token = data["result"]["token"].toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipePage(
                      token: token,
                    ),
                  ),
                );
              } else {
                setState(() {
                  _isLoading = false;
                });
                print(value.body);
              }
            },
          );
    } catch (e) {
      throw e;
    }
  }
  // performLogin() async {
  //   var params = {
  //     'email': emailController.text.toString(),
  //     'password': passwordController.text.toString(),
  //   };
  //   var loginUrl = 'https://rcapp.utech.dev/api/auth/login';

  //   await http
  //       .post(
  //         loginUrl,
  //         body: params,
  //       )
  //       .timeout(Duration(seconds: 10))
  //       .then(
  //     (value) {
  //       print("status code Token: ${value.statusCode}");
  //       print(value.body);
  //       final data = json.decode(value.body);
  //       if (value.statusCode == 200) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         var data = json.decode(value.body);
  //         print('$data["response"]');
  //       } else {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/2.jpg",
                height: height,
                width: width,
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                // height: 250,
                // margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildEmailField(),
                    SizedBox(height: 20),
                    buildPasswordField(),
                     SizedBox(height: 20),
                    buildLoginButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
