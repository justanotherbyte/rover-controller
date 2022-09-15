import 'package:redis/redis.dart';
import 'dart:convert';

class RedisService {
  RedisConnection? conn;

  RedisService() {
    conn = RedisConnection();
  }

  Future connect(
      String host, int port, String username, String password) async {
    print('Connecting to redis');
    await conn!.connect(host, port);
    print('Connected to redis.');
    final authCommand = Command(conn!);
    await authCommand.send_object(['AUTH', username, password]);
    print('Authenticated to Redis');
  }

  Future sendPayload(Map data) async {
    var stringData = json.encode(data);
    final publishCommand = Command(conn!);
    await publishCommand.send_object(['PUBLISH', 'commands', stringData]);
  }
}
