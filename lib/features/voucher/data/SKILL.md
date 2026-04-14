# voucher/data/
## models/
voucher_model.dart — extends VoucherEntity + fromJson/toJson
## datasources/
voucher_remote_datasource.dart — GET /vouchers, POST /vouchers/apply
voucher_local_datasource.dart  — Hive voucherBox cache with TTL check
## repositories/
voucher_repository_impl.dart — try remote, fallback to cache on error
