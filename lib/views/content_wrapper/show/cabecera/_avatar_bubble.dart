import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/views/general/curved_text.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class AvatarBubble extends StatelessWidget {
  final Usuario user;
  final bool isLink;

  AvatarBubble({
    @required this.user,
    this.isLink = true,
  });

  double _calculateCurveAngle() {
    if (user != null && user.username != null) {
      return degToRadian(
          ((user.username.length >= 4 ? -6 : -8) * user.username.length)
              .toDouble());
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          if (user != null && user.username != null)
            Positioned.fill(
              child: CurvedText(
                radius: 40,
                text: "@${user.username}",
                textStyle: TextStyle(),
                startAngle: _calculateCurveAngle(),
              ),
            ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLink
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserProfilePage(
                            user: user,
                          ),
                          settings: RouteSettings(
                            name: "UserProfilePage",
                          ),
                        ),
                      );
                    }
                  : null,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: user != null && user.avatar != null
                    ? CachedNetworkImageProvider(
                        "${MyGlobals.SERVER_URL}${user.avatar}",
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
