import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazzar/utilities/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:bazzar/models/models.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  RegisterScreen({this.toggleView});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final storage = FlutterSecureStorage();
  _submitForm(Map values, UserProvider providerUser) async {
    final data = Register(
      username: values['username'].trim(),
      email: values['email'],
      password: values['password'].trim(),
    );
    String res = await providerUser.handleRegister(data);
    if (res == 'success'){
      // widget.toggleView();
      Phoenix.rebirth(context);
    } 
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context, listen: true);
    if (!providerUser.authLoading) {
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
                        'email': '',
                        'password': ''
                      },
                      // autovalidate: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildFormField('username'),
                          SizedBox(
                            height: 20,
                          ),
                          _buildFormField('email'),
                          SizedBox(
                            height: 20,
                          ),
                          _buildFormField('password'),
                          // _buildForgotPasswordBtn(),
                          SizedBox(
                            height: 10,
                          ),
                          _buildSignupBtn(providerUser),
                          _buildLoginBtn(),
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
    } else {
      return Loading(backgroundColor: Colors.transparent);
    }
  }

  Widget _buildFormField(String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type[0].toUpperCase() + type.substring(1),
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          child: FormBuilderTextField(
            attribute: type,
            obscureText: type == 'password' ? true : false,
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
                type == 'username'
                    ? Icons.person
                    : type == 'email' ? Icons.mail : Icons.lock,
                color: Colors.black87,
              ),
              hintText: 'Enter your $type',
              hintStyle: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
            ),
            validators: type == 'username'
                ? [
                    FormBuilderValidators.required(
                        errorText: 'Please enter your Username'),
                  ]
                : type == 'email'
                    ? [
                        FormBuilderValidators.required(
                            errorText: 'Please enter your Email'),
                        FormBuilderValidators.email(
                            errorText: 'Email\'s not valid')
                      ]
                    : [
                        FormBuilderValidators.required(
                            errorText: 'Please enter your Password')
                      ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignupBtn(UserProvider providerUser) {
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
            'REGISTER',
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
              _submitForm(_fbKey.currentState.value, providerUser);
            }
          }),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () => widget.toggleView(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
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
