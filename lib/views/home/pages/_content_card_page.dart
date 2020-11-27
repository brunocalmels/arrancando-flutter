import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/cards/card_content.dart';
import 'package:arrancando/views/home/filter_bottom_sheet/index.dart';
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
  final bool hideFilter;

  ContentCardPage({
    @required this.type,
    @required this.fetching,
    @required this.noMore,
    @required this.resetLimit,
    @required this.fetchContent,
    @required this.increasePage,
    @required this.items,
    this.hideFilter = false,
  });

  @override
  _ContentCardPageState createState() => _ContentCardPageState();
}

class _ContentCardPageState extends State<ContentCardPage> {
  final ScrollController _scrollController = ScrollController();

  Widget get _plato => GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: MyGlobals.mainScaffoldKey.currentContext,
            builder: (_) => FilterBottomSheet(
              fetchContent: () {
                widget.resetLimit();
                widget.fetchContent(context.read<MainState>().activePageHome);
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          );
        },
        child: Image.asset(
          'assets/images/content/index/plato-filtrar.png',
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      );

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentPageState>().setContentSortType(
            context.read<ContentPageState>().sortContentBy ??
                ContentSortType.fecha_creacion,
          );
      widget.resetLimit();
      widget.fetchContent(widget.type);
      _scrollController.addListener(
        () {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange &&
              !widget.noMore) {
            if (widget.increasePage != null) widget.increasePage();
            if (widget.fetchContent != null) widget.fetchContent(widget.type);
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
                ? widget.items.isNotEmpty
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
                          if (index == 0 && !widget.hideFilter) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _plato,
                                SizedBox(
                                  height: 15,
                                ),
                                item,
                              ],
                            );
                          }
                          if (index == widget.items.length - 1) {
                            if (!widget.noMore && widget.items.length > 1) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  item,
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
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
                            }
                          } else {
                            return item;
                          }
                        },
                      )
                    : ListView(
                        children: [
                          if (!widget.hideFilter)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _plato,
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'No hay elementos para mostrar',
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
                          'Ocurrió un error',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        '(Si el problema persiste, cerrá sesión y volvé a iniciar)',
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
