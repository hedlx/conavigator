import 'package:conavigator/app.dart';
import 'package:conavigator/store/app.state.dart';
import 'package:conavigator/store/root.reducer.dart';
import 'package:conavigator/store/root.saga.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_saga/redux_saga.dart';

void main() {
  final sagaMiddleware = createSagaMiddleware();
  final store = Store<AppState>(rootReducer,
      initialState: initAppState,
      middleware: [applyMiddleware(sagaMiddleware)]);

  sagaMiddleware.setStore(store);
  sagaMiddleware.run(rootSaga);

  runApp(App(store: store));
}
