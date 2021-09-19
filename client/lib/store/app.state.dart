import 'package:conavigator/domain/location/location.reducer.dart';
import 'package:conavigator/osmxml.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:meta/meta.dart';
part 'app.state.g.dart';

@immutable
@CopyWith()
class AppState {
  final LocationState location;

  const AppState({required this.location});
}

final initAppState = AppState(location: initLocationState);
