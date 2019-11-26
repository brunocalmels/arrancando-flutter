import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

abstract class DynamicLinks {
  static initUniLinks({BuildContext context}) async {
    Stream<Uri> streamURI = getUriLinksStream();
    streamURI.listen(
      (Uri uri) {
        if (uri != null) {
          // Mensaje mensaje = Mensaje.fromJson({"url": uri.path});
          // mensaje.redirectToPath(context: context);
          print(uri);
        }
      },
      onError: (e) {
        print(e);
      },
    );
  }
}
