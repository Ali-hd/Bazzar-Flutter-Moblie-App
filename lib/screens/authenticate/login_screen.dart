import 'package:bazzar/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazzar/utilities/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:bazzar/models/models.dart';
import 'package:bazzar/services/api.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  const LoginScreen({Key key, this.toggleView}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final storage = FlutterSecureStorage();
  _submitForm(Map values, BuildContext context, UserProvider providerUser) async {
      final data = Login(
        username: values['username'].trim(),
        password: values['password'].trim(),
        rememberMe: values['remember_me'],
      );
      String res = await providerUser.handleLogin(data);
      if(res == 'Signed in'){
        Phoenix.rebirth(context);
        // Navigator.pop(context);
      }
    }
  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(40, 120, 40, 0),
                  child: FormBuilder(
                    key: _fbKey,
                    initialValue: {
                      'username': '',
                      'password': '',
                      'remember_me': false
                    },
                    // autovalidate: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'OpenSans',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildFormField('Username'),
                        SizedBox(
                          height: 30,
                        ),
                        _buildFormField('Password'),
                        // _buildForgotPasswordBtn(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildRememberMeCheckbox(),
                        _buildLoginBtn(context, providerUser),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type == 'Username' ? 'Username or Email' : 'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            attribute: type == 'Username' ? 'username' : 'password',
            obscureText: type == 'Username' ? false : true,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              fillColor: Colors.grey[300],
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey[500],
                width: 1,
              )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey[600],
                width: 2,
              )),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1)),
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              prefixIcon: Icon(
                type == 'Username' ? Icons.person : Icons.lock,
                color: Colors.black87,
              ),
              hintText: type == 'Username'
                  ? 'Enter your username/email'
                  : 'Enter your password',
              hintStyle: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
            ),
            validators: type == 'Username'
                ? [
                    FormBuilderValidators.required(
                        errorText: 'Please enter your username'),
                    _fbKey.currentState != null &&
                            _fbKey.currentState.value != null &&
                            _fbKey.currentState.value['username'].contains('@')
                        ? FormBuilderValidators.email(
                            errorText: 'Email not valid')
                        : FormBuilderValidators.required()
                  ]
                : [
                    FormBuilderValidators.required(
                        errorText: 'Please enter your password')
                  ],
          ),
        ),
      ],
    );
  }

  // Widget _buildForgotPasswordBtn() {
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     child: FlatButton(
  //       onPressed: () => print('Forgot Password Button Pressed'),
  //       padding: EdgeInsets.only(right: 0.0),
  //       child: Text(
  //         'Forgot Password?',
  //         style: kLabelStyle,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildRememberMeCheckbox() {
    return FormBuilderCheckbox(
      attribute: 'remember_me',
      label: Align(
        alignment: Alignment(-1.2, 0),
        child: Text(
          'Remember me',
          style: kLabelStyle,
        ),
      ),
      leadingInput: true,
      checkColor: Colors.white,
      activeColor: Colors.black87,
    );
  }

  Widget _buildLoginBtn(BuildContext context, UserProvider providerUser) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: Colors.black87,
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          onPressed: () async {
            if (_fbKey.currentState.saveAndValidate()) {
              _submitForm(_fbKey.currentState.value, context, providerUser);
            }
          }),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => widget.toggleView(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
