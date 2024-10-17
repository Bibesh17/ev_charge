import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ev_charge/constants/cloudinary_keys.dart';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/station.model.dart';
import 'package:ev_charge/screens/verification/login_page.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  Future<void> registerStation({
    required BuildContext context,
    required String stationName,
    required String username,
    required String password,
    required String phoneNumber,
    required String location,
    required int noOfSlots,
    required XFile image,
  }) async {
    try {
      final cloudinary =
          CloudinaryPublic(kCloudinaryCloudName, kCloudinaryUploadPreset);

      CloudinaryResponse cloudinaryRes = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image.path, folder: 'station'));
      final imageUrl = cloudinaryRes.secureUrl;
      Station station = Station(
        id: '',
        name: stationName,
        username: username,
        phoneNumber: phoneNumber,
        password: password,
        location: location,
        panCard: imageUrl,
        noOfSlots: noOfSlots,
        reservedSlots: 0,
        isVerified: false,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/stations/register'),
        body: station.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      errorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              "Station registered successfully. Login with the same credentials.",
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> loginStation({
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
        Uri.parse('$uri/api/v1/stations/login'),
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
        onSuccess: () async {
          showSnackBar(context, 'Station logged in.');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
