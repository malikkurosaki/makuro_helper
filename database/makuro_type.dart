class MakuroType{
  String? type;
  MakuroType({this.type});

  /// CHARACTER(20)
  /// VARCHAR(255)
  /// VARYING CHARACTER(255)
  /// NCHAR(55)
  /// NATIVE CHARACTER(70)
  /// NVARCHAR(100)
  /// TEXT
  /// CLOB
  static MakuroType get text => MakuroType(type: "TEXT");

  /// INT
  /// INTEGER
  /// TINYINT
  /// SMALLINT
  /// MEDIUMINT
  /// BIGINT
  /// UNSIGNED BIG INT
  /// INT2
  /// INT8
  static MakuroType get integer => MakuroType(type: "INTEGER");

  /// BLOB
  /// no datatype specified
  static MakuroType get blob => MakuroType(type: "BLOB");

  /// REAL
  /// DOUBLE
  /// DOUBLE PRECISION
  /// FLOAT
  static MakuroType get real => MakuroType(type: "REAL");

  /// NUMERIC
  /// DECIMAL(10,5) as for money
  /// BOOLEAN
  /// DATE
  /// DATETIME
  static MakuroType get numeric => MakuroType(type: "NUMERIC");

  get hasil => "${this.type}";
}
