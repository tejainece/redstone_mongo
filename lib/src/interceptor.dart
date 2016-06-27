part of redstone_mongo.src;

@app.Interceptor(r'/.*')
dbManager(@app.Inject() Pool pool) async {
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