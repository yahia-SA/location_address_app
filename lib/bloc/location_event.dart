abstract class LocationEvent {}

class GetCurrentLocationEvent extends LocationEvent {}

class GetAddressFromCoordinatesEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  GetAddressFromCoordinatesEvent(this.latitude, this.longitude);
}

class GetAddressFromGoogleMapsLinkEvent extends LocationEvent {
  final String googleMapsLink;

  GetAddressFromGoogleMapsLinkEvent(this.googleMapsLink);
}
