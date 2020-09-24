import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CheckToken {

  Future<Map<String, dynamic>> readToken() async {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final bool isExpired = JwtDecoder.isExpired(token);

    return {
      'isExpired': isExpired,
      'decoded': decodedToken
    };
  }
}