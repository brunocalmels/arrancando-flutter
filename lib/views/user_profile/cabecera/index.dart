import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_avatar_bubble.dart';
import 'package:arrancando/views/user_profile/cabecera/_imagen_cabecera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabeceraUserProfile extends StatelessWidget {
  final Usuario user;
  final String master;
  final int siguiendo;
  final Function seguir;
  final bool sentSeguir;
  final Map<String, String> _masterToAsset = {
    'horno': 'assets/images/user_profile/masters/horno.png',
    'olla': 'assets/images/user_profile/masters/olla.png',
    'parrilla': 'assets/images/user_profile/masters/parrilla.png',
    'plancha': 'assets/images/user_profile/masters/plancha.png',
    'sartén': 'assets/images/user_profile/masters/sarten.png',
    'wok': 'assets/images/user_profile/masters/wok.png',
    'asador': 'assets/images/user_profile/masters/asador.png',
    'disco': 'assets/images/user_profile/masters/disco.png',
    'tragos y bebidas': 'assets/images/user_profile/masters/tragos.png',
    'bowl': 'assets/images/user_profile/masters/bowl.png',
    'wiki': 'assets/images/user_profile/masters/wiki.png',
  };

  CabeceraUserProfile({
    @required this.user,
    @required this.master,
    @required this.siguiendo,
    @required this.seguir,
    @required this.sentSeguir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.75,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ImageUserProfile(
              src: AssetImage(
                master != null && _masterToAsset[master] != null
                    ? _masterToAsset[master]
                    : 'assets/images/user_profile/masters/wok.png',
              ),
              label: 'Master${master != null ? ' $master' : ''}',
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
              ),
              AvatarBubble(
                user: user,
                isLink: false,
                showAvatar: true,
              ),
              SizedBox(height: 7),
              if (Provider.of<UserState>(context, listen: false)
                      .activeUser
                      .id !=
                  user.id)
                ButtonTheme(
                  minWidth: 120,
                  child: RaisedButton(
                    color: Color(0x99161a25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: sentSeguir
                        ? SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          )
                        : Text(
                            siguiendo == null ? 'SEGUIR' : 'DEJAR DE SEGUIR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                    onPressed: sentSeguir
                        ? null
                        : () {
                            if (siguiendo == null) {
                              seguir();
                            } else {
                              seguir(
                                noSeguir: true,
                              );
                            }
                          },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
