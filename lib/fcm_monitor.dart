import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmTokenMonitor extends StatefulWidget {
  const FcmTokenMonitor({Key? key, required this.builder}) : super(key: key);

  final Widget Function(String? token) builder;

  @override
  State<StatefulWidget> createState() => _FcmTokenMonitor();
}

class _FcmTokenMonitor extends State<FcmTokenMonitor> {
  String? _fcmToken;
  late Stream<String> _tokenStream;

  void setToken(String? token) {
    print("FCM token: $token");
    setState(() {
      _fcmToken = token;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging
        .getToken(
            vapidKey:
                "BLFlTeCg7Yozbk0p48rdQXm8WdoQbh_G_Waf5W1f1BE1WJYCvqcL9VcdA43eD1wudGx0tLKeTn6h6qdiIGsbE18")
        .then(setToken);
    _tokenStream = messaging.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_fcmToken);
  }
}

void configureNotifications() {}
