import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smt_project/feature/auto_config/auto_config_bloc.dart';
import 'package:smt_project/feature/smart_config/manual_config.dart';
import 'package:smt_project/product/base/bloc/base_bloc.dart';
import 'package:smt_project/product/constants/enums/app_route_enums.dart';

class AutoConfigScreeen extends StatefulWidget {
  const AutoConfigScreeen({super.key});

  @override
  State<AutoConfigScreeen> createState() => _AutoConfigScreeenState();
}

class _AutoConfigScreeenState extends State<AutoConfigScreeen> {
  late AutoConfigBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tự động cấu hình')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<AutoConfigStatus>(
            stream: bloc.configStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final status = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusWidget(status),
                  const SizedBox(height: 20),
                  if (status.retryCount > 0)
                    Text(
                        'Số lần thử lại: ${status.retryCount}/${AutoConfigBloc.maxRetries}'),
                  const SizedBox(height: 20),
                  if (status.showManualButton)
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManualConfig(),
                          ),
                        );
                      },
                      child: const Text('Cấu hình thủ công'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusWidget(AutoConfigStatus status) {
    switch (status.state) {
      case AutoConfigState.scanning:
        return Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Đang tìm thiết bị...')
          ],
        );
      case AutoConfigState.configuring:
        return Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Đang cấu hình thiết bị...')
          ],
        );
      case AutoConfigState.retrying:
        return Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Đang thử lại...')
          ],
        );
      case AutoConfigState.failed:
        return const Text(
          'Cấu hình thất bại\nVui lòng thử cấu hình thủ công',
          textAlign: TextAlign.center,
        );
      case AutoConfigState.success:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pushReplacementNamed(
            AppRoutes.HOME.name,
            pathParameters: {'deviceIp': status.deviceIp!},
          );
        });
        return const Text('Cấu hình thành công!');
    }
  }
}
