import 'device_model.dart';

class GroupModel {
  String groupId;
  String groupName;
  String groupImage;
  List<DeviceModel> devices;
  GroupModel(this.groupId, this.groupName, this.groupImage, this.devices);
}

List<GroupModel> groupsExample = [
  GroupModel(
      "group1",
      "Phòng khách",
      "https://donggia.vn/wp-content/uploads/2019/10/thiet-ke-noi-that-phong-khach-biet-thu-dep-hien-dai-2020-30.jpg",
      [
        DeviceModel("device1", "Đèn giường", "light", "on"),
        DeviceModel("device2", "Đèn trần", "light", "off"),
      ]),
  GroupModel(
      "group2",
      "Phòng ngủ",
      "https://sbshouse.vn/wp-content/uploads/2022/10/Noi-that-nha-3-tang-hien-dai-20.jpg",
      []),
];
