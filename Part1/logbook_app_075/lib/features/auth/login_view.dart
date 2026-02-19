// login_view.dart
import 'dart:async';
import 'package:flutter/material.dart';
// Import Controller milik sendiri (masih satu folder)
import 'package:logbook_app_075/features/auth/login_controller.dart';
// Import View dari fitur lain (Logbook) untuk navigasi
import 'package:logbook_app_075/features/logbook/counter_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Inisialisasi Otak dan Controller Input
  final LoginController _controller = LoginController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Variabel untuk tracking login attempts dan lockout
  int _failedAttempts = 0;
  bool _isLocked = false;
  int _countdownSeconds = 10;
  Timer? _lockoutTimer;

  // Variabel untuk toggle visibility password
  bool _isPasswordVisible = false;

  void _startLockoutTimer() {
    setState(() {
      _isLocked = true;
      _countdownSeconds = 10;
    });

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });

      if (_countdownSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isLocked = false;
          _failedAttempts = 0; // Reset percobaan setelah unlock
        });
      }
    });
  }

  void _handleLogin() {
    // Cek apakah tombol sedang di-lock
    if (_isLocked) {
      return;
    }

    String user = _userController.text;
    String pass = _passController.text;

    // 1. Validasi: Cek apakah field masih kosong
    if (user.isEmpty || pass.isEmpty) {
      // Clear SnackBar sebelumnya agar tidak antri
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
        ),
      );
      return; // Stop eksekusi, tidak lanjut ke pengecekan login
    }

    // 2. Validasi: Cek login
    bool isSuccess = _controller.login(user, pass);

    if (isSuccess) {
      // Reset failed attempts jika login berhasil
      setState(() {
        _failedAttempts = 0;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Di sini kita kirimkan variabel 'user' ke parameter 'username' di CounterView
          builder: (context) => CounterView(username: user),
        ),
      );
    } else {
      // Increment failed attempts
      setState(() {
        _failedAttempts++;
      });

      if (_failedAttempts >= 3) {
        // Lock tombol setelah 3 kali gagal
        // Clear SnackBar sebelumnya agar tidak antri
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terlalu banyak percobaan! Tunggu 10 detik."),
          ),
        );
        _startLockoutTimer();
      } else {
        // Tampilkan sisa percobaan
        int remaining = 3 - _failedAttempts;
        // Clear SnackBar sebelumnya agar tidak antri
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login Gagal! Sisa percobaan: $remaining",
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Gatekeeper")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passController,
              obscureText: !_isPasswordVisible, // Toggle berdasarkan state
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLocked ? null : _handleLogin,
              child: Text(
                _isLocked ? "Tunggu $_countdownSeconds detik" : "Masuk",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
