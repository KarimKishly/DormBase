import 'package:dorm_base/sqlconn/Services.dart';
void main() async {
  print(await Services.getRating(dormID: '1'));
  }