import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  DatabaseService();
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser({required String username, required String password,
    required String confirm_password,required String firstLast,required String profileUrl,required String phone}) async {
    return await userCollection.doc(username).set({
      'username': username,
      'password': password,
      'confirm_password': confirm_password,
      'firstLast': firstLast,
      'profileUrl': profileUrl,
      'phone':phone,
    });
  }

  Future<void> updatePasswords({required String username,required String password}) async {
    return await userCollection.doc(username).update({
      'username': username,
      'password': password,
    });
  }
}
