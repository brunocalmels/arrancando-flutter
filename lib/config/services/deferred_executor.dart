import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:provider/provider.dart';

abstract class DeferredExecutor {
  static SectionType lastItemSectionType;
  static int lastItemId;
  static Future lastFuture;
  static String lastFutureError;

  static void execute(SectionType sectionType, Future future) async {
    final context = MyGlobals.mainNavigatorKey.currentContext;
    final contentPageState = context.read<ContentPageState>();
    contentPageState.setDeferredExecutorStatus(
      DeferredExecutorStatus.executing,
    );

    lastFuture = future;
    lastItemSectionType = sectionType;

    try {
      final response = await future;
      if (response != null &&
          (response.status == 201 || response.status == 200)) {
        final decoded = json.decode(response.body);
        if (decoded['id'] != null) {
          lastItemId = decoded['id'];
        }
        lastFuture = null;
        contentPageState.setDeferredExecutorStatus(
          DeferredExecutorStatus.success,
        );
        return;
      }
      if (response != null && response.body != null) {
        lastFutureError = (json.decode(response.body) as Map)
            .values
            .expand((i) => i)
            .join(',');
      } else {
        lastFutureError =
            'Ocurrió un error, por favor intentalo nuevamente más tarde.';
      }
    } catch (e) {
      print(e);
      lastFutureError =
          'Ocurrió un error, por favor intentalo nuevamente más tarde.';
    }
    contentPageState.setDeferredExecutorStatus(
      DeferredExecutorStatus.failed,
    );
  }

  static void reExecuteLastFuture() {
    execute(lastItemSectionType, lastFuture);
  }

  static void cancelExecution() {
    lastItemId = null;
    lastFuture = null;
    lastFutureError = null;
    final context = MyGlobals.mainNavigatorKey.currentContext;
    final contentPageState = context.read<ContentPageState>();
    contentPageState.setDeferredExecutorStatus(
      DeferredExecutorStatus.none,
    );
  }
}
