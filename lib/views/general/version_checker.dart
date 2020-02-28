import 'dart:convert';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionChecker extends StatefulWidget {
  @override
  _VersionCheckerState createState() => _VersionCheckerState();
}

class _VersionCheckerState extends State<VersionChecker> {
  bool showNewVersionBanner = false;

  _verifyVersion() async {
    ResponseObject resp = await Fetcher.get(
      url: '/app-version.json',
    );
    if (resp != null && resp.body != null) {
      if (json.decode(resp.body)['version'] != MyGlobals.APP_VERSION) {
        showNewVersionBanner = true;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this._verifyVersion();
  }

  @override
  Widget build(BuildContext context) {
    return showNewVersionBanner
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Nueva versión',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "Hay una nueva versión disponible de Arrancando!"),
                          FlatButton(
                            padding: const EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 3,
                            ),
                            child: Text(
                              "ACTUALIZAR",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () async {
                              const url =
                                  'https://play.google.com/store/apps/details?id=com.macherit.arrancando';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        showNewVersionBanner = false;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}