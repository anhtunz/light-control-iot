import 'package:equatable/equatable.dart';

class ConfigModel extends Equatable {
  final String statusMessage;
  final bool isShowPassword;
  final String buttonMessage;
  final bool isStartProvision;


  const ConfigModel({
    this.statusMessage = '',
    this.isShowPassword = false,
    this.buttonMessage = '',
    this.isStartProvision = false
  });

  ConfigModel copyWith({
    String? statusMessage,
    bool? isShowPassword,
    String? buttonMessage,
    bool? isStartProvision
  }) {
    return ConfigModel(
      statusMessage: statusMessage ?? this.statusMessage,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      buttonMessage: buttonMessage ?? this.buttonMessage,
        isStartProvision: isStartProvision ?? this.isStartProvision
    );
  }

  @override
  List<Object?> get props => [
    statusMessage,
    isShowPassword,
    buttonMessage,
    isStartProvision
  ];
}
