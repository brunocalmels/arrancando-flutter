import 'dart:convert';
import 'dart:ui';

import 'package:arrancando/config/fonts/arrancando_icons_icons.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/user_profile/_row_botones.dart';
import 'package:arrancando/views/user_profile/_row_seguidos_seguidores.dart';
import 'package:arrancando/views/user_profile/cabecera/index.dart';
import 'package:arrancando/views/user_profile/grilla_content/index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfilePage extends StatefulWidget {
  final Usuario user;
  final String username;

  UserProfilePage({
    @required this.user,
    this.username,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Usuario _user;
  bool _loaded = false;
  SectionType _activeSectionType = SectionType.publicaciones;
  Map<SectionType, int> _count = {};
  List<ContentWrapper> _items = [];
  bool _sentCount = false;
  bool _sent = false;
  bool _sentMore = false;
  bool _noMore = false;
  int _limit = 6;
  String _master;
  int _siguiendo;
  bool _sentSeguir = false;
  int _seguidos = 0;
  int _seguidores = 0;

  _setActiveSection(SectionType type) {
    _activeSectionType = type;
    _noMore = false;
    _limit = 6;
    _fetchElements();
    if (mounted) setState(() {});
  }

  _fetchCount() async {
    _sentCount = true;
    if (mounted) setState(() {});

    ResponseObject resp = await Fetcher.get(
      url: "/content/count.json?user_id=${_user.id}",
    );

    if (resp != null && resp.body != null) {
      var data = json.decode(resp.body);
      _master = data['master'] != null && data['master'] != ""
          ? data['master']
          : null;
      _siguiendo = data['siguiendo'];
      _seguidos = data['seguidos'];
      _seguidores = data['seguidores'];
      [SectionType.publicaciones, SectionType.recetas, SectionType.pois]
          .forEach(
        (t) {
          _count[t] = data[t.toString().split('.').last];
        },
      );
    }
    _sentCount = false;
    if (mounted) setState(() {});
  }

  _getUrl() {
    String url;
    switch (_activeSectionType) {
      case SectionType.publicaciones:
        url = "/publicaciones";
        break;
      case SectionType.recetas:
        url = "/recetas";
        break;
      case SectionType.pois:
        url = "/pois";
        break;
      // case SectionType.wiki:
      //   url = "/wiki";
      //   break;
      default:
        url = "/publicaciones";
        break;
    }
    return url;
  }

  _fetchElements() async {
    _sent = true;
    if (mounted) setState(() {});
    String url = _getUrl();

    ResponseObject resp = await Fetcher.get(
      url: "$url.json?filterrific[user_id]=${_user.id}&limit=$_limit",
    );

    if (resp != null && resp.body != null) {
      _items = (json.decode(resp.body) as List)
          .map((p) => ContentWrapper.fromJson(p))
          .toList();
    }

    _noMore = _items.length < _limit ? true : _noMore;

    _sent = false;
    if (mounted) setState(() {});
  }

  _fetchMore() async {
    _sentMore = true;
    if (mounted) setState(() {});
    String url = _getUrl();

    ResponseObject resp = await Fetcher.get(
      url: "$url.json?filterrific[user_id]=${_user.id}&limit=3&offset=$_limit",
    );

    if (resp != null && resp.body != null) {
      _items += (json.decode(resp.body) as List)
          .map((p) => ContentWrapper.fromJson(p))
          .toList();
    }

    _limit += 3;

    _noMore = _items.length < _limit ? true : _noMore;

    _sentMore = false;
    if (mounted) setState(() {});
  }

  _seguir({
    bool noSeguir: false,
  }) async {
    _sentSeguir = true;
    if (mounted) setState(() {});

    if (!noSeguir) {
      ResponseObject resp = await Fetcher.post(
        url: "/seguimientos.json",
        body: {
          "seguido_id": _user.id,
        },
      );
      if (resp != null && resp.body != null) {
        _siguiendo = json.decode(resp.body)['id'];
      }
    } else {
      if (_siguiendo != null) {
        ResponseObject resp = await Fetcher.destroy(
          url: "/seguimientos/$_siguiendo.json",
        );
        if (resp != null && resp.status != null) {
          _siguiendo = null;
        }
      }
    }

    _fetchCount();

    _sentSeguir = false;
    if (mounted) setState(() {});
  }

  _fetchUsernAndInfo() async {
    if (widget.username != null) {
      ResponseObject resp = await Fetcher.get(
        url: "/users/by_username.json?username=${widget.username.trim()}",
      );

      if (resp != null && resp.body != null) {
        _user = Usuario.fromJson(json.decode(resp.body));
        _fetchCount();
        _fetchElements();
      }
    }
    _loaded = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _user = widget.user;
      _loaded = true;
      _fetchCount();
      _fetchElements();
      if (mounted) setState(() {});
    } else {
      _fetchUsernAndInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _user != null ? Text("@${_user.username}") : null,
      ),
      body: _user != null && _loaded
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CabeceraUserProfile(
                      user: _user,
                      master: _master,
                      siguiendo: _siguiendo,
                      seguir: _seguir,
                      sentSeguir: _sentSeguir,
                    ),
                    if (_user.urlInstagram != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: RaisedButton(
                          color: Color(0xffd31752),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "INSTAGRAM",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.bodyText2.color,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                ArrancandoIcons.instagram,
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (await canLaunch(_user.urlInstagram)) {
                              await launch(
                                _user.urlInstagram,
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            } else {
                              throw 'Could not launch ${_user.urlInstagram}';
                            }
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RowSeguidosSeguidores(
                        userId: _user.id,
                        seguidos: _seguidos,
                        seguidores: _seguidores,
                      ),
                    ),
                    SizedBox(height: 15),
                    _sentCount
                        ? Container(
                            height: 100,
                            child: Center(
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : RowBotonesUserProfile(
                            activeSection: _activeSectionType,
                            setActiveSection: _setActiveSection,
                            count: _count,
                          ),
                    SizedBox(height: 15),
                    _sent
                        ? Container(
                            height: 200,
                            child: Center(
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : GrillaContentUserProfile(
                            items: _items,
                            type: _activeSectionType,
                            fetchMore: _fetchMore,
                            sentMore: _sentMore,
                            noMore: _noMore,
                          ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            )
          : _user == null && _loaded
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Este usuario no existe",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
    );
  }
}
