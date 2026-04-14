# ride/data/
## models/
ride_estimate_model.dart, ride_order_model.dart, driver_model.dart
  All extend domain entity + fromJson/toJson
## datasources/
ride_remote_datasource.dart
  getEstimates(pickup, dest)       → POST /ride/estimate
  bookRide(params)                 → POST /ride/book
  cancelRide(orderId, reason?)     → POST /ride/orders/{id}/cancel
  getRideDetail(orderId)           → GET  /ride/orders/{id}
  getRideHistory(page)             → GET  /ride/history
## repositories/
ride_repository_impl.dart — inject remote datasource, map all exceptions to failures
