import 'package:flutter/material.dart';
import 'package:breakfreealgo/src/widget/bezierContainer.dart';
import 'package:breakfreealgo/src/loginpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakfreealgo/src/Baseauth.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}



class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  String errortext = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _password.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _mobileFocusNode.dispose();
    _pwdFocusNode.dispose();
    super.dispose();
  }

  Widget _icon() {
    return Image(image: AssetImage('images/icon.png'),
        height:50);
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
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
                  fillColor: Color(0xfff3f3f4), //0xfff3f3f4,0xff4fae8d
                  filled: true),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () {
          final snackBar = SnackBar(
            content: Text('User accaount is created. Activation email send to registered email. Please activate user before login. '),
            action: SnackBarAction(
              label: 'open',
              onPressed: () {
                print('write code for opening email');
              },
            ),
          );
          if(validate()){
           print("register account");
           try {
             Auth().signUp(_email.text, _password.text);
             Scaffold.of(context).showSnackBar(snackBar);
           }catch(e){
              print(e.toString());
              if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
                setState(() {
                  errortext = 'Email is already registered';
                });
              }else if(e.code == 'ERROR_INVALID_EMAIL'){
                setState(() {
                  errortext = 'Invalid Email. Please registere valid email';
                });
              }else if(e.code == 'ERROR_WEAK_PASSWORD '){
                setState(() {
                  errortext = 'too weak password, please use alphanumeric';
                });
              }
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
                colors: [Color(0xff4fae8d), Color(0xff2cd1d1)])), //0xfffbb448,0xfff7892b
        child: Text(
          'Create Account',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      )
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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

bool validate()
{
  bool valid = true;
  setState(() {
    errortext = '';
  });
  if(_name.text.isEmpty){
    valid = false;
    setState(() {
      errortext = 'please enter name';
    });

    _nameFocusNode.requestFocus();
  }else if(_email.text.isEmpty || !RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(_email.text)){
    valid = false;
    setState(() {
      errortext = 'please enter valid email';
    });

    _emailFocusNode.requestFocus();
  } else if(_mobile.text.isEmpty || _mobile.text.length<10){
    valid = false;
    setState(() {
      errortext = 'mobile number should have more than 10 digit';
    });

    _mobileFocusNode.requestFocus();
  } else if(_password.text.isEmpty || _password.text.length<5){
    valid = false;
    setState(() {
      errortext = 'password should have atleast 5 characters';
    });

    _pwdFocusNode.requestFocus();
  }

  return valid;
}



Widget _emailPasswordWidget() {
  return Column(
    children: <Widget>[
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
          controller: _name,
          textInputAction: TextInputAction.next,
          focusNode: _nameFocusNode,
          obscureText: false,
          decoration: InputDecoration(
              hintText: "* Name",
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4), //0xfff3f3f4,0xff4fae8d
              filled: true),

        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _email,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          focusNode: _emailFocusNode,
          obscureText: false,
          decoration: InputDecoration(
              hintText: "* Email",
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4), //0xfff3f3f4,0xff4fae8d
              filled: true),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _mobile,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          focusNode: _mobileFocusNode,
          obscureText: false,
          decoration: InputDecoration(
              hintText: "* Mobile",
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

  // Widget _emailPasswordWidget() {
  //   return Column(
  //     children: <Widget>[
  //       _entryField("Name"),
  //       _entryField("Email id"),
  //       _entryField("Mobile Number"),
  //       _entryField("Password", isPassword: true),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
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
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .02),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
