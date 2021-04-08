 import 'package:flutter/cupertino.dart';

import 'makuro_type.dart';

/// [name] adalah nama dari kolom, bentuknya string
/// [type] diambil dari [MakuroType()] class, return , data type sqlite TEXT, INTEGER dll
/// 

class MakuroModel{

  String? name;
  MakuroType? type;
  bool primaryKey;
  bool notNull;
  bool unique;
  bool autoIncrement;
  MakuroModel(
    {
      @required this.name, 
      @required this.type, 
      this.primaryKey = false,
      this.notNull = false,
      this.unique = false,
      this.autoIncrement = false
    }
  );

  String get hasil => "$name ${type?.hasil} ${!primaryKey? '': 'PRIMARY KEY'} ${notNull? 'NOT NULL': ''} ${unique?'UNIQUE':''} ${autoIncrement?'AUTOINCREMENT': ''}";
}
