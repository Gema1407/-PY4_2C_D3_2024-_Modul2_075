import 'package:flutter_test/flutter_test.dart';
// Sesuaikan import path ini dengan lokasi file login_controller.dart di project kamu
import 'package:logbook_app_075/features/auth/login_controller.dart'; 

void main() {
  var actual;
  var expected;

  group('Module 2 - LoginController (Authentication)', () {
    late LoginController controller;

    setUp(() {
      // (1) setup (arrange, build)
      // Inisialisasi object controller sebelum setiap test case dijalankan
      controller = LoginController();
    });

    test('TC01: login should succeed with valid credentials (Positif)', () {
      // (1) setup (arrange, build)
      const validUsername = "admin1";
      const validPassword = "123";

      // (2) exercise (act, operate)
      actual = controller.login(validUsername, validPassword);
      expected = true;

      // (3) verify (assert, check)
      expect(actual, expected, reason: 'Expected $expected but got $actual (Login harusnya berhasil)');
    });

    test('TC02: login should fail with incorrect password (Negatif)', () {
      // (1) setup (arrange, build)
      const validUsername = "admin1";
      const invalidPassword = "salah123"; // Password salah

      // (2) exercise (act, operate)
      actual = controller.login(validUsername, invalidPassword);
      expected = false;

      // (3) verify (assert, check)
      expect(actual, expected, reason: 'Expected $expected but got $actual (Login harusnya gagal)');
    });

    test('TC03: login should reject empty fields (Negatif)', () {
      // (1) setup (arrange, build)
      const emptyUsername = "";
      const emptyPassword = "";

      // (2) exercise (act, operate)
      actual = controller.login(emptyUsername, emptyPassword);
      expected = false;

      // (3) verify (assert, check)
      expect(actual, expected, reason: 'Expected $expected but got $actual (Login dengan field kosong harusnya gagal)');
    });
  });
}