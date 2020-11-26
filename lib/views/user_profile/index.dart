import 'dart:convert';
import 'dart:ui';

import 'package:arrancando/config/fonts/arrancando_icons_icons.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
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
  final _count = <SectionType, int>{};
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
  int _likes = 0;
  int _experiencia = 0;
  bool _initialLoad = true;

  void _setActiveSection(SectionType type) {
    _activeSectionType = type;
    _noMore = false;
    _limit = 6;
    _fetchElements();
    if (mounted) setState(() {});
  }

  Future<void> _fetchCount() async {
    _sentCount = true;
    if (mounted) setState(() {});

    final resp = await Fetcher.get(
      url: '/content/count.json?user_id=${_user.id}',
    );

    if (resp != null && resp.body != null) {
      var data = json.decode(resp.body);
      _master = data['master'] != null && data['master'] != ''
          ? data['master']
          : null;
      _siguiendo = data['siguiendo'];
      _seguidos = data['seguidos'];
      _seguidores = data['seguidores'];
      _likes = data['likes'];
      _experiencia = data['experiencia'];
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

  String _getUrl() {
    var url;
    switch (_activeSectionType) {
      case SectionType.publicaciones:
        url = '/publicaciones';
        break;
      case SectionType.recetas:
        url = '/recetas';
        break;
      case SectionType.pois:
        url = '/pois';
        break;
      // case SectionType.wiki:
      //   url = '/wiki';
      //   break;
      default:
        url = '/publicaciones';
        break;
    }
    return url;
  }

  Future<void> _fetchElements() async {
    _sent = true;
    if (mounted) setState(() {});
    final url = _getUrl();

    final resp = await Fetcher.get(
      url: '$url.json?filterrific[user_id]=${_user.id}&limit=$_limit',
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

  Future<void> _fetchMore() async {
    _sentMore = true;
    if (mounted) setState(() {});
    final url = _getUrl();

    final resp = await Fetcher.get(
      url: '$url.json?filterrific[user_id]=${_user.id}&limit=3&offset=$_limit',
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

  Future<void> _seguir({bool noSeguir = false}) async {
    _sentSeguir = true;
    if (mounted) setState(() {});

    if (!noSeguir) {
      final resp = await Fetcher.post(
        url: '/seguimientos.json',
        body: {
          'seguido_id': _user.id,
        },
      );
      if (resp != null && resp.body != null) {
        _siguiendo = json.decode(resp.body)['id'];
      }
    } else {
      if (_siguiendo != null) {
        final resp = await Fetcher.destroy(
          url: '/seguimientos/$_siguiendo.json',
        );
        if (resp != null && resp.status != null) {
          _siguiendo = null;
        }
      }
    }

    await _fetchCount();

    _sentSeguir = false;
    if (mounted) setState(() {});
  }

  Future<void> _fetchUserAndInfo() async {
    if (widget.username != null) {
      final resp = await Fetcher.get(
        url: '/users/by_username.json?username=${widget.username.trim()}',
      );

      if (resp != null && resp.body != null) {
        _user = Usuario.fromJson(json.decode(resp.body));
        await _fetchCount();
        await _fetchElements();
      }
    }
    _loaded = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.user != null) {
        _user = widget.user;
        _loaded = true;
        await _fetchCount();
        await _fetchElements();
      } else {
        await _fetchUserAndInfo();
      }
      _initialLoad = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _initialLoad
          ? null
          : AppBar(
              title: _user != null ? Text('@${_user.username}') : null,
            ),
      body: _initialLoad
          ? SafeArea(child: LoadingWidget())
          : _user != null && _loaded
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Me Gusta: ',
                                  ),
                                  Text(
                                    '$_likes',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 1.5,
                                  height: 20,
                                  color: Utils.activeTheme(context) ==
                                          ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Experiencia: ',
                                  ),
                                  Text(
                                    '$_experiencia',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_user.urlInstagram != null &&
                            _user.urlInstagram.isNotEmpty)
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
                                    'INSTAGRAM',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    ArrancandoIcons.instagram,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                var profile = _user.urlInstagram;
                                if (!profile.contains('http') ||
                                    !profile.contains('instagram')) {
                                  profile =
                                      'https://instagram.com/${profile.split('/').last}';
                                }
                                if (await canLaunch(profile)) {
                                  await launch(
                                    profile,
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                } else {
                                  throw 'Could not launch $profile';
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
                          'Este usuario no existe',
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
