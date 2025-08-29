import 'package:you_owe_us/services/base_web_service.dart';

import '../di.dart';

class BaseService {
  BaseService([BaseWebService? web]) : webService = web ?? c<BaseWebService>();
  late final BaseWebService webService;
}
