import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/services/deferred_executor.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeferredExecutorTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: kBottomNavigationBarHeight * 1.25,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: kToolbarHeight * 1.25,
        decoration: BoxDecoration(
          color: Provider.of<ContentPageState>(context)
                      .deferredExecutorStatus ==
                  DeferredExecutorStatus.executing
              ? Colors.blueGrey[800]
              : Provider.of<ContentPageState>(context).deferredExecutorStatus ==
                      DeferredExecutorStatus.failed
                  ? Colors.red
                  : Theme.of(context).accentColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (Provider.of<ContentPageState>(context)
                      .deferredExecutorStatus ==
                  DeferredExecutorStatus.executing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Se está ejecutando la operación.'),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                )
              else if (Provider.of<ContentPageState>(context)
                      .deferredExecutorStatus ==
                  DeferredExecutorStatus.failed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'La operación falló.',
                      ),
                    ),
                    SizedBox(width: 15),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: DeferredExecutor.reExecuteLastFuture,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh),
                              Text(
                                'Reintentar',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: DeferredExecutor.cancelExecution,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.close),
                              Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'La operación se ejecutó con éxito.',
                      ),
                    ),
                    SizedBox(width: 15),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            final id = DeferredExecutor.lastItemId;
                            final type = DeferredExecutor.lastItemSectionType;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ShowPage(
                                  contentId: id,
                                  type: type,
                                ),
                              ),
                            );
                            DeferredExecutor.cancelExecution();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_right_alt),
                              Text(
                                'Ver item',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: DeferredExecutor.cancelExecution,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.close),
                              Text(
                                'Cerrar',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
