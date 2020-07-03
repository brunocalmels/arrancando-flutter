import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/user_profile/_row_botones.dart';
import 'package:arrancando/views/user_profile/cabecera/index.dart';
import 'package:arrancando/views/user_profile/grilla_content/index.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final Usuario user;

  UserProfilePage({
    @required this.user,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  SectionType _activeSectionType = SectionType.publicaciones;
  Map<SectionType, int> _count = {};
  List<ContentWrapper> _items = [];
  bool _sentCount = false;
  bool _sent = false;
  bool _sentMore = false;
  bool _noMore = false;
  int _limit = 6;
  String _master;

  _fetchCount() async {
    _sentCount = true;
    if (mounted) setState(() {});

    ResponseObject resp = await Fetcher.get(
      url: "/content/count.json?user_id=${widget.user.id}",
    );

    if (resp != null && resp.body != null) {
      var data = json.decode(resp.body);
      _master = data['master'] != null && data['master'] != ""
          ? data['master']
          : null;
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
      url: "$url.json?filterrific[user_id]=${widget.user.id}&limit=$_limit",
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
      url:
          "$url.json?filterrific[user_id]=${widget.user.id}&limit=3&offset=$_limit",
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

  _setActiveSection(SectionType type) {
    _activeSectionType = type;
    _noMore = false;
    _limit = 6;
    _fetchElements();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchCount();
    _fetchElements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("@${widget.user.username}"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CabeceraUserProfile(
                user: widget.user,
                master: _master,
              ),
              SizedBox(height: 5),
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
      ),
    );
  }
}
