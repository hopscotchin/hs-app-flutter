import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final sl = GetIt.instance;

//dart run build_runner build -d

@InjectableInit()
Future<void> configureDependencies() => Future.sync(sl.init);
