import 'package:conavigator/domain/location/location.reducer.dart';
import 'package:conavigator/domain/location/location.saga.dart';
import 'package:redux_saga/redux_saga.dart';

rootSaga() sync* {
  yield Call(initLocationSaga);
}
