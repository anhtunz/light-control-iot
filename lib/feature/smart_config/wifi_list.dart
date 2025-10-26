import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

Future<WiFiAccessPoint?> showWifiList(BuildContext context) async {
  List<WiFiAccessPoint> accessPoints = [];
  String? errorMessage;

  // Hàm quét Wi-Fi
  Future<void> scanWifi() async {
    try {
      final canScan = await WiFiScan.instance.canStartScan(askPermissions: true);

      switch (canScan) {
        case CanStartScan.yes:
          await WiFiScan.instance.startScan();
          List<WiFiAccessPoint> results = await WiFiScan.instance.getScannedResults();
          results.sort((a, b) => b.level.compareTo(a.level));
          accessPoints = results;
          break;
        case CanStartScan.failed:
          errorMessage = "Không thể quét Wi-Fi.";
          break;
        case CanStartScan.notSupported:
          errorMessage = "Thiết bị không hỗ trợ quét Wi-Fi.";
          break;
        case CanStartScan.noLocationPermissionRequired:
          errorMessage = "Cần cấp quyền vị trí để quét Wi-Fi.";
          break;
        case CanStartScan.noLocationPermissionDenied:
          errorMessage = "Quyền vị trí bị từ chối.";
          break;
        case CanStartScan.noLocationPermissionUpgradeAccuracy:
          errorMessage = "Cần nâng cấp độ chính xác vị trí.";
          break;
        case CanStartScan.noLocationServiceDisabled:
          errorMessage = "Dịch vụ định vị bị tắt.";
          break;
      }
    } catch (e) {
      errorMessage = "Lỗi: $e";
    }
  }

  // Gọi quét Wi-Fi ngay lập tức
  await scanWifi();

  // Hiển thị bottom sheet
  return showModalBottomSheet<WiFiAccessPoint?>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext modalBottomSheetContext, StateSetter setState) {
          if (accessPoints.isEmpty && errorMessage == null) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 400,
            child: Column(
              children: [
                const Text(
                  "Danh sách Wi-Fi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: accessPoints.isEmpty && errorMessage == null
                      ? const Center(child: Text("Chưa có Wi-Fi nào được tìm thấy."))
                      : ListView.builder(
                    itemCount: accessPoints.length,
                    itemBuilder: (context, index) {
                      final ap = accessPoints[index];
                      return ListTile(
                        title: Text(ap.ssid.isEmpty ? "Unknow Wifi" : ap.ssid),
                        subtitle: Text("Signal: ${ap.level} dBm"),
                        onTap: () {
                          Navigator.pop(modalBottomSheetContext, ap);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}