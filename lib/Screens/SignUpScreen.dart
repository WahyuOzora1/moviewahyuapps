import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String nEmail = '';
  String nUsername = '';
  String nPassword1 = '';
  String nPassword2 = '';

  checkForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      tambahData();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void tambahData() async {
    var url = "http://192.168.10.24/movieApps/tambahData.php";
    final responseData = await http.post(url, body: {
      "email": nEmail,
      "username": nUsername,
      "password1": nPassword1,
      "password2": nPassword2,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            BackButtonWidget(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.person), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: 'Username'),
                            onSaved: (value) => nUsername = value,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Username tidak boleh kosong';
                              } else if (value.length < 5) {
                                return 'Username tidak boleh kurang dari 5 digit';
                              }
                              return null;
                            },
                          )))
                ],
              ),
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
                            decoration: InputDecoration(hintText: 'Email'),
                            onSaved: (value) => nEmail = value,
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
                            decoration: InputDecoration(hintText: 'Password'),
                            obscureText: true,
                            onSaved: (value) => nPassword1 = value,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              } else if (value.length < 5) {
                                return 'Password tidak boleh kurang dari 5 digit';
                              }
                              return null;
                            },
                          ))),
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
                            decoration: InputDecoration(
                                hintText: 'Konfirmasi Password'),
                            obscureText: true,
                            onSaved: (value) => nPassword2 = value,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              } else if (nPassword1 != nPassword2) {
                                return 'Password harus sama';
                              } else if (value.length < 5) {
                                return 'Password tidak boleh kurang dari 5 digit';
                              }
                              return null;
                            },
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      // _formKey.currentState.validate();

                      tambahData();
                      //untuk kembali ke laman awal
                      setState(() {
                        checkForm();
                      });
                    },
                    color: Colors.blue[900],
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('asset/img/sign.jpg'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              )),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Create New Account',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}
