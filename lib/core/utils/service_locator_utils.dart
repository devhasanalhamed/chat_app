import 'package:chat_app/core/services/alert_service.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/media_service.dart';
import 'package:chat_app/core/services/navigation_service.dart';
import 'package:chat_app/core/services/storage_service.dart';
import 'package:get_it/get_it.dart';

Future<void> registerServices() async {
  // get to make the assign the auth class among all application part
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<AlertService>(
    AlertService(),
  );
  getIt.registerSingleton<MediaService>(
    MediaService(),
  );
  getIt.registerSingleton<StorageService>(
    StorageService(),
  );
}
