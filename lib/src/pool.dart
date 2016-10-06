part of redstone_mongo.src;

//MongoDb connection pool
class Pool extends ConnectionPool<mgo.Db> {
  String uri;

  Pool(String this.uri, int poolSize) : super(poolSize) {
    print("Creating pool ...");
  }

  @override
  Future<mgo.Db> openNewConnection() {
    var conn = new mgo.Db(uri);
    return conn.open(writeConcern: mgo.WriteConcern.JOURNALED).then((_) => conn);
  }

  @override
  closeConnection(mgo.Db conn) async {
    await conn.close();
  }
}