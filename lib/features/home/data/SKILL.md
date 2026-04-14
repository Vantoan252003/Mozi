# home/data/
## models/
banner_model.dart, service_model.dart, home_feed_model.dart — fromJson
## datasources/
home_remote_datasource.dart — GET /home/banners, GET /home/services
home_local_datasource.dart  — Hive cache for banners (5 min TTL)
## repositories/
home_repository_impl.dart — remote + local, fallback to cache on network error
