# profile/data/
## models/
profile_model.dart, saved_address_model.dart (@HiveType for addressBox)
## datasources/
profile_remote_datasource.dart — GET/PUT /users/me, PUT /users/me/avatar (multipart), addresses CRUD
profile_local_datasource.dart  — Hive userBox (profile cache), Hive addressBox
## repositories/
profile_repository_impl.dart
