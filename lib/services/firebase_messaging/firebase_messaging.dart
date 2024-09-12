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
          "private_key_id": "bc1b49f7521693b5f18be4c4421e171cfcd231ae",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQC2V8egULdjBAZx\nkGtu0qz1XuNPKo/N3JkUwXD9f5Hup30o287e/yyD1ZS5/NPYVQbbOJE9g8FljgqZ\nA34gN+VUcE+fgrceun8RwN+K0KkiN7TsKgoN4DTTHSjWSyd6K+pindhZlTDB8dZZ\n/gqmkdo6piBKDTo0WlvI/9JH0rg4voK2NjJS8wpO2itCu+QU5fSFLJAbkj20VZeF\nnUnGKAkJnMvGTgvVQoiX34ttzH3to/gEl+q7Fk0Oe0LawchBTxYhVyabyRUGxPW+\njtNk9SBAq6555B57vNzZ/cAxRSyuwDzhCGLIXbZbgZTYZB0x27ALxlpli1EnXcuI\nZ7glu4yJAgMBAAECgf8tSGkUrOdpr5Y3pXdlwK4Mf6MaghKJt/Fjk0HCACpsIfXM\nXl19veEhpgf0CVHJMWP23qEUGiB42eTPnwarw1Ti6S/kqyzO0d7rNG84KRW4r4HC\nqG/1y+bWWFf6c0qv1iidHrUIgoCCBsNEUD8uFtwLtJq80Ok24NykoW8LrPtoYYuY\n8S4ngHZuRYsnlj3z6rMWWcpmjX52vRAzK52NTnnNNP/5e0hYnmbUI0PDqtusfsn5\naStzKsjCaH1hQnAF7pARXnlFsK13l7OZv1mfwHBWplXHa9v4WZItau0Pr9U/0+Nb\n+NbwVd9DGfUkstIAd16N4ZOpxIdTGK8unAYWqyECgYEA4Jap5HoessGmd+TBhrQu\nPdooRVbbt0OChU0LFafgzMUYBlTPfF+dY8Wp58Jdb3paUmYRRPd3aj/5pkA3+9/U\nOR9TpxYCIR8fq/oOsT/zGmblwMGQhfYzVdfy+kp2ysoH7ozYZdiAfvu5CqNOjxAq\nh+37I7mSYn+vFjEYNFA9GT0CgYEAz9iFgwalr62hn3gs3t2ECMWJa5399z5ZAIgq\nAlqBNKILLv4TfR4v6753ZhPKgZs62Wr19gE6IVVMBHFUHKFlOYA2wzl23W4APxso\nWtpJhKIkGd+fPb+CWHgU+O4Zm2DW3ivAZGdZlbsKKBfXeIU0iv4oZeYCaOobg+Y8\nBFFdPT0CgYBmPrEhvybyoo6yzoX8WVMj/YmP57cne6iUHzsIpOEG2EPTvhCnwq/Y\nmEh9plL7SWyNTsJV74OB75YsRdg25vOq/cQLsU1O3uiAVtsRfteiEW5Pjs/I7Qj5\n79JCeFwUfl2WELEDzMjTBq57VVWSc/2o3IMVBIrMJO0E4VzvlAf80QKBgD1HPwXE\nXfEPpgkYK1KByL21T7C04f2VGjR38LrE6DcWV2nBawmGbuZ4P0ePKjNQCuezC1U+\nQ180gLcGmp/eTbPIQ10Hgi4CknwIi7tNhENgcnhWX+KapdljfftuZ4pR4Meb6psv\nhVAJ1xK/BL35t+YKzOpOCAPakcYviR5UxsKZAoGBAIUFTqQZhuLX3pJYd6x7cdru\nDzrOdSBuzSYJYqGy66UqZpxX0yUPYbGIdQ6bBdcWzMs2rTC+CUJtuRLi4T9CewNS\n6kdHXdtvwA5WLDy5jsxVyWV50hV8py1PeCHGR/37zGVd+m1JH2dGoyqgyp2OULyg\n2ZCerBBIzNZb8taur5sb\n-----END PRIVATE KEY-----\n",
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
}
