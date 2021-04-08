import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

typedef KetikaDibuat = Future Function();
class MakuroDb{
  /// penamaan nama database, bisa dirubah pada setiap class anakan
  static String _dbName = "myDb";
  String get dbName => _dbName;
  
  /// jika ingin prin log debug default adalah true
  static bool _debug = true;

  bool get debug => _debug;

  printDebug(String text){
    if(debug) print(text);
  }
  
  static int _version = 1;


  int get version => _version;


  static Database? _database;

  Database? get database => _database;

  static membuat(KetikaDibuat ketikaDibuat , {bool setDebug = false})async{

    try {
      String  path = join(await getDatabasesPath(), "$_dbName.db");
      _database = await openDatabase(
        path,
        version: _version,
      ); 
    } catch (e) {
      print(e.toString());
    }

    await ketikaDibuat();
  }

}
