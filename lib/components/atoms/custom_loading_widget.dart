import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';

class CustomLoadingWidget extends StatelessWidget {
  final String? message;
  final double loaderSize;
  final Color color;

  const CustomLoadingWidget({
    super.key,
    this.message,
    this.loaderSize = 40,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: message.isNotNullOrEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: loaderSize,
                  height: loaderSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 16),
                Text(message!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            )
          : SizedBox(
              width: loaderSize,
              height: loaderSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
    );
  }
}
