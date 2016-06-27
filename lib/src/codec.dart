part of redstone_mongo.src;

Object decoder(
    Object data, String fieldName, mapper.Field fieldInfo, List metadata) {
  String name = fieldInfo.model;
  if (name == null) {
    name = fieldName;
  }

  var value = (data as Map)[name];

  if (fieldInfo is Id || fieldInfo is RefId) {
    if (value is mgo.ObjectId) {
      value = value.toHexString();
    } else if (value is List) {
      value = (value as List).map((o) => o.toHexString()).toList();
    }
  }

  return value;
}

void encoder(Map data, String fieldName, mapper.Field fieldInfo,
    List metadata, Object value) {
  String name = fieldInfo.model;
  if (name == null) {
    name = fieldName;
  }
  if (fieldInfo is Id || fieldInfo is RefId) {
    if (value != null) {
      if (value is String) {
        value = mgo.ObjectId.parse(value);
        data[name] = value;
      } else if (value is List) {
        value = (value as List).map((o) => mgo.ObjectId.parse(o)).toList();
        data[name] = value;
      }
    }
  } else {
    data[name] = value;
  }
}


mapper.GenericTypeCodec codec = new mapper.GenericTypeCodec(
    fieldDecoder: decoder, fieldEncoder: encoder);