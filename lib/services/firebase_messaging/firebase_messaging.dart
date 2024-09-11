import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart';

class FMessaging {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<String> getServerKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "chat-app-5a73b",
          "private_key_id": "0907b88960ce03115eabc4ddf1812b644fc599c3",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC0Irj4VN7XMans\ng8F7Lw+l33FlKgCylTku2cahn7Nx9jqWoPSoZZfbeUF7qnaP8cgQ+5M7e+wxLtkr\nHEAnFzFB3sNGJhc3Hhu3bWCKm6xs/9V2gmsJTq+jeVEvx8DUqZ0wuvK4dZwskHCi\nBj73v05Q18QioBBDBvLJs+2GCa3jHuJUqM8rtTMrzQsiWaGIG3Yk5FkRh+ijG0dx\nmWrM2RLQnhi9FRHpU/R+laaktn6Lu6035MGzDglswPEaRg1tye4gu2Kmtmgu0350\nwg7j7grwlJl5yUM9qjARM+A3xQlaF0/T3Zj6SRUpT1g/OUo2tfcShyhejXDfYnUJ\nGhQ08JodAgMBAAECggEAAabj3Vsh5AVPkpyutIt88D95Ub0t3nVh3d0fZjIJujzQ\n0rrNI5Iy709QW2r3xWApPoagFgaP5u+QDEYpDHK4/+qkDcuhoN7E0EzPetXsod9C\nvOB7TM2M7MnbBb4mNY0MpPrB6REjCoGUltfJ0gnOFQ21fb/MBmFU7qaYwgbqsk99\nPv0B46pImF8iqWyZklxXA8kcv3QoMD6DuBUuW84YjexDe/dFLTuWX5N2b1wol5au\nepMMtU4HgJZbwNtN14GtSFYfR26jI0fNNtJX1P+GZ1EXECf9XgCuLvVkFOlkDaTd\nKg0ab+yLUN6jdvKqu7MGQU1+PH7oBDLQH6oADF+yoQKBgQDmq7GHsTcEZEtrb4Rm\n1Fl7c2Nia3OS9LX16qqpYOUJccdn92ykb5SA595/Fi511z6I22ycOmG05raqPiKN\nw4MAV+8GwyonvrbMMtUMbJH2DUkFR+c/uhgzll3nZQ84MTrFjtdIFHD4QyZDsfMi\nucVzRDvCvWc+xmHKxN385zNgCQKBgQDH6nSQB9Y+r8R8GxSy1rlM2X1UHj1hAtya\nHHxpQSn64UJIvatZPcnXnnPZQZs48iLPfJ3vplzCKGOVJPPrg0tHOshDX4l0A4TY\nVAEtV6/S7pX1olAdExjvbc/9zj/XiLyszuuy2zQEcXe9aCjmKSEX5kFe0aXDuvBX\nbX/wzumGdQKBgQCJSE3UEChKONaaDjiiamcHDdlsTb7vCyzwOsVvIPeu80RWH+9M\nvguH3HeS80SbZYsWMGEnaaeU3mqAT5KJBH8GyU68m5KPLPXl+arKRiNoaOe4eN6s\nErksmqUwffjc3I+53BVMFL5XQr+XMmUdmaplu4pFkCvONIsm/puPVJpC4QKBgQCy\nb0qwz73jX8DRQN6drVfhBvJ9JSyFrSc3iptk2tvcaDhgcqJA2gyRHoWqcYtZLY3y\ngfj50RRT2/beRQhNundzUT00HU6zNPzalUgjr3NoorlIcCJvgP8tnWca039aIlq9\nJ0dq8YohOSG19gUjQayfB05rklYROIaSklKyngwDjQKBgQCnCFZTOMtNBZfmInCE\nZDjVoiG2IO1FR3LChw4c2X+frdSupfraQ4PwMABmOqb7M5uUuzNbqB1VzW/dVQD0\nqLjjaZUAujtm5eYT/Bnc/qgWk1epXP9Vpt1n1OuvJ8nk6R1YMQ3DJ40Qllm2Svn9\ntxHy4f72/G25h1f+h0aqCW3X9Q==\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-ddk28@chat-app-5a73b.iam.gserviceaccount.com",
          "client_id": "110309431747011122026",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ddk28%40chat-app-5a73b.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }

  static Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  static Future<String> getDeviceToken() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await firebaseMessaging.getToken();
    print("token=> $token");
    return token!;
  }

  static void firebaseInit() {
    FirebaseMessaging.onMessage.listen(
      (message) {
        print(message.notification!.title);
        print(message.notification!.body);
      },
    );
  }
}
