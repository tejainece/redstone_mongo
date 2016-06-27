part of redstone_mongo.src;

//MongoDb connection pool
class Pool extends ConnectionPool<mgo.Db> {
  String uri;

  Pool(String this.uri, int poolSize) : super(poolSize) {}

  @override
  Future<mgo.Db> openNewConnection() {
    var conn = new mgo.Db(uri);
    return conn.open().then((_) => conn);
  }

  @override
  void closeConnection(mgo.Db conn) {
    conn.close();
  }
}