import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smt_project/feature/home/home_bloc.dart';
import 'package:smt_project/feature/home/home_screen.dart';
import '../../product/base/bloc/base_bloc.dart';
import '../../product/constants/enums/app_theme_enums.dart';
import '../../product/constants/icon/icon_constants.dart';
import '../../product/lang/language_constants.dart';
import '../../product/services/api_services.dart';
import '../setting/setting_bloc.dart';
import '../setting/setting_screen.dart';
import 'main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainBloc mainBloc;
  bool isVN = true;
  bool isLight = true;
  APIServices apiServices = APIServices();
  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: IconConstants.instance.getMaterialIcon(Icons.group),
        title: "Trang chủ",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon:
            IconConstants.instance.getMaterialIcon(Icons.group_outlined),
      ),
      // PersistentBottomNavBarItem(
      //   icon: IconConstants.instance.getMaterialIcon(Icons.water_drop_sharp),
      //   title: "Máy bơm",
      //   activeColorPrimary: Colors.blue,
      //   inactiveColorPrimary: Colors.grey,
      //   inactiveIcon:
      //       IconConstants.instance.getMaterialIcon(Icons.water_drop_outlined),
      // ),
      // PersistentBottomNavBarItem(
      //   icon: IconConstants.instance.getMaterialIcon(Icons.curtains_closed),
      //   title: "Rèm cửa",
      //   activeColorPrimary: Colors.blue,
      //   inactiveColorPrimary: Colors.grey,
      //   inactiveIcon: IconConstants.instance
      //       .getMaterialIcon(Icons.curtains_closed_outlined),
      // ),
      // PersistentBottomNavBarItem(
      //   icon: IconConstants.instance.getMaterialIcon(Icons.sensor_door),
      //   title: "Cổng",
      //   activeColorPrimary: Colors.blue,
      //   inactiveColorPrimary: Colors.grey,
      //   inactiveIcon:
      //       IconConstants.instance.getMaterialIcon(Icons.sensor_door_outlined),
      // ),
      // PersistentBottomNavBarItem(
      //   icon: IconConstants.instance.getMaterialIcon(Icons.wind_power_rounded),
      //   title: "Quạt",
      //   activeColorPrimary: Colors.blue,
      //   inactiveColorPrimary: Colors.grey,
      //   inactiveIcon:
      //   IconConstants.instance.getMaterialIcon(Icons.wind_power_outlined),
      // ),
      PersistentBottomNavBarItem(
        icon: IconConstants.instance.getMaterialIcon(Icons.settings),
        title: "Cài đặt",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon:
            IconConstants.instance.getMaterialIcon(Icons.settings_outlined),
      ),
      // PersistentBottomNavBarItem(
      //   icon: IconConstants.instance.getMaterialIcon(Icons.wifi_find),
      //   title: "SmartConfig",
      //   activeColorPrimary: Colors.blue,
      //   inactiveColorPrimary: Colors.grey,
      //   inactiveIcon:
      //       IconConstants.instance.getMaterialIcon(Icons.wifi_find_outlined),
      // ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        child:
            const HomeScreen(deviceIp: "192.168.4.1"), // Default IP for testing
        blocBuilder: () => HomeBloc(),
      ),
      // DemoScreen(url: "https://smtvietnam.net/"),
      // BlocProvider(
      //   child: const PumpScreen(),
      //   blocBuilder: () => PumpBloc(),
      // ),
      // BlocProvider(
      //   child: const CurtainScreen(),
      //   blocBuilder: () => CurtainBLoc(),
      // ),
      // BlocProvider(
      //   child: const GateScreen(),
      //   blocBuilder: () => GateBloc(),
      // ),
      // BlocProvider(
      //   child: const FanScreen(),
      //   blocBuilder: () => FanBloc(),
      // ),
      BlocProvider(
        child: const SettingScreen(),
        blocBuilder: () => SettingBloc(),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    mainBloc = BlocProvider.of(context);
    initialCheck();
    // LocalNotifications.requestNotificationPermission();
  }

  void initialCheck() async {
    String language = await apiServices.checkLanguage();
    String theme = await apiServices.checkTheme();
    if (language == LanguageConstants.VIETNAM) {
      isVN = true;
    } else {
      isVN = false;
    }
    if (theme == AppThemes.LIGHT.name) {
      isLight = true;
    } else if (theme == AppThemes.DARK.name) {
      isLight = false;
    } else {
      isLight = true;
    }
    mainBloc.sinkIsVNIcon.add(isVN);
    mainBloc.sinkThemeMode.add(isLight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   actions: [
      //     StreamBuilder<bool>(
      //         initialData: isLight,
      //         stream: mainBloc.streamThemeMode,
      //         builder: (context, themeModeSnapshot) {
      //           return IconButton(
      //             onPressed: () async {
      //               ThemeData newTheme = await ThemeServices().changeTheme(
      //                   isLight ? AppThemes.DARK.name : AppThemes.LIGHT.name);
      //               MyApp.setTheme(context, newTheme);
      //               isLight = !isLight;
      //               mainBloc.sinkThemeMode.add(isLight);
      //             },
      //             icon: Icon(
      //               themeModeSnapshot.data ?? isLight
      //                   ? Icons.light_mode_outlined
      //                   : Icons.dark_mode_outlined,
      //             ),
      //           );
      //         }),
      //     StreamBuilder<bool>(
      //       stream: mainBloc.streamIsVNIcon,
      //       initialData: isVN,
      //       builder: (context, isVnSnapshot) {
      //         return IconButton(
      //           onPressed: () async {
      //             Locale locale = await LanguageServices().setLocale(isVN
      //                 ? LanguageConstants.ENGLISH
      //                 : LanguageConstants.VIETNAM);
      //             MyApp.setLocale(context, locale);
      //             isVN = !isVN;
      //             mainBloc.sinkIsVNIcon.add(isVN);
      //           },
      //           icon: Image.asset(
      //             IconConstants.instance.getIcon(
      //                 isVnSnapshot.data ?? isVN ? 'vi_icon' : 'en_icon'),
      //             height: 24,
      //             width: 24,
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: PersistentTabView(
        context,
        controller: persistentTabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        // stateManagement: false,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 200),
          ),
        ),
        navBarStyle: NavBarStyle.style3,
      ),
    );
  }
}
