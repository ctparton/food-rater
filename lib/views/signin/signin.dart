import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/signin/register.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();

  String email = '';
  String password = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.all(30.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  // SvgPicture.asset('assets/008-catering.svg'),
                  Text("Sign In"),
                  FormBuilderTextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'foodlover20',
                      labelText: 'Username *',
                    ),
                    name: "email",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.min(context, 2),
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context),
                    ]),
                    onChanged: (value) => setState(() => email = value),
                  ),
                  FormBuilderTextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.security_outlined),
                      labelText: 'Password *',
                    ),
                    name: "password",
                    onChanged: (value) => setState(() => password = value),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Text('sign in'),
                    onPressed: () async {
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.signIn(email, password);

                        if (result == null) {
                          setState(
                              () => errorMessage = 'Check email is correct');
                        } else {
                          print(result);
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  new Center(
                      child: new InkWell(
                    child: new Text("Don't have an account? Sign Up"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                  )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(errorMessage)
                ],
              ),
            )));
  }
}
