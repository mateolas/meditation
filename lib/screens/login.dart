import 'package:take_a_breath/api/hParameter_api.dart';
import 'package:take_a_breath/model/user.dart';
import 'package:take_a_breath/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:take_a_breath/screens/homeScreen.dart';

import 'package:google_sign_in/google_sign_in.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  User _user = User();

  final kBoxDecorationStyle = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [
        Colors.orange[200],
        Colors.orange[200],
      ],
    ),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'Calibri',
    fontSize: 20,
  );

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Calibri',
    fontSize: 20,
  );

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
  }

  Widget _buildLogoPicture() {
    return Column(
      children: [
        SizedBox(height: 48.0),
        //Image.asset('lib/assets/images/pulse_logo.png', scale: 1.2),
        SizedBox(height: 6.0),
        Text('Meditation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(height: 32.0),
      ],
    );
  }

  Widget _buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display name',
          style: kLabelStyle,
        ),
        SizedBox(height: 4.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 58.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Calibri',
              fontSize: 20,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: TextStyle(fontSize: 11, height: 0.1),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your Display name',
              hintStyle: kHintTextStyle,
              labelStyle: TextStyle(color: Colors.white),
            ),
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            validator: (String value) {
              if (value.isEmpty) {
                return '     Display Name is required';
              }

              if (value.length < 2 || value.length > 12) {
                return '     Display Name must be betweem 2 and 12 characters';
              }

              return null;
            },
            onSaved: (String value) {
              _user.displayName = value;
            },
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _signInGoogleButton() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    return ButtonTheme(
      //minWidth: 200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 32),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          color: Colors.white,
          padding: EdgeInsets.all(15.0),
          onPressed: () => signInWithGoogle(authNotifier),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                width: 22,
                height: 22,
                image: AssetImage(
                  'lib/assets/images/google_logo.png',
                ),
              ),
              Text(
                '  Signup with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange[400],
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ButtonTheme(
      //minWidth: 200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 72, 0, 12),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          color: Colors.white,
          padding: EdgeInsets.all(15.0),
          onPressed: () => _submitForm(),
          child: Text(
            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP',
            style: TextStyle(
              fontSize: 20,
              color: Colors.orange[400],
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 4.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 58.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Calibri',
              fontSize: 20,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              //contentPadding:
              //EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
              errorStyle: TextStyle(fontSize: 11, height: 0.1),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            inputFormatters: [BlacklistingTextInputFormatter(RegExp("[ ]"))],
            validator: (String value) {
              if (value.isEmpty) {
                return '     Email is required';
              }

              if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return '     Please enter a valid email address';
              }

              return null;
            },
            onSaved: (String value) {
              _user.email = value;
            },
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 4.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 58.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Calibri',
              fontSize: 20,
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 11, height: 0.1),
              border: InputBorder.none,
              //contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: "Password",
              hintStyle: kHintTextStyle,
            ),
            //cursorColor: Colors.black,
            obscureText: true,
            controller: _passwordController,
            validator: (String value) {
              if (value.isEmpty) {
                return '     Password is required';
              }

              if (value.length < 5 || value.length > 20) {
                return '     Password must be betweem 5 and 20 characters';
              }

              return null;
            },
            onSaved: (String value) {
              _user.password = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Text(
          'Confirm Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 4.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 58.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Calibri',
              fontSize: 20,
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 11, height: 0.1),
              border: InputBorder.none,
              hintText: "Confirm Password",
              hintStyle: kHintTextStyle,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
            ),
            obscureText: true,
            validator: (String value) {
              if (_passwordController.text != value) {
                return '    Passwords do not match';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building login screen");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    //Endless River
                    //Color(0xff16A085),
                    //Color(0xffffffff),
                    
                    Color(0xffe65c00),
                    Color(0xffFFE000),
                    //Color(0xffffff),
                  ],
                  //stops: [0.1, 0.4],
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              //decoration: BoxDecoration(color: Colors.white),
              child: Form(
                autovalidate: false,
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(32, 20, 32, 0),
                    child: Column(
                      children: <Widget>[
                        _buildLogoPicture(),
                        SizedBox(height: 24),
                        Text(
                          _authMode == AuthMode.Login ? 'Log In' : 'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 48),
                        _authMode == AuthMode.Signup
                            ? _buildDisplayNameField()
                            : Container(),
                        _buildEmailField(),
                        _buildPasswordField(),
                        _authMode == AuthMode.Signup
                            ? _buildConfirmPasswordField()
                            : Container(),
                        SizedBox(height: 12),
                        _buildLoginButton(),
                        Text(
                          'or',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _signInGoogleButton(),
                        ButtonTheme(
                          minWidth: 200,
                          child: FlatButton(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _authMode == AuthMode.Login
                                        ? 'Don\'t have an Account ? '
                                        : 'Already have an Account ? ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _authMode == AuthMode.Login
                                        ? 'Signup'
                                        : 'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _authMode = _authMode == AuthMode.Login
                                    ? AuthMode.Signup
                                    : AuthMode.Login;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
