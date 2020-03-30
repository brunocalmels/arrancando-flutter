import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/views/cards/card_content.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentCardPage extends StatefulWidget {
  final SectionType type;
  final bool fetching;
  final bool noMore;
  final Function resetLimit;
  final Function(SectionType) fetchContent;
  final Function increasePage;
  final List<ContentWrapper> items;

  ContentCardPage({
    @required this.type,
    @required this.fetching,
    @required this.noMore,
    @required this.resetLimit,
    @required this.fetchContent,
    @required this.increasePage,
    @required this.items,
  });

  @override
  _ContentCardPageState createState() => _ContentCardPageState();
}

class _ContentCardPageState extends State<ContentCardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContentPageState>(context)
          .setContentSortType(ContentSortType.fecha);
      widget.resetLimit();
      widget.fetchContent(widget.type);
      _scrollController.addListener(
        () {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange &&
              !widget.noMore) {
            widget.increasePage();
            widget.fetchContent(widget.type);
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.fetching
        ? LoadingWidget()
        : RefreshIndicator(
            onRefresh: () {
              widget.resetLimit();
              return widget.fetchContent(widget.type);
            },
            child: widget.items != null
                ? widget.items.length > 0
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          Widget item = Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CardContent(
                              content: widget.items[index],
                            ),
                          );
                          if (index == 0)
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    print("TAP");
                                  },
                                  child: Image.asset(
                                    "assets/images/plato-filtrar.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                item,
                              ],
                            );
                          if (index == widget.items.length - 1) {
                            if (!widget.noMore)
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  item,
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.37,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            else
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  item,
                                  Container(
                                    height: 100,
                                    color: Color(0x05000000),
                                  ),
                                ],
                              );
                          } else
                            return item;
                        },
                      )
                    : ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "No hay elementos para mostrar",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Ocurrió un error",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "(Si el problema persiste, cerrá sesión y volvé a iniciar)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
          );
  }
}
