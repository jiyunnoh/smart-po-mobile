import 'package:biot/constants/enum.dart';
import 'package:biot/model/patient.dart';

import '../constants/app_strings.dart';
import 'encounter.dart';

class Device {
  late String id;
  String deviceName;
  AmputeeSide amputeeSide;
  String? lCode;
  bool isEdited;

  Device(
      {this.id = '',
      required this.deviceName,
      required this.amputeeSide,
      this.lCode,
      this.isEdited = false});

  factory Device.fromJson(Map<String, dynamic> data) {
    Device device = Device(
        id: data['_id'],
        deviceName: data['device_name'],
        amputeeSide: (data['amputee_side'] == 2)
            ? AmputeeSide.both
            : (data['amputee_side'] == 1)
                ? AmputeeSide.right
                : AmputeeSide.left,
        lCode: data['l_code']);
    return device;
  }

  Map<String, dynamic> toJson(
    ownerOrganizationId, {
    String? date,
    Patient? patient,
    Encounter? encounter,
  }) {
    date = date ?? 'current';

    Map<String, dynamic> body = {
      "_name": DateTime.now().toString(),
      "_templateId": ksDeviceTemplateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "l_code": lCode,
      "amputee_side": amputeeSide.index,
      "device_name": deviceName
    };

    if (patient != null) {
      body.addAll({
        "patient_for_device": {"id": patient.entityId}
      });
    }
    if (encounter != null) {
      body.addAll({
        "encounter_for_device": {"id": encounter.entityId}
      });
    }

    return body;
  }
}
