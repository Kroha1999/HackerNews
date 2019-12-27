import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum Status {
  success,
  warning,
  error,
}

class NotificationMixin {
  void showFlushBar(
    BuildContext context,
    String text, {
    Status status = Status.success,
    String title,
    int seconds = 3,
    double margin = 8,
    double borderRadius = 8,
  }) {
    Color color;
    switch (status) {
      case Status.warning:
        color = Colors.orange;
        break;
      case Status.error:
        color = Colors.red;
        break;
      default:
        color = Colors.teal;
    }
    Flushbar(
      backgroundColor: color,
      message: text,
      title: title,
      duration: Duration(seconds: seconds),
      margin: margin == null ? null : EdgeInsets.all(margin),
      borderRadius: borderRadius,
    )..show(context);
  }
}
