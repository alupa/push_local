import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print('==== FCM Token ====');
      print(token);  //ctS__ctJScU:APA91bEKNlOE7SY84AyHev64jwowzWxdAoY9EY9vkSp6PCu7EM1EGZMZe8YDbX-YtoBO6xpM2sxmyvGRSYnaNz8sE0_25ieZCxObeI5_hGc8NVOtV11pNkPuzYAdHDWgTjDSsJIrB5cb
    });

    _firebaseMessaging.configure(
      onMessage: (info) async {
        print('========= On Message ========');
        print(info);

        String argumento = 'no-data';
        if(Platform.isAndroid)
          argumento = info['data']['comida'] ?? 'no-data';
        else
          argumento = info['comida'] ?? 'no-data-ios';

        _mensajesStreamController.sink.add(argumento);
      },
      onLaunch: (info) async {
        print('========= On Launch ========');
        print(info);
      },
      onResume: (info) async {
        print('========= On Resume ========');
        print(info);

        String argumento = 'no-data';
        if(Platform.isAndroid)
          argumento = info['data']['comida'] ?? 'no-data';
        else
          argumento = info['comida'] ?? 'no-data-ios';
          
        _mensajesStreamController.sink.add(argumento);
      }
    );
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}