import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapps/Screens/SignUpScreen.dart';
import 'HomeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController password1 = TextEditingController();
  TextEditingController email = TextEditingController();

  Future getData() async {
    var url = "http://192.168.10.24/movieApps/tb_user/ambilData.php";
    final responseData = await http.post(url, body: {
      "email": email.text,
      "password1": password1.text,
    });

    // debugPrint(responseData.toString());

    var data = json.decode(responseData.body);
    if (data['message'] == "Success") {
      Fluttertoast.showToast(
        msg: "Login Berhasil",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomeScreen(
                  iduser: data['body']['id_user'], //body itu $row dalam php
                  email: data['body']['email'],
                  username: data['body']['username'])));
    } else {
      Fluttertoast.showToast(
          msg: "Username dan Password tidak sesuai",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      email = data['email'];
      password1 = data['password1'];
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('asset/img/sign.jpg'))),
              child: Positioned(
                  child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'SELAMAT DATANG SOBAT SANTUY😊',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.mail), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextFormField(
                            controller: email,
                            decoration: InputDecoration(hintText: 'Email'),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              } else if (value.length < 5) {
                                return 'Email tidak boleh kurang dari 5 digit';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Masukkan email dengan benar';
                              }

                              return null;
                            },
                            onSaved: (String email) {
                              email = email;
                            },
                          )))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.lock), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextFormField(
                            controller: password1,
                            decoration: InputDecoration(hintText: 'Password'),
                            obscureText: true,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              } else if (value.length < 5) {
                                return 'Passwordl tidak boleh kurang dari 5 digit';
                              }
                              return null;
                            },
                            onSaved: (String username) {
                              username = username;
                            },
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      getData();
                    },
                    color: Colors.blue[900],
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Center(
                child: RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: ' SIGN UP',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
