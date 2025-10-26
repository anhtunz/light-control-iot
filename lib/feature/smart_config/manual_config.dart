import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smt_project/feature/setting/setting_bloc.dart';
import 'package:smt_project/feature/smart_config/wifi_list.dart';
import 'package:smt_project/product/base/bloc/base_bloc.dart';
import 'package:smt_project/product/shared/shared_snack_bar.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

class ManualConfig extends StatefulWidget {
  const ManualConfig({super.key});

  @override
  State<ManualConfig> createState() => _ManualConfigState();
}

class _ManualConfigState extends State<ManualConfig> {
  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SettingBloc settingBloc;
  WiFiAccessPoint? selectedWifi;
  String? statusMessage;
  @override
  void initState() {
    super.initState();
    settingBloc = BlocProvider.of(context);
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
      Permission.location,
    ].request();
  }

  Future<void> openWifiList() async {
    final result = await showWifiList(context);
    setState(() {
      if (result != null) {
        selectedWifi = result;
        ssidController.text = result.ssid.isEmpty ? '' : result.ssid;
        statusMessage =
            "Đã chọn Wi-Fi: ${result.ssid.isEmpty ? 'Ẩn SSID' : result.ssid}";
      } else {
        statusMessage = "Không có Wi-Fi nào được chọn.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cấu hình thủ công")),
      body: StreamBuilder(
          stream: settingBloc.streamConfigData,
          builder: (context, configModelSnapshot) {
            final data = configModelSnapshot.data;
            if (data == null) {
              settingBloc.initialConfig();
              return SizedBox.shrink();
            } else {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          label: const Text("SSID (Tên Wifi)"),
                          suffixIcon: IconButton(
                            onPressed: openWifiList,
                            icon: const Icon(Icons.list),
                          ),
                        ),
                        controller: ssidController,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          label: const Text("Mật khẩu"),
                          suffixIcon: IconButton(
                            onPressed: () {
                              settingBloc.updateConfig(
                                  isShowPassword: !data.isShowPassword);
                            },
                            icon: Icon(data.isShowPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        controller: passwordController,
                        obscureText: data.isShowPassword ? false : true,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            connectToWifi, // Disable button when provisioning
                        child: const Text("Kết nối"),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Future<void> connectToWifi() async {
    try {
      if (ssidController.text == "") {
        showErrorTopSnackBarCustom(context, "Tên Wifi không được để trống");
        return;
      }
      await WiFiForIoTPlugin.connect(ssidController.text,
          password: passwordController.text, security: NetworkSecurity.WPA);
      log('Đã kết nối thành công tới ${ssidController.text}');
      
    } catch (e) {
      log('Không thể kết nối tới Wi-Fi: $e');
      showErrorTopSnackBarCustom(context, "Mật khẩu không hợp lệ");
    }
  }

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
