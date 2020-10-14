import 'dart:convert';

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

  Widget buildEmailField() {
    return TextField(
      controller: emailController,
      focusNode: emailNode,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(passwordNode);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.4)),
          //  when the TextFormField in unfocused
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return TextField(
      controller: passwordController,
      focusNode: passwordNode,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.4)),
          //  when the TextFormField in unfocused
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return RaisedButton(
      child: Text('Sign In'),
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              performLogin();
            },
    );
  }

  performLogin() async {
    var params = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
    };
    print(params);
    await http
        .post("https://rcapp.utech.dev/api/auth/login",
            body: json.encode(params),
            headers: {"Content-Type": "application/json"})
        .timeout(Duration(seconds: 10))
        .then(
          (value) {
            print("status code Token: ${value.statusCode}");
            print(value.body);
            final data = json.encode(value.body);
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/1.jpg",
              fit: BoxFit.cover,
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 250,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildEmailField(),
                  buildPasswordField(),
                  buildLoginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
