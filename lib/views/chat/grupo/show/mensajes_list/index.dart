import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/models/chat/mensaje.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MensajesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<MensajeChat> mensajes;
  final GrupoChat grupo;
  final bool scrollOnNew;
  final bool sending;
  final Function scrollToBottom;

  const MensajesList({
    Key key,
    @required this.scrollController,
    @required this.mensajes,
    @required this.grupo,
    @required this.scrollOnNew,
    @required this.sending,
    @required this.scrollToBottom,
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
                final activeUserId = context.read<UserState>().activeUser.id;
                final isMine = mensajes[index].usuario.id == activeUserId;

                final avatar = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: mensajes[index]?.usuario?.avatar != null
                        ? CachedNetworkImageProvider(
                            mensajes[index].usuario.avatar.contains('http')
                                ? '${mensajes[index]?.usuario?.avatar}'
                                : '${MyGlobals.SERVER_URL}${mensajes[index]?.usuario?.avatar}',
                          )
                        : null,
                  ),
                );

                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
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
                            color: grupo.toColor,
                            borderRadius: BorderRadius.only(
                              topRight:
                                  isMine ? Radius.zero : Radius.circular(10),
                              topLeft:
                                  isMine ? Radius.circular(10) : Radius.zero,
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '@${mensajes[index].usuario.username}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withAlpha(185),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                mensajes[index].mensaje,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isMine) avatar,
                      ],
                    ),
                  ),
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
