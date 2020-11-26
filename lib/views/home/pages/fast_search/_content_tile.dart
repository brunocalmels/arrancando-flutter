import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ContentTile extends StatelessWidget {
  final ContentWrapper content;
  final SectionType type;

  ContentTile({
    @required this.content,
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print(
            '${type.toString().split('.').last[0].toLowerCase()}${type.toString().split('.').last.substring(1)}#${content.id}');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShowPage(
              contentId: content.id,
              type: type,
            ),
            settings: RouteSettings(
              name:
                  '${type.toString().split('.').last[0].toLowerCase()}${type.toString().split('.').last.substring(1)}#${content.id}',
            ),
          ),
        );
      },
      trailing: Container(
        width: 40,
        child: content == null || content.thumbnail == null
            ? Center(
                child: Icon(
                  Icons.photo_camera,
                  color: Color(0x33000000),
                ),
              )
            : CachedNetworkImage(
                imageUrl: '${MyGlobals.SERVER_URL}${content.thumbnail}',
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
      ),
      title: Text(content.titulo),
    );
  }
}
