import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void initNotifications(BuildContext context) async {
  var fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM token: " + (fcmToken ?? "no token"));

  FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  IOSInitializationSettings iosSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
    //TODO mostrar notificación para iOS menor a 10
  });

  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings('ic_booksy_not');

  InitializationSettings initSettings =
      InitializationSettings(iOS: iosSettings, android: androidSettings);

  await notifications.initialize(initSettings,
      onSelectNotification: (payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Notificación apretada"),
              content: Text(payload!),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancelar'),
                  child: const Text('Ok!'),
                ),
              ],
            ));
  });

  //Esto sólo es para ejemplificar su uso
  //startReadingReminder();
}

void startReadingReminder() {
  // Setear un recordatorio para que el usuario lea cada cierto tiempo, i.e.: todos los días a las 22.00
  // TODO agregar una pantalla donde los usuarios puedan activar/desactivar y configurar esto.
  Future.delayed(const Duration(seconds: 4), () {
    _showNotification();
  });
}

void _showNotification() {
  FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidSpecifics =
      AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          priority: Priority.high);

  notifications.show(
      111,
      "Mensaje de Booksy",
      "Recuerda leer 15 páginas de tu libro",
      const NotificationDetails(android: androidSpecifics),
      payload: "20");
}
