import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameTextController =
  new TextEditingController();
  final TextEditingController _lastNameTextController =
  new TextEditingController();
  final TextEditingController _emailTextController =
  new TextEditingController();
  final TextEditingController _phoneTextController =
  new TextEditingController();
  final TextEditingController _oldPasswordTextController =
  new TextEditingController();
  final TextEditingController _newPasswordTextController =
  new TextEditingController();
  final TextEditingController _confirmPasswordTextController =
  new TextEditingController();
  GlobalKey<FormState> _formKey1 = new GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  String version = "";
  String buildNumber = "";
  bool isResetPassword = false;
  bool _form1Autovalidate = false;
  bool _form2Autovalidate = false;
  bool _isFacebookUser = false;
  bool _isUploading = false;
  String _currentPassword;
  bool _isProfileEdited = false;
  var kMarginPadding = 16.0;
  var kFontSize = 13.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            top: true,
            child: Center(
              child: Column(
                children: <Widget>[
                  new Container(
                    //color: Constants.lg_green,
                    height: 250.0,
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [Colors.green[300], Colors.green[700]],
                          begin: const FractionalOffset(0.1, 0.0),
                          end: const FractionalOffset(0.6, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: FlatButton(
                              child: Text(
                                "Sign out",
                              ),
                              onPressed: () => _signOutButtonTapped()),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: _background(),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding:
                            EdgeInsets.only(left: 80.0, bottom: 25.0),
                            child: new CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20.0,
                              child: IconButton(
                                  icon: Icon(Icons.edit),
                                  iconSize: 25.0,
                                  color: Colors.blueGrey,
                                  onPressed: () => _showDialogue()),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  new Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 5.0,
                    //color: Constants.lg_gray_light,
                    child: _profileItems(),
                  ),
                  _isFacebookUser
                      ? new Container()
                      : Container(
                    margin: EdgeInsets.only(right: kMarginPadding),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          child: Text(
                            "Reset Password",
                          ),
                          onPressed: () {
                            setState(() {
                              _oldPasswordTextController.clear();
                              _newPasswordTextController.clear();
                              _confirmPasswordTextController.clear();
                              isResetPassword
                                  ? isResetPassword = false
                                  : isResetPassword = true;
                            });
                          }),
                    ),
                  ),
                  isResetPassword
                      ? new Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 5.0,
                    //color: Constants.lg_gray_light,
                    child: _passwordRestCard(),
                  )
                      : new Container(),
                  _bottomCard()
                ],
              ),
            )),
      ),
    );
  }

  Widget _profileItems() {
    return Form(
        key: _formKey1,
        autovalidate: _form1Autovalidate,
        child: Column(
          children: <Widget>[
            new Container(
              //width: 130.0,
              height: 105.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Expanded(
                    child: LGTitleTextFormField(
                      padding: EdgeInsets.all(kMarginPadding),
                      title: "First name",
                      hintText: "edit first name",
                      emptyValidator: true,
                      emptyValidatorMsg: "Enter first name",
                      controller: _firstNameTextController,
                      onEditingComplete: _onEditingComplete,
                    ),
                  ),
                  new Expanded(
                    child: LGTitleTextFormField(
                      padding: EdgeInsets.all(kMarginPadding),
                      title: "Last name",
                      hintText: "edit last name",
                      emptyValidator: true,
                      emptyValidatorMsg: "Enter last name",
                      controller: _lastNameTextController,
                      onEditingComplete: _onEditingComplete,
                    ),
                  )
                ],
              ),
            ),
            LGTitleTextFormField(
              padding:
              EdgeInsets.only(left: kMarginPadding, right: kMarginPadding),
              title: "Email",
              hintText: "Enter",
              controller: _emailTextController,
              onEditingComplete: _onEditingComplete,
              disable: true,
            ),
            LGTitleTextFormField(
              padding: EdgeInsets.all(kMarginPadding),
              title: "Phone",
              hintText: "edit phone number",
              textInputType: TextInputType.numberWithOptions(),
              emptyValidator: true,
              emptyValidatorMsg: "Enter phone number",
              controller: _phoneTextController,
              inputFormatters: [
                new BlacklistingTextInputFormatter(new RegExp('[\\.|\\,|\\-]')),
              ],
              onEditingComplete: _onEditingComplete,
            ),
          ],
        ));
  }

  Widget _passwordRestCard() {
    return Form(
        key: _formKey2,
        autovalidate: _form2Autovalidate,
        child: Column(
          children: <Widget>[
            LGTitleTextFormField(
                padding: EdgeInsets.only(
                    top: kMarginPadding,
                    left: kMarginPadding,
                    right: kMarginPadding,
                    bottom: kMarginPadding),
                title: "Old Password",
                hintText: "Enter your old password",
                controller: _oldPasswordTextController,
                onEditingComplete: _onEditingComplete,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Old password should not be empty";
                  } else if (value != _currentPassword) {
                    return "Passwords is wrong";
                  } else {
                    return null;
                  }
                },
                obscureText: true),
            LGTitleTextFormField(
                padding: EdgeInsets.only(
                    left: kMarginPadding,
                    right: kMarginPadding,
                    bottom: kMarginPadding),
                title: "New Password",
                hintText: "Enter your new password",
                controller: _newPasswordTextController,
                onEditingComplete: _onEditingComplete,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "password should not be empty";
                  } else if (value == _currentPassword) {
                    return "Please use some other password.";
                  } else if (value.length < 6) {
                    return "Please enter atleast 6 characters";
                  } else {
                    return null;
                  }
                },
                obscureText: true),
            LGTitleTextFormField(
                padding: EdgeInsets.all(kMarginPadding),
                title: "Confirm New Password",
                hintText: "Confirm new Password",
                controller: _confirmPasswordTextController,
                onEditingComplete: _onEditingComplete,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "password should not be empty";
                  } else if (_newPasswordTextController.text != value) {
                    return "Passwords does not match";
                  } else {
                    return null;
                  }
                },
                obscureText: true),
          ],
        ));
  }

  Widget _bottomCard() {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: new Text("Save"),
          onPressed: _isProfileEdited ? () => _saveButtonTapped() : null,
        ),
        SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              InkWell(
                child: Text(
                  "Privacy policy",
                ),
                onTap: () => _launchPrivacypolicyUrl(),
              ),
              Text(
                "Version " + version,
              ),
              Text(
                "Build number " + buildNumber,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  _onEditingComplete() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isProfileEdited = true;
    });
  }

  Future _showDialogue() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Select Photo",
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => _getImage(),
                  child: new Text(
                    "Camera",
                  )),
              new FlatButton(
                  onPressed: () => _getImage(),
                  child: new Text(
                    "Gallery",
                  ))
            ],
          );
        });
  }

  Future _getImage() async {

  }

  _saveButtonTapped() {
    if (isResetPassword) {
      if (_formKey2.currentState.validate()) {
        //reset password
      } else {
        setState(() => _form2Autovalidate = true);
      }
    } else {
      if (_formKey1.currentState.validate()) {
        //profile update
      } else {
        setState(() => _form1Autovalidate = true);
      }
    }
  }





  Widget _background() {
    return new Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: new Container(
            width: 180.0,
            height: 180.0,
            decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),
              borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
              border: new Border.all(
                color: Colors.white,
                width: 5.0,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: _isUploading ? CircularProgressIndicator() : new Container(),
        ),
      ],
    );
  }


  _signOutButtonTapped() {

  }

  _launchPrivacypolicyUrl() async {

  }

}


