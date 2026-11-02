sealed class LocationEvent {
  const LocationEvent();
}

class LocationInitialEvent extends LocationEvent {
  const LocationInitialEvent();
}

class LocationRequestingEvent extends LocationEvent {
  const LocationRequestingEvent();
}

class LocationRequested extends LocationEvent {
  const LocationRequested();
}