import 'package:breakfreealgo/src/errorpage.dart';
import 'package:flutter/material.dart';
import 'package:breakfreealgo/src/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:breakfreealgo/src/forgetpassword.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:breakfreealgo/src/loadingpage.dart';
import 'package:breakfreealgo/src/appdata.dart';

import 'Widget/bezierContainer.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakfreealgo/src/Baseauth.dart';
import 'package:breakfreealgo/src/dashboard.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title,this.appdata}) : super(key: key);
  final Appdata appdata;
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState(appdata);
}

class _LoginPageState extends State<LoginPage> {
  final Appdata appdata;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  String errortext = '';


  _LoginPageState(this.appdata):super();
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Auth().signOut();
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4), //0xfff3f3f4
                  filled: true))
        ],
      ),
    );
  }
  bool validate()
  {
    bool valid = true;
    setState(() {
      errortext = '';
    });
    if(_email.text.isEmpty || !RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_email.text)){
      valid = false;
      errortext = 'please enter valid email';
      _emailFocusNode.requestFocus();
    } else if(_password.text.isEmpty || _password.text.length<5){
      valid = false;
      errortext = 'password should have atleast 5 characters';
      _pwdFocusNode.requestFocus();
    }

    return valid;
  }



  Widget _submitButton() {
    return InkWell(
        onTap: () {
          if (validate()) {
            print("login with email and password");
            try {
              Auth().signIn(_email.text, _password.text).then((result) {
                if (result != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage()));
                }
              });
            } catch (e) {
              print(e.toString());
            }
          }
        },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff4fae8d), Color(0xff2cd1d1)])), //0xfffbb448, 0xfff7892b
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      )
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    return InkWell(
        onTap: () {
          try {
            Auth().googlesignIn().then((result)
            {
              if (result != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()));
              }
            });
          }catch(e){
            print(e.toString());
          }
        },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      //colors: [Color(0xfffbbc05), Color(0xffea4335)]),
                      colors: [Color(0xffea4335), Color(0xfffbbc05)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('g+',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      //colors: [Color(0xfffbbc05), Color(0xffea4335)]),
                      colors: [Color(0xff34a853), Color(0xfffbbc05)]),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('Log in with Google',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      )
    );
  }



  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Create account',
              style: TextStyle(
                  color: Color(0xff4fae8d), //0xfff79c4f
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
  Widget _icon() {
    return Image(image: AssetImage('images/icon.png'),
        height:50);
  }
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Breakfree',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.bodyText1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff4fae8d), //0xffe46b10
          ),
          children: [
            TextSpan(
              text: 'algo',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        // _entryField("Email id"),
        // _entryField("Password", isPassword: true),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '$errortext',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.bodyText1,
              fontSize: 15,
              color: Colors.red, //0xffe46b10
            ),
          ),
        ),
        TextField(
          controller: _email,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          focusNode: _emailFocusNode,
          obscureText: false,
          decoration: InputDecoration(
              hintText: "Email",
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4), //0xfff3f3f4,0xff4fae8d
              filled: true),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _password,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          focusNode: _pwdFocusNode,
          obscureText: true,
          decoration: InputDecoration(
              hintText: "* Password",
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4), //0xfff3f3f4,0xff4fae8d
              filled: true),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _forgetpassword() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForgotpasswordPage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerRight,
        child: Text('Forgot Password ?',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _icon(),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                  _forgetpassword(),
                  _divider(),
                  _googleButton(),
                  // _facebookButton(),
                  SizedBox(height: height * .04),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
