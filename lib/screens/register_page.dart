import 'package:flutter/material.dart';
import 'package:gimme_job/utils/constants.dart';
import 'package:gimme_job/services/auth_service.dart';
import 'package:gimme_job/utils/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // states to hold value of text;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.purple[400],
              elevation: 0.0,
              title: Text('Sign Up'),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                SizedBox(height: 50.0),
                Image.asset(
                  'assets/gimme_job_logo.png',
                  height: 300.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Email',
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                top: 1.0,
                              ),
                              child: Icon(
                                Icons.email,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Password',
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                top: 1.0,
                              ),
                              child: Icon(
                                Icons.password_rounded,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6 or more chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 50.0),
                        SizedBox(
                          height: 50.0,
                          width: 180.0,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.app_registration_rounded),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pink[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.register(email, password);
                                if (!result) {
                                  setState(() {
                                    error =
                                        'Please enter a valid email and password';
                                    loading = false;
                                  });
                                }
                              }
                            },
                            label: Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
