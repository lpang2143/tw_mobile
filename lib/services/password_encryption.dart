import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

List<String> encryptPassword(String password) {
  Random shaker = Random.secure();
  //64-bit salt is sufficient for now
  final salt = List.generate(8, (_) => shaker.nextInt(256));
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes + salt);
  return [hash.toString(), salt.toString()];
}

// void main() {
//   print(encryptPassword('hello world'));
// }
