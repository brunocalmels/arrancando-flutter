import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormSendComment extends StatelessWidget {
  final TextEditingController mensajeController;
  final bool sent;
  final Function sendComentario;

  FormSendComment({
    @required this.mensajeController,
    @required this.sent,
    @required this.sendComentario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff161a25),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundImage: context.select<UserState, ActiveUser>(
                            (value) => value.activeUser) !=
                        null &&
                    context
                            .select<UserState, ActiveUser>(
                                (value) => value.activeUser)
                            .avatar !=
                        null
                ? CachedNetworkImageProvider(
                    '${MyGlobals.SERVER_URL}${context.select<UserState, ActiveUser>((value) => value.activeUser).avatar}',
                  )
                : null,
          ),
          SizedBox(
            width: 7,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 2,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Comentario',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      controller: mensajeController,
                    ),
                  ),
                  FlatButton(
                    onPressed: sent ? null : sendComentario,
                    child: Text(
                      'COMENTAR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
