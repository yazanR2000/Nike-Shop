import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Auth {
  static Future tryToLogin(String email, String pass, BuildContext ctx) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    } catch (err) {
      String? error;
      if(err.toString().contains("user-not-found")){
        error = "User not found!";
      }else{
        error = err.toString();
      }
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            error,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  static Future tryToSignup(String email, String pass, BuildContext ctx) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
    } catch (err) {
      
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            err.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
