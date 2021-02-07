import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();

  String newEmail = '';
  String newPassword = '';
  String newPasswordConfirm = '';
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
                  Text("Sign Up to foodMapr"),
                  FormBuilderTextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Username *',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.min(context, 2),
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context),
                    ]),
                    name: "username",
                    onChanged: (value) => setState(() => newEmail = value),
                  ),
                  FormBuilderTextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.security_outlined),
                      labelText: 'Password *',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.minLength(context, 8),
                      FormBuilderValidators.required(context),
                    ]),
                    name: "password",
                    onChanged: (value) => setState(() => newPassword = value),
                    obscureText: true,
                  ),
                  FormBuilderTextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.security_outlined),
                      labelText: 'Confirm Password *',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.equal(context, newPassword,
                          errorText: "Passwords do not match")
                    ]),
                    name: "Confirm Password",
                    onChanged: (value) =>
                        setState(() => newPasswordConfirm = value),
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
                        dynamic result =
                            await _auth.registerUser(newEmail, newPassword);

                        if (result == null) {
                          setState(
                              () => errorMessage = 'Check email is correct');
                        } else {
                          print(result);
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(errorMessage)
                ],
              ),
            )));
  }
}
