class LocalStorageService {
  static final LocalStorageService _instance =
      LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  // Later you can add SharedPreferences / Hive here
}
