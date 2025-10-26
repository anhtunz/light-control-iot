import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smt_project/product/extension/context_extension.dart';

import '../../product/constants/enums/app_route_enums.dart';
import 'setting_bloc.dart';
import '../../product/base/bloc/base_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SettingBloc settingBloc;
  // final LocalNotifications localNotifications = LocalNotifications();
  @override
  void initState() {
    super.initState();
    settingBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      settingsComponent(
                        leadingIcon: Icons.wifi_find,
                        componentName: "Cấu hình tự động",
                      ),
                      SizedBox(height: context.lowValue),
                      settingsComponent(
                        leadingIcon: Icons.back_hand_outlined,
                        componentName: "Cấu hình thủ công",
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      // TextButton(
                      //     onPressed: () {
                      //       localNotifications.sendSimpleNotification(
                      //           "title", "body");
                      //     },
                      //     child: Text("Test"))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsComponent(
      {required IconData leadingIcon, required String componentName}) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: context.dynamicWidth(1.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        onTap: () {
          if (leadingIcon == Icons.swap_horiz_sharp) {
          } else if (leadingIcon == Icons.edit_document) {
            // context.pushNamed(AppRoutes.CHANGEGATE.name);
          } else if (leadingIcon == Icons.wifi_find) {
            context.pushNamed(AppRoutes.SMARTCONFIG.name);
          } else if (leadingIcon == Icons.back_hand_outlined) {
            context.pushNamed(AppRoutes.MANUALCONFIG.name);
          }
        },
        leading: Icon(leadingIcon),
        title: Text(
          componentName,
          style: context.responsiveBodyLargeWithBold,
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
