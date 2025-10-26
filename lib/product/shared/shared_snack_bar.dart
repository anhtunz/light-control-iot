import 'package:flutter/material.dart';
import 'package:smt_project/product/extension/context_extension.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showNoIconTopSnackBar(BuildContext context, String message,
    Color backgroundColor, Color textColor) {
  if (!context.mounted) return;
  showTopSnackBar(
      Overlay.of(context),
      Card(
        color: backgroundColor,
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
      displayDuration: context.lowDuration);
}

void showSuccessTopSnackBarCustom(BuildContext context, String message) {
  if (!context.mounted) return;
  showTopSnackBar(
      Overlay.of(context),
      SizedBox(
          height: 60,
          child: CustomSnackBar.success(
              message: message,
              icon: const Icon(Icons.sentiment_very_satisfied_outlined,
                  color: Color(0x15000000), size: 80))),
      displayDuration: context.lowDuration);
}

void showErrorTopSnackBarCustom(BuildContext context, String message) {
  if (!context.mounted) return;
  showTopSnackBar(
      Overlay.of(context),
      SizedBox(
          height: 60,
          child: CustomSnackBar.error(
              message: message,
              icon: const Icon(Icons.sentiment_dissatisfied_outlined,
                  color: Color(0x15000000), size: 80))),
      displayDuration: context.lowDuration);
}
