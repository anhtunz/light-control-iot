import 'dart:async';
import 'dart:developer';

import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:wifi_scan/wifi_scan.dart';
import '../../product/base/bloc/base_bloc.dart';

enum AutoConfigState {
  scanning,
  configuring,
  retrying,
  failed,
  success,
}

class AutoConfigStatus {
  final AutoConfigState state;
  final String? deviceIp;
  final bool showManualButton;
  final int retryCount;

  AutoConfigStatus({
    required this.state,
    this.deviceIp,
    this.showManualButton = false,
    this.retryCount = 0,
  });
}

class AutoConfigBloc extends BlocBase {
  final _configController = StreamController<AutoConfigStatus>.broadcast();
  StreamSink<AutoConfigStatus> get _configSink => _configController.sink;
  Stream<AutoConfigStatus> get configStream => _configController.stream;

  Timer? _scanTimer;
  Timer? _smartConfigTimer;
  Provisioner? _provisioner;
  int _retryCount = 0;
  static const int maxRetries = 5;

  AutoConfigBloc() {
    _startScanning();
  }

  Future<void> _startScanning() async {
    _configSink.add(AutoConfigStatus(state: AutoConfigState.scanning));

    try {
      final canScan =
          await WiFiScan.instance.canStartScan(askPermissions: true);
      if (canScan != CanStartScan.yes) {
        _handleError('Cannot scan WiFi: $canScan');
        return;
      }

      _scanWiFiNetworks();
    } catch (e) {
      _handleError('Error starting WiFi scan: $e');
    }
  }

Future<void> _scanWiFiNetworks() async {
  try {
    await WiFiScan.instance.startScan();
    final results = await WiFiScan.instance.getScannedResults();

    final targetAP = results.firstWhere(
      (ap) => ap.ssid.toLowerCase().contains('lhp-smart-m1'.toLowerCase()),
      orElse: () => throw Exception('Target device not found'),
    );

    _startSmartConfig(targetAP);
  } catch (e) {
    // Retry scan sau 5 giây nếu chưa tìm thấy
    _scanTimer = Timer(const Duration(seconds: 5), _startScanning);
  }
}


  Future<void> _startSmartConfig(WiFiAccessPoint ap) async {
    _configSink.add(AutoConfigStatus(
      state: _retryCount > 0
          ? AutoConfigState.retrying
          : AutoConfigState.configuring,
      showManualButton: _retryCount > 0,
      retryCount: _retryCount + 1,
    ));

    _provisioner = Provisioner.espTouch();

    try {
      _provisioner!.listen(
        (response) {
          if (response.ipAddressText != null) {
            _handleSuccess(response.ipAddressText!);
          } else {
            _handleError('No IP address received');
          }
        },
        onError: (error, stackTrace) {
          log('SmartConfig error: $error\n$stackTrace');
          _handleError('SmartConfig failed');
        },
        onDone: () {
          // Only handle timeout if we haven't succeeded
          if (_retryCount < maxRetries) {
            _handleTimeout();
          }
        },
      );

      await _provisioner!.start(
        ProvisioningRequest.fromStrings(
          ssid: ap.ssid,
          bssid: ap.bssid,
          password: '', // No password for ESP device in AP mode
        ),
      );

      // Set timeout for 30 seconds
      _smartConfigTimer = Timer(const Duration(seconds: 30), () {
        _provisioner?.stop();
      });
    } catch (e) {
      _handleError('Error starting SmartConfig: $e');
    }
  }

  void _handleSuccess(String deviceIp) {
    _configSink.add(AutoConfigStatus(
      state: AutoConfigState.success,
      deviceIp: deviceIp,
    ));
    _cleanup();
  }

  void _handleError(String error) {
    _retryCount++;
    if (_retryCount >= maxRetries) {
      _configSink.add(AutoConfigStatus(
        state: AutoConfigState.failed,
        showManualButton: true,
        retryCount: _retryCount,
      ));
    } else {
      _configSink.add(AutoConfigStatus(
        state: AutoConfigState.failed,
        showManualButton: true,
        retryCount: _retryCount,
      ));
      // Start scanning again after a delay
      _scanTimer = Timer(const Duration(seconds: 5), _startScanning);
    }
  }

  void _handleTimeout() {
    _handleError('SmartConfig timeout');
  }

  void _cleanup() {
    _scanTimer?.cancel();
    _smartConfigTimer?.cancel();
    _provisioner?.stop();
  }

  @override
  void dispose() {
    _cleanup();
    _configController.close();
  }
}
