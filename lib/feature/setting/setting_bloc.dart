import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smt_project/feature/smart_config/config_model.dart';

import '../../product/cache/locale_manager.dart';
import '../../product/constants/enums/locale_keys_enum.dart';
import '../../product/shared/shared_snack_bar.dart';

import '../../product/base/bloc/base_bloc.dart';

class SettingBloc extends BlocBase {
  final switchButtonIndex = StreamController<int>.broadcast();
  StreamSink<int> get sinkSwitchButtonIndex => switchButtonIndex.sink;
  Stream<int> get streamSwitchButtonIndex => switchButtonIndex.stream;

  final isSelectedSwitchButtonChanged = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsSelectedSwitchButtonChanged =>
      isSelectedSwitchButtonChanged.sink;
  Stream<bool> get streamIsSelectedSwitchButtonChanged =>
      isSelectedSwitchButtonChanged.stream;


  final statusMessage = StreamController<String>.broadcast();
  StreamSink<String> get sinkStatusMessage => statusMessage.sink;
  Stream<String> get streamStatusMessage => statusMessage.stream;

  final configData = StreamController<ConfigModel>.broadcast();
  StreamSink<ConfigModel> get sinkConfigData => configData.sink;
  Stream<ConfigModel> get streamConfigData => configData.stream;

  void getSwitchButtonIndex() {
    int value =
        LocaleManager.instance.getIntValue(PreferencesKeys.SWITCH_BUTTON);
    sinkSwitchButtonIndex.add(value);
  }

  void setSwitchButtonIndex(BuildContext context, int value) async {
    LocaleManager.instance.setInt(PreferencesKeys.SWITCH_BUTTON, value);
    showSuccessTopSnackBarCustom(context, "Đổi nút thành công");
    Navigator.pop(context);
  }

  // giữ lại bản config hiện tại
  ConfigModel _currentConfig = const ConfigModel();
  void initialConfig(){
    sinkConfigData.add(_currentConfig);
  }
// cập nhật một hoặc nhiều field trong config
  void updateConfig({
    String? statusMessage,
    bool? isShowPassword,
    String? buttonMessage,
    bool? isStartProvision,

  }) {
    _currentConfig = _currentConfig.copyWith(
      statusMessage: statusMessage,
      isShowPassword: isShowPassword,
      buttonMessage: buttonMessage,
      isStartProvision: isStartProvision
    );

    sinkConfigData.add(_currentConfig);
  }

// getter lấy state hiện tại
  ConfigModel get currentConfig => _currentConfig;

  void setStatusMessage(String message) {
    sinkStatusMessage.add(message);
  }

  @override
  void dispose() {}
}
