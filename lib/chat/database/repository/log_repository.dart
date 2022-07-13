import 'package:connect_chat/database/db/hive_methode.dart';
import 'package:connect_chat/database/db/sqlite_methode.dart';
import 'package:connect_chat/models/log.dart';

class LogRepository {
  static var dbObject;
  static bool? isHive;

  static init({required bool isHive, required String? dbName}) {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
