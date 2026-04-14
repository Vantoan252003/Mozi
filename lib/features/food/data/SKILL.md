# food/data/
## models/
restaurant_model.dart, menu_item_model.dart, menu_option_group_model.dart,
food_order_model.dart, shipper_model.dart, cart_item_model.dart (Hive @HiveType)
cart_item_model.dart must have @HiveType/@HiveField for Hive persistence
## datasources/
food_remote_datasource.dart — all REST calls (see ApiConstants food section)
food_local_datasource.dart  — Hive cartBox read/write/clear for cart persistence
## repositories/
food_repository_impl.dart
