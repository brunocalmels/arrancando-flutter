import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/models/chat/mensaje.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/views/chat/grupo/show/mensajes_list/_complex_mensaje.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MensajesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<MensajeChat> mensajes;
  final GrupoChat grupo;
  final bool scrollOnNew;
  final bool sending;
  final Function scrollToBottom;
  final ActiveUser activeUser;

  const MensajesList({
    Key key,
    @required this.scrollController,
    @required this.mensajes,
    @required this.grupo,
    @required this.scrollOnNew,
    @required this.sending,
    @required this.scrollToBottom,
    @required this.activeUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              controller: scrollController,
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                final mensaje = mensajes[index];

                if (mensaje.type != null &&
                    mensaje.type == 'Mensaje grupal' &&
                    mensaje.mensaje != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withAlpha(10),
                        ),
                        child: Text(
                          mensaje.mensaje,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final activeUserId = activeUser.id;
                final isMine = mensaje.usuario.id == activeUserId;

                final avatar = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: mensaje?.usuario?.avatar != null
                        ? CachedNetworkImageProvider(
                            mensaje.usuario.avatar.contains('http')
                                ? '${mensaje?.usuario?.avatar}'
                                : '${MyGlobals.SERVER_URL}${mensaje?.usuario?.avatar}',
                          )
                        : null,
                  ),
                );

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isMine) avatar,
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: grupo.toColor.withAlpha(100),
                                borderRadius: BorderRadius.only(
                                  topRight: isMine
                                      ? Radius.zero
                                      : Radius.circular(10),
                                  topLeft: isMine
                                      ? Radius.circular(10)
                                      : Radius.zero,
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '@${mensaje.usuario.username}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color
                                          .withAlpha(185),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ComplexMensaje(
                                    texto: mensaje.mensaje,
                                    fontSize: 13,
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    Utils.formatDate(mensaje.createdAt),
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color
                                          .withAlpha(150),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isMine) avatar,
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutBack,
              opacity: !scrollOnNew && !sending ? 1 : 0,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                elevation: 6,
                type: MaterialType.circle,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Icon(Icons.arrow_downward),
                  ),
                  onTap: () => !scrollOnNew && !sending
                      ? scrollToBottom(force: true)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
