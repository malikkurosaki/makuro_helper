import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';
import 'makuro_db.dart';
import 'makuro_model.dart';

typedef OnCoba<T> = int Function(T);
abstract class MakuroQuery<@required T> extends MakuroDb{

  /// hasus diisi untuk nama kolom tabel database
  List<MakuroModel> get field;

  //T fromJson(Map<String, dynamic> json);

  /// mendapatkan nama tabel yang diambil dari nama class
  String get tableName => this.toString().split(" ")[2].replaceAll("'", "");
  MakuroQuery();

  /// rubah data yang didapat ke json yang kemudian diteruskan ke dtabase
  Map<String, dynamic> toJson();

  /// merubah json menjadi object class
  MakuroQuery.fromJson(Map<String,dynamic> json);

  /// initial digunakan saat load pertamakalinya
  /// membuat tabel jika tabel belum dibuat
  init({bool force = false, bool seeder = false})async{
    if(force){
      await database?.execute("DROP TABLE IF EXISTS $tableName");
      await database?.execute("CREATE TABLE IF NOT EXISTS $tableName ( ${field.map((e) => e.hasil).toList().join(",")})");
      printDebug("$tableName created FORCE");
    }
    else{
      await database?.execute("CREATE TABLE IF NOT EXISTS $tableName ( ${field.map((e) => e.hasil).toList().join(",")})");
      printDebug("$tableName created ");
    }

    if(seeder) loadSeeder();
  }

  loadSeeder(){

  }

  /// menghapus tabel seluruhnya dihapus
  /// 
  /// ```sql
  /// "DROP TABLE IF EXISTS TABLE_NAME"
  /// ```
  /// 
  /// .
  deleteTable()async{
    await database?.execute("DROP TABLE IF EXISTS $tableName");
    printDebug("$tableName deleted");
  }

  /// hanya membersihkan isi tabel tanpa menghapus tabelnya
  /// 
  /// ```sql
  /// "DELETE FROM TABLE_NAME"
  /// ```
  /// 
  /// .
  cleanTable()async{
    await database?.execute("DELETE FROM $tableName");
    printDebug("$tableName cleanup");
  }
  

  /// mamasukkan data ke database 
  /// berupa jenis map / json [values]
  /// 
  /// ```sql
  /// INSERT INTO TABLE_NAME VALUES(?)
  /// 
  /// .
  Future<int?> insert(Map<String, dynamic> values)async{
    var id;
    try {
      id = await database?.insert(tableName, values,
        conflictAlgorithm: ConflictAlgorithm.abort
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  /// update date kedalan database
  /// 
  /// sebagai kuncinya adalah [values][id]
  /// 
  /// ```sql
  /// UPDATE employees
  /// SET lastname = 'Smith'
  /// WHERE employeeid = 3;
  /// ```
  /// 
  /// .
  Future<int?> update(Map<String, dynamic> values)async => await database?.update(tableName, values, where: "id = ?", whereArgs: [values['id']]);

  /// menambahkan kolom pada database
  /// 
  /// ```sql
  /// ALTER TABLE TABLE_NAME ADD COLUMN NEW_COLUMN_NAME INTEGER;
  /// ```
  /// 
  /// .
  addColumn(MakuroModel model)async{
    await database?.execute("ALTER TABLE $tableName ADD COLUMN ${model.hasil}");
    printDebug("add collumn ${model.hasil}");
  }

  /// mendapatkan semua isi dalam tabel
  /// ```sql
  /// SELECT * FROM TABLE_NAME
  /// ```
  /// 
  /// .
  Future<List<Map<String, dynamic>>> findAll()async => await database!.rawQuery("select * FROM $tableName");

  Future<bool?> findBy(String columnName, String value) async{
    final data = await database?.rawQuery("SELECT $columnName FROM $tableName WHERE $columnName = '$value'");
    return data!.isNotEmpty? true: false;
  }

  

  
  /// menghapus isi dari tabel sesuai dengan id
  /// 
  /// [id] adalah id dari row
  /// 
  /// __CONTOH__
  /// ```sql
  /// DELETE FROM TABLE_NAME WHERE id = 1
  /// ```
  /// 
  /// 
  Future<int?> delete(int id) async => await database?.delete(tableName, where: "id = ?", whereArgs: [id] );


  Future<List<Map<String,dynamic>>> searchBy(String field, String value) async => await database!.rawQuery("SELECT * FROM $tableName WHERE $field LIKE '%$value%'");

  Future<List<Map<String, dynamic>>> findAllByName(String value) async => await database!.rawQuery("SELECT * FROM $tableName WHERE name LIKE '%$value%'");

  Future<List<Map>> findEmailPassword(Map<String, dynamic> values)async => database!.query(tableName, columns: ['name'], where: 'email = ? and password = ?', whereArgs: [values['email'], values['password']]);
}
