import 'dart:async';
import 'dart:developer';

import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smt_project/feature/setting/setting_bloc.dart';
import 'package:smt_project/feature/smart_config/wifi_list.dart';
import 'package:smt_project/product/base/bloc/base_bloc.dart';
import 'package:smt_project/product/shared/shared_snack_bar.dart';
import 'package:wifi_scan/wifi_scan.dart';

class SmartConfig extends StatefulWidget {
  const SmartConfig({super.key});

  @override
  State<SmartConfig> createState() => _SmartConfigState();
}

class _SmartConfigState extends State<SmartConfig> {
  TextEditingController ssidController =
      TextEditingController(text: "SK_WiFiGIGA0E64_2.4G");
  TextEditingController passwordController =
      TextEditingController(text: "1812007053");
  Provisioner? _currentProvisioner;
  WiFiAccessPoint? selectedWifi;
  String? statusMessage;
  late SettingBloc settingBloc;
  // Timer đếm ngược hiển thị cho người dùng
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
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

    if (result != null) {
      selectedWifi = result;
      ssidController.text = result.ssid.isEmpty ? '' : result.ssid;
      settingBloc.setStatusMessage(
          "Đã chọn Wi-Fi: ${result.ssid.isEmpty ? 'Ẩn SSID' : result.ssid}");
    } else {
      statusMessage = "Không có Wi-Fi nào được chọn.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow,
      appBar: AppBar(title: const Text("Cấu hình Wi-Fi tự động")),
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
                        onPressed: () {
                          if (data.isStartProvision) {
                            stopProvisioning();
                          } else {
                            startProvisioning();
                          }
                        }, // Disable button when provisioning
                        child: Text(
                            data.isStartProvision ? "Dừng kết nối" : "Kết nối"),
                      ),
                      // const SizedBox(height: 10),
                      // ElevatedButton(
                      //   onPressed: stopProvisioning,
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.redAccent),
                      //   child: const Text("Dừng kết nối"),
                      // ),
                      const SizedBox(height: 16),
                      // Image.asset(
                      //   IconConstants.instance.getIcon('water_tank'),
                      //   color: Colors.green,
                      // ),
                      if (data.statusMessage != "")
                        Text(
                          statusMessage ?? "",
                          style: TextStyle(
                            color: statusMessage!.contains("Lỗi")
                                ? Colors.red
                                : Colors.green,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
  // String statusMessage = "";

  Future<void> startProvisioning() async {
    // Kiểm tra SSID
    if (ssidController.text.isEmpty) {
      statusMessage = "Vui lòng nhập hoặc chọn SSID.";
      settingBloc.updateConfig(statusMessage: statusMessage);

      // log("${statusMessage}");
      return;
    }

    statusMessage = "Đang kết nối thiết bị với Wi-Fi...";
    settingBloc.updateConfig(
        statusMessage: statusMessage, isStartProvision: true);
    try {
      _currentProvisioner = Provisioner.espTouch();

      // Thiết lập listener cho phản hồi
      _currentProvisioner!.listen(
        (response) {
          statusMessage =
              "Thiết bị ${response.bssidText} đã kết nối Wi-Fi! IP: ${response.ipAddressText}";
          _countdownTimer?.cancel();
          settingBloc.updateConfig(statusMessage: statusMessage);
          log("$statusMessage");
          showSuccessTopSnackBarCustom(context, statusMessage ?? "");
          _currentProvisioner?.stop();
        },
        onError: (error, stackTrace) {
          statusMessage = "Lỗi trong quá trình cấu hình: $error";
          log("$statusMessage");
          log('Stack: $stackTrace');
          _countdownTimer?.cancel();
          _currentProvisioner?.stop();
          settingBloc.updateConfig(
              isStartProvision: false, statusMessage: statusMessage);
        },
        onDone: () {
          log('Provisioner stream closed.');
          _countdownTimer?.cancel();
          final cur = statusMessage ?? "";
          if (cur.contains("Đang kết nối") ||
              cur.contains("Đang chờ") ||
              int.tryParse(cur) != null) {
            statusMessage =
                "Quá trình cấu hình đã dừng hoặc hết thời gian chờ.";
            log("$statusMessage");
            settingBloc.updateConfig(
                isStartProvision: false, statusMessage: statusMessage);
          }
        },
      );

      // Bắt đầu provisioning
      _currentProvisioner!
          .start(
            ProvisioningRequest.fromStrings(
              ssid: ssidController.text,
              bssid: selectedWifi?.bssid ?? '00:00:00:00:00:00',
              password: passwordController.text.isEmpty
                  ? null
                  : passwordController.text,
            ),
          )
          .timeout(const Duration(seconds: 60));

      // Bắt đầu hiển thị đếm ngược 60-59-58-... cho người dùng
      _countdownTimer?.cancel();
      _remainingSeconds = 60;
      statusMessage = "Đang chờ thiết bị phản hồi ${_remainingSeconds.toString()}";
      settingBloc.updateConfig(statusMessage: statusMessage);
      log("$statusMessage");
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds <= 1) {
          timer.cancel();
          statusMessage = "0";
          settingBloc.updateConfig(
              statusMessage: statusMessage, isStartProvision: false);
          _currentProvisioner?.stop();
          return;
        }
        _remainingSeconds--;
        statusMessage = "Đang chờ thiết bị phản hồi ${_remainingSeconds.toString()}";
        settingBloc.updateConfig(statusMessage: statusMessage);
      });
    } catch (e) {
      statusMessage = "Lỗi khi bắt đầu cấu hình: $e";
      settingBloc.updateConfig(statusMessage: statusMessage);
      if (e.toString().contains("UDP port bind failed")) {
        statusMessage =
            "$statusMessage\nVui lòng kiểm tra quyền mạng hoặc cổng 18266.";
        settingBloc.updateConfig(statusMessage: statusMessage);
      }
      log("$statusMessage");
      log('Lỗi khi khởi tạo SmartConfig: $e');
      showErrorTopSnackBarCustom(context, statusMessage ?? "");
      _countdownTimer?.cancel();
      _currentProvisioner?.stop();
    }
  }

  // Thêm một hàm để dừng SmartConfig thủ công
  void stopProvisioning() {
    _currentProvisioner?.stop();
    _countdownTimer?.cancel();
    statusMessage = "Đã dừng quá trình cấu hình.";
    settingBloc.updateConfig(
        statusMessage: statusMessage, isStartProvision: false);
  }

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
