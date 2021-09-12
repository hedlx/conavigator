import 'package:conavigator/domain/location/location.actions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:latlong2/latlong.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';
part 'location.reducer.g.dart';

final locationReducer =
    combineReducers<LocationState>([TypedReducer(_updateLocation)]);
final initLocationState = LocationState(location: LatLng(0, 0));

@immutable
@CopyWith()
class LocationState {
  final bool isLoading;
  final LatLng location;

  const LocationState({this.isLoading = true, required this.location});
}

LocationState _updateLocation(
    LocationState state, LocationUpdatedAction action) {
  return state.copyWith(isLoading: false, location: action.coords);
}
