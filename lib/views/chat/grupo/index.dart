import 'dart:convert';

import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/chat/grupo/show/index.dart';
import 'package:flutter/material.dart';

class GrupoChatPage extends StatefulWidget {
  @override
  _GrupoChatPageState createState() => _GrupoChatPageState();
}

class _GrupoChatPageState extends State<GrupoChatPage> {
  List<GrupoChat> _grupos = [];
  bool _loading = true;

  Future<void> _fetchGrupos() async {
    _loading = true;
    if (mounted) setState(() {});

    // try {
    //   final response = await Fetcher.get(url: '/grupos.json');

    //   if (response != null && response.status == 200) {
    //     _grupos = (json.decode(response.body) as List)
    //         .map<GrupoChat>((grupo) => GrupoChat.fromJson(grupo))
    //         .toList();
    //   }
    // } catch (e) {
    //   print(e);
    // }

    _grupos = [
      GrupoChat(
        1,
        'VEG',
        '#A3287E',
        'Veganos',
      ),
      GrupoChat(
        2,
        'ASA',
        '#36A328',
        'Asadores',
      ),
    ];

    _loading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchGrupos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos de chat'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _loading
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  ),
                ),
              )
            : _grupos.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        'No hay grupos aún',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ListView(
                      children: _grupos
                          .map(
                            (grupo) => ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: grupo.toColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    grupo.simbolo.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(grupo.nombre),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => GrupoChatShowPage(
                                      grupo: grupo,
                                    ),
                                    settings: RouteSettings(
                                      name: 'GrupoChatShowPage#${grupo.id}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
      ),
    );
  }
}
