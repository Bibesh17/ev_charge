import 'dart:convert';
import 'dart:io';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/user.model.dart';
import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class AuthService {
  Future<void> registerUser({
    required BuildContext context,
    String? username,
    required String fullName,
    required String password,
    String? phoneNumber,
    String? email,
    required File image,
  }) async {
    try {
      User user = User(
        id: '',
        username: username ?? '',
        fullName: fullName,
        password: password,
        phoneNumber: phoneNumber ?? '',
        email: email ?? '',
        image: image,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/register'),
        body: jsonEncode(user.toJson()), // Ensure it's encoded properly
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      errorHandler(
        response: res,
        context: context,
        onSuccess: () => showSnackBar(context,
            "User registered successfully. Login with the same credentials."),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> loginUser({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      // Check network connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        showSnackBar(context, "No internet connection");
        return;
      }

      // Send login request
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/login'),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Handle response
      errorHandler(
        response: res,
        context: context,
        onSuccess: () => Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        ),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
