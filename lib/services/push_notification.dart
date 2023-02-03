import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    final notification = message.data['notification'];
  }
}

class FCM {
  final fbm = FirebaseMessaging.instance;

  final stream = StreamController<String>.broadcast();
  final title = StreamController<String>.broadcast();
  final body = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message.data.containsKey('data')) {
          stream.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          stream.sink.add(message.data['notification']);
        }

        title.sink.add(message.notification!.title!);
        body.sink.add(message.notification!.body!);
      },
    );

    final token = fbm.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    stream.close();
    body.close();
    title.close();
  }
}
