




import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbHelper {
  late Box box;
  late SharedPreferences preferences;


  DbHelper() {
    openbox();
  }

  openbox() {
    box = Hive.box('money');
  }
  Future deleteData(
      int index,
      ) async {
    await box.deleteAt(index);
  }


  Future addData(int amount, DateTime date, String note, String type) async
  {
    var values = {'amount': amount, 'date': date, 'type': type, 'note': note};
    box.add(values);
  }

  addName(String name) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString('name', name);
  }
  getName() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString('name');
  }

}