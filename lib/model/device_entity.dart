class Device {
  Device({
    required this.code,
    required this.message,
    required this.order,
  });

  final int? code;
  final String? message;
  final Order? order;

  factory Device.fromJson(Map<String, dynamic> json){
    return Device(
      code: json["code"],
      message: json["message"],
      order: json["order"] == null ? null : Order.fromJson(json["order"]),
    );
  }

}

class Order {
  Order({
    required this.id,
    required this.oCode,
    required this.oName,
    required this.oAgencyId,
    required this.oUserId,
    required this.oProductId,
    required this.oRegistrationDate,
    required this.oDateSetting,
    required this.oSampleTable,
    required this.oSampleD1,
    required this.oSampleD2,
    required this.oSampleD3,
    required this.oSampleD4,
    required this.oSampleD5,
    required this.oSampleD6,
    required this.oSampleD7,
    required this.oD1,
    required this.oD2,
    required this.oD3,
    required this.oD4,
    required this.oD5,
    required this.oD6,
    required this.oD7,
    required this.oD0,
    required this.oD8,
    required this.oD1X,
    required this.oD2X,
    required this.oD5X,
    required this.oD6X,
    required this.oD7X,
    required this.oPort,
    required this.oBoard,
    required this.chipId,
    required this.oTimeIn,
    required this.oTimeOut,
    required this.oIn,
    required this.oOut,
    required this.createdAt,
    required this.updatedAt,
    required this.enLed1On,
    required this.enLed1Off,
    required this.enLed2On,
    required this.enLed2Off,
    required this.enLed3On,
    required this.enLed3Off,
    required this.enLed4On,
    required this.enLed4Off,
    required this.timeLed1On,
    required this.timeLed1Off,
    required this.timeLed2On,
    required this.timeLed2Off,
    required this.timeLed3On,
    required this.timeLed3Off,
    required this.timeLed4On,
    required this.timeLed4Off,
    required this.temperature,
    required this.humidity,
  });

  final int? id;
  final String? oCode;
  final String? oName;
  final int? oAgencyId;
  final int? oUserId;
  final int? oProductId;
  final dynamic oRegistrationDate;
  final DateTime? oDateSetting;
  final dynamic oSampleTable;
  final dynamic oSampleD1;
  final dynamic oSampleD2;
  final dynamic oSampleD3;
  final dynamic oSampleD4;
  final dynamic oSampleD5;
  final dynamic oSampleD6;
  final dynamic oSampleD7;
  final String? oD1;
  final String? oD2;
  final String? oD3;
  final String? oD4;
  final String? oD5;
  final String? oD6;
  final String? oD7;
  final String? oD0;
  final String? oD8;
  final String? oD1X;
  final String? oD2X;
  final String? oD5X;
  final String? oD6X;
  final String? oD7X;
  final dynamic oPort;
  final String? oBoard;
  final int? chipId;
  final dynamic oTimeIn;
  final dynamic oTimeOut;
  final dynamic oIn;
  final dynamic oOut;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic enLed1On;
  final dynamic enLed1Off;
  final dynamic enLed2On;
  final dynamic enLed2Off;
  final dynamic enLed3On;
  final dynamic enLed3Off;
  final dynamic enLed4On;
  final dynamic enLed4Off;
  final dynamic timeLed1On;
  final dynamic timeLed1Off;
  final dynamic timeLed2On;
  final dynamic timeLed2Off;
  final dynamic timeLed3On;
  final dynamic timeLed3Off;
  final dynamic timeLed4On;
  final dynamic timeLed4Off;
  final int? temperature;
  final int? humidity;

  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
      id: json["id"],
      oCode: json["o_code"],
      oName: json["o_name"],
      oAgencyId: json["o_agency_id"],
      oUserId: json["o_user_id"],
      oProductId: json["o_product_id"],
      oRegistrationDate: json["o_registration_date"],
      oDateSetting: DateTime.tryParse(json["o_date_setting"] ?? ""),
      oSampleTable: json["o_sample_table"],
      oSampleD1: json["o_sample_d1"],
      oSampleD2: json["o_sample_d2"],
      oSampleD3: json["o_sample_d3"],
      oSampleD4: json["o_sample_d4"],
      oSampleD5: json["o_sample_d5"],
      oSampleD6: json["o_sample_d6"],
      oSampleD7: json["o_sample_d7"],
      oD1: json["o_d1"],
      oD2: json["o_d2"],
      oD3: json["o_d3"],
      oD4: json["o_d4"],
      oD5: json["o_d5"],
      oD6: json["o_d6"],
      oD7: json["o_d7"],
      oD0: json["o_d0"],
      oD8: json["o_d8"],
      oD1X: json["o_d1_x"],
      oD2X: json["o_d2_x"],
      oD5X: json["o_d5_x"],
      oD6X: json["o_d6_x"],
      oD7X: json["o_d7_x"],
      oPort: json["o_port"],
      oBoard: json["o_board"],
      chipId: json["chip_id"],
      oTimeIn: json["o_time_in"],
      oTimeOut: json["o_time_out"],
      oIn: json["o_in"],
      oOut: json["o_out"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      enLed1On: json["en_led1_on"],
      enLed1Off: json["en_led1_off"],
      enLed2On: json["en_led2_on"],
      enLed2Off: json["en_led2_off"],
      enLed3On: json["en_led3_on"],
      enLed3Off: json["en_led3_off"],
      enLed4On: json["en_led4_on"],
      enLed4Off: json["en_led4_off"],
      timeLed1On: json["time_led1_on"],
      timeLed1Off: json["time_led1_off"],
      timeLed2On: json["time_led2_on"],
      timeLed2Off: json["time_led2_off"],
      timeLed3On: json["time_led3_on"],
      timeLed3Off: json["time_led3_off"],
      timeLed4On: json["time_led4_on"],
      timeLed4Off: json["time_led4_off"],
      temperature: json["temperature"],
      humidity: json["humidity"],
    );
  }

}
