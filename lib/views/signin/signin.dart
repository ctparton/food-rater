import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/signin/register.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_rater/views/common/loading_spinner.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  String email = '';
  String password = '';
  String errorMessage = '';

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
                            onChanged: (value) =>
                                setState(() => password = value),
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
                                if (_formKey.currentState.validate()) {
                                  setState(() => isLoading = true);
                                  dynamic result =
                                      await _auth.signIn(email, password);

                                  if (result == null) {
                                    setState(() {
                                      isLoading = false;
                                      errorMessage =
                                          "Your credentials are incorrect";
                                    });
                                  } else {
                                    print(result);
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          new Center(
                              child: new InkWell(
                            child: new Text(
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
                          )),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(errorMessage,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                        ],
                      ),
                    ))));
  }
}
