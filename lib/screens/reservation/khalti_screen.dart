import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiScreen extends StatefulWidget {
  static const String routeName = '/khalti-screen';
  const KhaltiScreen({super.key});

  @override
  State<KhaltiScreen> createState() => _KhaltiScreenState();
}

class _KhaltiScreenState extends State<KhaltiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: payWithKhaltiInApp,
          child: const Text('Pay with Khalti'),
        ),
      ),
    );
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000, //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onKhaltiSuccess,
      onFailure: onKhaltiFailure,
      onCancel: onKhaltiCancelled,
    );
  }

  void onKhaltiSuccess(PaymentSuccessModel success) {
    showSnackBar(context, 'Payment Successful');
  }

  void onKhaltiFailure(PaymentFailureModel failure) {
    showSnackBar(context, 'Payment Failed');
  }

  void onKhaltiCancelled() {
    showSnackBar(context, 'Payment Cancelled');
  }
}
