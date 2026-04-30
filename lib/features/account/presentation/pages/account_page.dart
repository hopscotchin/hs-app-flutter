import 'package:flutter/material.dart';

import '../../../../components/error_retry_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Navigate to wishlist — stub
            },
          ),
        ],
      ),
      body:  ErrorRetryWidget(
        message: "Your Account Page is loading soon..!! Stay Tuned..!!",
        onRetry: VoidCallbackAction.new,
      ),
    );
  }
}
