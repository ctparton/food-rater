import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/services/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_rater/views/common/loading_spinner.dart';

/// A class to handle the registration form to allow a new user to sign up
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  String newUsername = '';
  String newEmail = '';
  String newPassword = '';
  String newPasswordConfirm = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingSpinner(animationType: AnimType.loading)
        : Scaffold(
            body: Container(
                margin: EdgeInsets.all(30.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
                      FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Sign Up to FoodMapr",
                            style: TextStyle(fontSize: 100.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FormBuilderTextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.face),
                          labelText: 'Username *',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(context, 2),
                          FormBuilderValidators.required(context),
                        ]),
                        name: "Username",
                        onChanged: (value) =>
                            setState(() => newUsername = value),
                      ),
                      FormBuilderTextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email *',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(context, 2),
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.email(context),
                        ]),
                        name: "Email",
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
                        name: "Confrim Password",
                        onChanged: (value) =>
                            setState(() => newPassword = value),
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
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            _formKey.currentState.save();
                            if (_formKey.currentState.validate()) {
                              setState(() => isLoading = true);
                              dynamic result = await _auth.registerUser(
                                  newUsername, newEmail, newPassword);

                              if (result == null) {
                                setState(() {
                                  errorMessage =
                                      'Check email format is correct';
                                  isLoading = false;
                                });
                              } else {
                                Navigator.pop(context);
                                isLoading = false;
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(errorMessage,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red))
                    ],
                  ),
                )));
  }
}