class LGTitleTextFormField extends StatelessWidget {
  LGTitleTextFormField({
    this.title,
    this.hintText,
    this.controller,
    this.validator,
    this.emptyValidator = false,
    this.emptyValidatorMsg = "Should not be empty",
    this.textInputType,
    this.padding,
    this.disable = false,
    this.obscureText = false,
    this.onEditingComplete,
    this.inputFormatters
  });

  final String title;
  final String hintText;
  final TextEditingController controller;
  final Function validator;
  final bool emptyValidator;
  final String emptyValidatorMsg;
  final TextInputType textInputType;
  final EdgeInsetsGeometry padding;
  final bool disable;
  final bool obscureText;
  final VoidCallback onEditingComplete;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: padding,
      child: new Column(
        children: <Widget>[
          new Container(
              alignment: Alignment.topLeft,
              child: new Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.blueGrey),
              )),
          new TextFormField(
              controller: controller,
              validator: emptyValidator ? _validateField : validator,
              keyboardType: textInputType,
              readOnly: disable,
              inputFormatters: inputFormatters,
              obscureText: obscureText,
              onEditingComplete: onEditingComplete != null ? onEditingComplete : _onEditingCompleted(context),
              style: new TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: new TextStyle(
                  fontSize: 17.0,
                ),
              ))
        ],
      ),
    );
  }

  _onEditingCompleted(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String _validateField(String text) {
    if (text.length == 0) {
      return emptyValidatorMsg;
    } else {
      null;
    }
  }
}
