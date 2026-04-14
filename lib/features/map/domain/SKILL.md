# map/domain/
## entities/
place_entity.dart            — placeId, name, address, lat, lng, types[]
place_prediction_entity.dart — placeId, description, mainText, secondaryText
route_entity.dart            — polylineEncoded, distanceMeters, durationSeconds, steps[]
route_step_entity.dart       — instruction, distanceMeters, durationSeconds
## repositories/
map_repository.dart — 5 abstract methods (see feature root SKILL.md)
## usecases/
search_places_usecase.dart        — call(query, token, {lat, lng})
get_place_detail_usecase.dart     — call(placeId, token)
get_current_location_usecase.dart — call() → LocationEntity via LocationService
get_route_usecase.dart            — call({origin, destination})
reverse_geocode_usecase.dart      — call(lat, lng) → PlaceEntity
