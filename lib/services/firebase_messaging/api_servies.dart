import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiServices {
  static final ApiServices apiServices = ApiServices._();

  ApiServices._();

  static const String baseUrl =
      "https://fcm.googleapis.com/v1/projects/chat-app-5a73b/messages:send";

  Future<void> pushNotification({required String title, body, token}) async {
    Map payLoad = {
      "message": {
        "token": token,
        "notification": {"title": title, "body": body},
        "data": {"response": "Message Done !"}
      }
    };
    String dataNotification = jsonEncode(payLoad);
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: dataNotification,
    );
    if (response.statusCode == 200) {
      print('Successfully sent message: ${response.body}');
    } else {
      print('Error sending message: ${response.body}');
    }
    log(response.body);
  }
}

const String serverKey =
    "ya29.c.c0ASRK0GZDjW585-OZj8H511J3aWBn6m9rzA7Kk5WhyHgWUd6HNY37m3H0HktmrPO2iNxlz-KjrFH9Fy4SbVU3QJbPBd8GLfxMDRKdjexXY_TZBSB4pG4DvWdn54lZcwRXrOOZDxylSE_lMUkFMPIBfWPGv6iX03xsaxwswmc0nNFITQvvk0FAoa-FggPTwiTvTFdHWcl9X_jDhfuwg01WgLQPaqtct5h1LCNwTX2TTQ3V9U3nCsDLRuVFBsu3Y9nIciwsIeoawCpjsI-FT56_gPW3pE9qlwsTSBb84x2u8meJ1wly_ZGbKFNFdV3RDcUX4RZ84z3M9FqTHGhVCQbOhGLYEnjsXJAUzzUp0F3CL5GSJNyMdU4JBqNwXg__T389KMMtaa_YlqbSduZocFsWZt1sB1bmo8IZWM6rF8sMq8mYir7VW6n0889BF79Sj_5U0SS9-fbloWu4JcgpM3hBJsJWUborQUY2w6aS209Btj67wzRWF84W1MkFps7vOXFxvtxOV08tbnxyFXfmYIsx5ppxRJ8lFU4_J35qXIgmo9q0lrUvyfnf0srj9WW0Yq-eJYmBpmv7a1no64cYxOk83_je7_9h-Mv5BhibIeFnRJzsUmiY7RStqyjjf-i72ox64oU6yy4cuIwO-tqB56W4gWziut4FSd1emlxJmrjgh6qd9cnluWqwV96qcfB5ooJdfSpSg1aY3fz8_U7z-0z1r-QqmzrJJbg2Qcc6Q8c8jXiFiiuy3p9WeOpFZRnb2kBw-bUxrRh0g4UgxWlngllz4W-6JactsrwBuS36w60tvWRtiO7e7rqh03nvusevhkIzQpysWzq2qSY3pjbI2oayJhBFmFebu3cMhIVRBeSe02kZwonw6Js8Oxk-UvFFhcmxR35ol5tOc6n_uJk3p5UZV7sd-8cqJQu92Vhoch3R9ngI9ZeQ13Fo2Y174yMM1FYZ37JlJyizc3sg4QvwQn3ujqmYSMVq4FcoyzseWSc9yYs1yVJIJamgg2U";
