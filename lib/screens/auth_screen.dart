import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');

        ref.putFile(image).whenComplete((() async {
          final url = await ref.getDownloadURL();
          var users = FirebaseFirestore.instance.collection('users');
          users.doc(authResult.user.uid).set({
            'username': username,
            'email': email,
            'image_url': url,
          });
        }));

        // final ref = FirebaseStorage.instance
        //     .ref()
        //     .child('user_image')
        //     .child(authResult.user.uid + '.jpg');

        // await ref.putFile(image); // you can also add StorageMetaData

        // final url = await ref.getDownloadURL();

        // if (ref.getDownloadURL != null)
        //   await Firestore.instance
        //       .collection('users')
        //       .document(authResult.user.uid)
        //       .setData({
        //     'username': username,
        //     'email': email,
        //     'image_url': url,
        //   });
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials!';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(message)),
            ],
          ),
          backgroundColor: Theme.of(ctx).errorColor,
          duration: Duration(milliseconds: 3000),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
            padding: EdgeInsets.all(0.5),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   width: 10,
                // ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.business),
                  color: Colors.white,
                  iconSize: 10,
                ),
                Text(
                  'Developed by Sirlopu Technology Group, LLC',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                // SizedBox(
                //   width: 10,
                // ),
              ],
            )),
      ),
    );
  }
}
