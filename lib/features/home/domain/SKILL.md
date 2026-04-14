# home/domain/
## entities/
banner_entity.dart   — id, imageUrl, deepLink?, title, displayOrder
service_entity.dart  — id, name, iconUrl, serviceType(enum), routePath
home_feed_entity.dart — banners, featuredRestaurants
## usecases/
get_banners_usecase.dart    — call() → List<BannerEntity>
get_home_feed_usecase.dart  — call({lat, lng}) → HomeFeedEntity
