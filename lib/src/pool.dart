part of redstone_mongo.src;

//MongoDb connection pool
class Pool extends ConnectionPool<mgo.Db> {
  String uri;

  final mgo.WriteConcern _defaultWriteConcern;

  Pool(String this.uri, int poolSize,
      {mgo.WriteConcern writeConcern: mgo.WriteConcern.ACKNOWLEDGED})
      : super(poolSize), _defaultWriteConcern = writeConcern {
    print("Creating pool ...");
  }

  @override
  Future<mgo.Db> openNewConnection() {
    var conn = new mgo.Db(uri);
    return conn
        .open(writeConcern: _defaultWriteConcern)
        .then((_) => conn);
  }

  @override
  closeConnection(mgo.Db conn) async {
    await conn.close();
  }
}
