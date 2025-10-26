import 'package:go_router/go_router.dart';
import 'package:smt_project/feature/auto_config/auto_config_bloc.dart';
import 'package:smt_project/feature/auto_config/auto_config_screeen.dart';
import 'package:smt_project/feature/home/home_bloc.dart';
import 'package:smt_project/feature/home/home_screen.dart';
import 'package:smt_project/feature/smart_config/manual_config.dart';
import 'package:smt_project/feature/smart_config/smart_config.dart';

import '../../feature/login/login_bloc.dart';
import '../../feature/login/login_screen.dart';
import '../../feature/main/main_bloc.dart';
import '../../feature/main/main_screen.dart';
import '../../feature/setting/setting_bloc.dart';
import '../../feature/setting/setting_screen.dart';
import '../base/bloc/base_bloc.dart';
import '../constants/enums/app_route_enums.dart';
import '../constants/navigation/navigation_constants.dart';
import '../shared/shared_transistion.dart';

GoRouter goRouter() {
  return GoRouter(
    debugLogDiagnostics: true,
    // errorBuilder: (context, state) => const NotFoundScreen(),
    initialLocation: NavigationConstants.WELCOME_PATH,
    routes: <RouteBase>[
      GoRoute(
        path: NavigationConstants.LOGIN_PATH,
        name: AppRoutes.LOGIN.name,
        builder: (context, state) => BlocProvider(
          child: const LoginScreen(),
          blocBuilder: () => LoginBloc(),
        ),
      ),
      GoRoute(
        path: NavigationConstants.WELCOME_PATH,
        name: AppRoutes.WELCOME.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            child: const AutoConfigScreeen(),
            blocBuilder: () => AutoConfigBloc(),
          ),
          transitionsBuilder: transitionsCustom1,
        ),
      ),
      GoRoute(
        path: NavigationConstants.MAIN_PATH,
        name: AppRoutes.MAIN.name,
        builder: (context, state) => BlocProvider(
          child: const MainScreen(),
          blocBuilder: () => MainBloc(),
        ),
      ),
      GoRoute(
        path: '${NavigationConstants.HOME_PATH}/:deviceIp',
        name: AppRoutes.HOME.name,
        builder: (context, state) => BlocProvider(
          child: HomeScreen(deviceIp: state.pathParameters['deviceIp']!),
          blocBuilder: () => HomeBloc(),
        ),
      ),
      GoRoute(
        path: NavigationConstants.SETTING_PATH,
        name: AppRoutes.SETTING.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            child: const SettingScreen(),
            blocBuilder: () => SettingBloc(),
          ),
          transitionsBuilder: transitionsRightToLeft,
        ),
      ),

      GoRoute(
        path: NavigationConstants.SMART_CONFIG_PATH,
        name: AppRoutes.SMARTCONFIG.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            child: const SmartConfig(),
            blocBuilder: () => SettingBloc(),
          ),
          transitionsBuilder: transitionsCustom1,
        ),
      ),
      GoRoute(
        path: NavigationConstants.MANUAL_CONFIG_PATH,
        name: AppRoutes.MANUALCONFIG.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            child: const ManualConfig(),
            blocBuilder: () => SettingBloc(),
          ),
          transitionsBuilder: transitionsCustom1,
        ),
      ),
      // GoRoute(
      //   path: '${ApplicationConstants.DEVICES_UPDATE_PATH}/:thingID',
      //   name: AppRoutes.DEVICE_UPDATE.name,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //       child: BlocProvider(
      //         child: DeviceUpdateScreen(
      //           thingID: state.pathParameters['thingID']!,
      //         ),
      //         blocBuilder: () => DeviceUpdateBloc(),
      //       ),
      //       transitionsBuilder: transitionsBottomToTop),
      // ),
      // GoRoute(
      //     path: '${ApplicationConstants.GROUP_PATH}/:groupId',
      //     name: AppRoutes.GROUP_DETAIL.name,
      //     pageBuilder: (context, state) {
      //       final groupId = state.pathParameters['groupId']!;
      //       final role = state.extra! as String;
      //       return CustomTransitionPage(
      //           child: BlocProvider(
      //             child: DetailGroupScreen(group: groupId, role: role),
      //             blocBuilder: () => DetailGroupBloc(),
      //           ),
      //           transitionsBuilder: transitionsRightToLeft);
      //     }),
    ],
  );
}
