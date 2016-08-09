part of redstone_mongo.src;

Object decoder(
    Object data, String fieldName, mapper.Field fieldInfo, List metadata) {
  String lName = fieldName;

  if (fieldInfo.model is String) {
    if (fieldInfo.model.isEmpty) {
      return mapper.ignoreValue;
    }

    lName = fieldInfo.model;
  }

  var value = (data as Map)[lName];

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
  String lName = fieldName;

  if (fieldInfo.model is String) {
    if (fieldInfo.model.isEmpty) {
      return;
    }

    lName = fieldInfo.model;
  }

  if (fieldInfo is Id || fieldInfo is RefId) {
    if (value != null) {
      if (value is String) {
        value = mgo.ObjectId.parse(value);
        data[lName] = value;
      } else if (value is List) {
        value = (value as List).map((o) => mgo.ObjectId.parse(o)).toList();
        data[lName] = value;
      }
    }
  } else {
    data[lName] = value;
  }
}


mapper.GenericTypeCodec codec = new mapper.GenericTypeCodec(
    fieldDecoder: decoder, fieldEncoder: encoder);