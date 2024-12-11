import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  // Get Current Location
  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      bool isPermissionGranted = await requestPermission();
      if (!isPermissionGranted) {
        emit(LocationError('Permission denied'));
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      String address =  getAddressFromCoordinates(
          position.latitude, position.longitude).toString();
      emit(LocationLoaded(address));
    } catch (e) {
      emit(LocationError('Error fetching location: $e'));
    }
  }

  // Get Address from Coordinates
  Future<void> getAddressFromCoordinates(double latitude, double longitude) async {
    emit(LocationLoading());
    try {
      String address = await getAddressFromCoordinatesInternal(latitude, longitude);
      emit(LocationLoaded(address));
    } catch (e) {
      emit(LocationError('Error fetching address: $e'));
    }
  }

  // Get Address from Google Maps Link
  Future<void> getAddressFromGoogleMapsLink(String googleMapsLink) async {
    emit(LocationLoading());
    try {
      Map<String, double> coordinates = await extractCoordinatesFromLink(googleMapsLink);
      String address = await getAddressFromCoordinatesInternal(
          coordinates['latitude']!, coordinates['longitude']!);
      emit(LocationLoaded(address));
    } catch (e) {
      emit(LocationError('Error fetching address: $e'));
    }
  }

  // Request Location Permission
  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }

  // Internal function to fetch address from coordinates
  Future<String> getAddressFromCoordinatesInternal(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark placemark = placemarks[0];
      return '${placemark.name}, ${placemark.locality}, ${placemark.country}';
    } catch (e) {
      throw Exception('Unable to fetch address');
    }
  }

  // Extract Coordinates from Google Maps URL
  Future<Map<String, double>> extractCoordinatesFromLink(String url) async {
    final regex = RegExp(r'@([-\d.]+),([-\d.]+)');
    final match = regex.firstMatch(url);
    if (match != null) {
      double latitude = double.parse(match.group(1)!);
      double longitude = double.parse(match.group(2)!);
      return {'latitude': latitude, 'longitude': longitude};
    } else {
      throw Exception('Invalid Google Maps link');
    }
  }
}
