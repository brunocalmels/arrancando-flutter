import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GrillaContentUserProfile extends StatelessWidget {
  final SectionType type;
  final List<ContentWrapper> items;
  final Function fetchMore;
  final bool sentMore;
  final bool noMore;

  GrillaContentUserProfile({
    @required this.type,
    @required this.items,
    @required this.fetchMore,
    @required this.sentMore,
    @required this.noMore,
  });

  Widget _buildImage(String src, int contentId, BuildContext context) => Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
            child: src == null
                ? Container(
                    color: Color(0x33999999),
                    child: Center(
                      child: Icon(
                        Icons.photo_camera,
                        size: 50,
                        color: Color(0x33000000),
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        '${src.contains('http') ? '' : MyGlobals.SERVER_URL}$src',
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.photo_camera,
                      size: 50,
                      color: Color(0x33000000),
                    ),
                  ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ShowPage(
                        contentId: contentId,
                        type: type,
                      ),
                      settings: RouteSettings(
                        name:
                            '${type.toString().split('.').last[0].toLowerCase()}${type.toString().split('.').last.substring(1)}#$contentId',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: MediaQuery.of(context).size.width * 0.01,
            runSpacing: MediaQuery.of(context).size.width * 0.01,
            children: items
                .map(
                  (i) => _buildImage(
                    i.thumbnail,
                    i.id,
                    context,
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 5),
          if (!noMore)
            FlatButton(
              child: sentMore
                  ? SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    )
                  : Text(
                      'Cargar más',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
              onPressed: sentMore ? null : fetchMore,
            ),
        ],
      ),
    );
  }
}
