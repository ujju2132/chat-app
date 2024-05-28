import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx, File selectedImage) async {
    UserCredential userCredential;
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(userCredential);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}');
        await storageRef.putFile(selectedImage);
        print(userCredential);
        final imageLink = await storageRef.getDownloadURL();
        print(imageLink);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': imageLink,
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = ' An error occured, please check your credentials';

      if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
            child: Image.asset('assets/chat.png'),
            height: MediaQuery.of(context).size.height * 0.26,
            width: MediaQuery.of(context).size.width * 0.55,
          ),
          AuthForm(_submitAuthForm),
          // SizedBox(
          //   height: MediaQuery.of(context).viewInsets.bottom
          //   ,
          // )
        ]),
      ),
    );
  }
}