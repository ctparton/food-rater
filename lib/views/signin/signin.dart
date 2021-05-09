import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/signin/register.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_rater/views/common/loading_spinner.dart';

/// A class to handle the form to allow a new user to sign in.
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

/// Holds the information that the user is trying to authenticate with
class _SignInState extends State<SignIn> {
  /// Auth service to access signin methods
  final AuthService _auth = AuthService();

  /// Key to hold the current state of the form
  final _formKey = GlobalKey<FormBuilderState>();

  /// Controls if the loading animation should be displayed
  bool isLoading = false;

  String email = '';
  String password = '';
  String errorMessage = '';

  /// Client method to sign user in with [email] and [password]
  void signInUser(String email, String password) async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      dynamic result = await _auth.signIn(email, password);

      // if signin call has failed
      if (result == null) {
        setState(() {
          isLoading = false;
          errorMessage = "Your credentials are incorrect";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingSpinner(animationType: AnimType.loading)
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(30.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
                      FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Welcome to FoodMapr",
                            style: TextStyle(fontSize: 400.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FormBuilderTextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Email *',
                        ),
                        name: "email",
                        // Provides min length, required and email client-side validation
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
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        onChanged: (value) => setState(() => password = value),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              _formKey.currentState.save();
                              // if form data is valid, make sign in call
                              signInUser(email, password);
                            }),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Center(
                        child: InkWell(
                          child: Text(
                            "Don't have an account? Sign Up here",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.grey[500]),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        errorMessage,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
