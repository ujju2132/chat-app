import 'dart:io';

import 'package:chatting/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn);

  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
    File selectedImage
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _islogin = true;
  var _email = '';
  var _userNmae = '';
  var _password = '';
  File? _selectedImage;

  void _trySubmit() {
    final isValis = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValis || !_islogin && _selectedImage == null) {
      return;
    }

    if (isValis) {
      _formKey.currentState!.save();
      widget.submitFn(_email, _password, _userNmae, _islogin, context, _selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 50,
        surfaceTintColor: Color.fromARGB(255, 139, 9, 239),
        shadowColor: Color.fromARGB(255, 36, 16, 249),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_islogin)
                      UserImagePicker(
                        onPickImage: (pickedImage) {
                          _selectedImage = pickedImage;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Plesae enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                    ),
                    if (!_islogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 4) {
                            return 'Please enter a user name of at least 4 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userNmae = value!;
                        },
                        decoration: InputDecoration(labelText: 'User Name'),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_islogin ? 'Login' : 'SignUp'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _islogin = !_islogin;
                        });
                      },
                      child: Text(_islogin
                          ? 'Create a new account'
                          : 'Ialready have an account'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
