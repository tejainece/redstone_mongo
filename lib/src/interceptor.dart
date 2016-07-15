part of redstone_mongo.src;

/*
//TODO remove
@app.Interceptor(r'/.*')
handleCORS() async {
  print("here!");
  if (app.request.method != "OPTIONS") {
    await app.chain.next();
  }
  return app.response.change(headers: {"Access-Control-Allow-Origin": "*"});
}

@app.Interceptor(r'/.*')
dbManager(@app.Inject() Pool pool) async {
  print("wowwie!");

  //get a connection from the pool
  ManagedConnection<mgo.Db> aManConn = await pool.getConnection();

  //set the connection as a request attribute
  app.request.attributes.conn = aManConn.conn;

  //call the next handler of the chain. Release
  //the connection when it's done
  final lRet = await app.chain.next();

  if (app.chain.error is mgo.ConnectionException) {
    pool.releaseConnection(aManConn, markAsInvalid: true);
  } else {
    pool.releaseConnection(aManConn);
  }

  return lRet;
}
*/

class Mgo {
  Mgo(this._managedConn) {}

  ManagedConnection<mgo.Db> _managedConn;

  mgo.Db getDb() {
    return _managedConn.conn;
  }
}

/// Manage connections with a MongoDB instance
class DbManager implements mapperDb.DatabaseManager<Mgo> {
  Pool _pool;

  /// Creates a new MongoDbManager
  ///
  /// [uri] a MongoDB uri, and [poolSize] is the number of connections
  /// that will be created.
  DbManager(String uri, {int poolSize: 3}) {
    print("Creating DBManager ...");
    _pool = new Pool(uri, poolSize);
  }

  @override
  Future<Mgo> getConnection() async {
    ManagedConnection<mgo.Db> lConn = await _pool.getConnection();
    return new Mgo(lConn);
  }

  @override
  void closeConnection(Mgo connection, {error}) {
    var invalidConn = error is mgo.ConnectionException;
    _pool.releaseConnection(
        connection._managedConn,
        markAsInvalid: invalidConn);
  }
}