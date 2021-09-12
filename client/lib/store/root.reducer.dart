import 'package:conavigator/domain/location/location.reducer.dart';
import 'package:conavigator/store/app.state.dart';

AppState rootReducer(AppState state, action) {
  return AppState(location: locationReducer(state.location, action));
}
