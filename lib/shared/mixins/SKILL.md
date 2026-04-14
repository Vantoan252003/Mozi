# shared/mixins/ — StatefulWidget Mixins

## loading_mixin.dart
```
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    if (mounted) setState(() => _isLoading = val);
  }

  Future<void> withLoading(Future<void> Function() fn) async {
    setLoading(true);
    try { await fn(); } finally { setLoading(false); }
  }
}
```

## form_validation_mixin.dart
```
mixin FormValidationMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form == null) return false;
    if (form.validate()) { form.save(); return true; }
    return false;
  }

  void resetForm() => formKey.currentState?.reset();

  String? validatePhone(String? v) => ValidationUtils.validatePhone(v);
  String? validateRequired(String? v, String fieldName) =>
      ValidationUtils.validateRequired(v, fieldName);
  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return null; // optional
    if (!ValidationUtils.isValidEmail(v)) return 'Email không hợp lệ';
    return null;
  }
}
```

## pagination_mixin.dart
```
mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  final scrollController = ScrollController();
  int  _page = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  bool get hasMore    => _hasMore;
  int  get currentPage => _page;

  void initPagination(VoidCallback onLoadMore) {
    scrollController.addListener(() {
      final atBottom = scrollController.position.pixels
          >= scrollController.position.maxScrollExtent - 200;
      if (atBottom && _hasMore && !_isFetching) {
        _isFetching = true;
        onLoadMore();
      }
    });
  }

  void onPageLoaded({required bool hasMore}) {
    if (!mounted) return;
    setState(() { _page++; _hasMore = hasMore; _isFetching = false; });
  }

  void resetPagination() {
    _page = 1; _hasMore = true; _isFetching = false;
  }

  @override
  void dispose() { scrollController.dispose(); super.dispose(); }
}
```

## after_layout_mixin.dart
```
mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);
}
// Usage: override afterFirstLayout to run code after first render
// e.g. to auto-focus TextField, start animation, fetch data after build
```
