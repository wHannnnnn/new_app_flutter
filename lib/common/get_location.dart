import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  final permissions = await Permission.locationWhenInUse.request();
  if (permissions.isGranted) {
    return true;
  } else {
    return false;
  }
}
class GetLocation {
  static getLocationInfo() async {
    await AmapCore.init('2286c37a70f3b65c016d1c32229ac841');
    if (await requestPermission()) {
      final location = await AmapLocation.instance.fetchLocation();
      return location;
    }
  }
}
