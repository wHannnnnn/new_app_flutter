import 'package:device_info/device_info.dart';
import 'dart:io';
class Device {
  static getDeviceInfo() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo;
    }else if(Platform.isAndroid){
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo;
    }
  }
}
//  获取设备信息 使用方法
// _goFormPage() async {
//   var data = await Device.getDeviceInfo();
//   setState(() {
//     name = data.brand;
//   });
// }
