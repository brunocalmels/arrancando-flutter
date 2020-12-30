import 'dart:convert';

import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/chat/grupo/_grupo_tile.dart';
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

    try {
      final response = await Fetcher.get(url: '/grupo_chats.json');

      if (response != null && response.status == 200) {
        _grupos = (json.decode(response.body) as List)
            .map<GrupoChat>((grupo) => GrupoChat.fromJson(grupo))
            .toList();

        _grupos.sort((g1, g2) => g1.nombre.compareTo(g2.nombre));
      }
    } catch (e) {
      print(e);
    }

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
                            (grupo) => GrupoTile(grupo: grupo),
                          )
                          .toList(),
                    ),
                  ),
      ),
    );
  }
}
