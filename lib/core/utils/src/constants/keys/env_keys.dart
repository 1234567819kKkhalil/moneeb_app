import 'package:envied/envied.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

part 'env_keys.g.dart';

@Envied(path: 'env/.env.prod', name: 'ProductionEnv')
@Envied(path: 'env/.env.debug', name: 'DebugEnv')
class Env {
  factory Env() => _instance;

  static final Env _instance = _ProductionEnv();

  /* static Env _instance = switch (Constants.isProduction) {
    true => _ProductionEnv(),
    false => _DebugEnv(),
  };*/

  // static void refreshInstance(){
  //   _instance = switch(Constants.isProduction) {
  //     true => _ProductionEnv(),
  //     false => _DebugEnv(),
  //   };
  // }

  @EnviedField(varName: 'endpoint', obfuscate: true)
  final String endpoint = _instance.endpoint;

  @EnviedField(varName: 'baseUrl', obfuscate: true)
  final String baseUrl = _instance.baseUrl;

  @EnviedField(varName: 'ENCRYPTION_KEY', obfuscate: true)
  final String ENCRYPTION_KEY = _instance.ENCRYPTION_KEY;

  @EnviedField(varName: 'ENCRYPTION_IV', obfuscate: true)
  final String ENCRYPTION_IV = _instance.ENCRYPTION_IV;
}