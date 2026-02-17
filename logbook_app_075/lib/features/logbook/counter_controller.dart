import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)
  int _step = 1;
  final List<String> _activityLogs = [];
  String? _username; // Username untuk menyimpan data per-user

  int get value => _counter; // Getter untuk akses data
  int get step => _step; // Getter untuk step
  List<String> get activityLogs => _activityLogs;

  // Method untuk load counter dan logs dari SharedPreferences berdasarkan username
  Future<void> loadCounter(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();

    // Load counter value
    _counter = prefs.getInt('counter_$username') ?? 0;

    // Load activity logs
    final savedLogs = prefs.getStringList('logs_$username');
    if (savedLogs != null) {
      _activityLogs.clear();
      _activityLogs.addAll(savedLogs);
    }
  }

  // Method untuk save counter dan logs ke SharedPreferences
  Future<void> _saveData() async {
    if (_username != null) {
      final prefs = await SharedPreferences.getInstance();
      // Save counter value
      await prefs.setInt('counter_$_username', _counter);
      // Save activity logs
      await prefs.setStringList('logs_$_username', _activityLogs);
    }
  }

  void setStep(int newStep) {
    _step = newStep;
  }

  void _addLog(String type, int value) {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    String message;
    if (type == 'increment') {
      message = 'User menambahkan nilai sebesar $value pada jam $hour.$minute';
    } else if (type == 'decrement') {
      message = 'User mengurangi nilai sebesar $value pada jam $hour.$minute';
    } else {
      message = 'User mereset nilai menjadi 0 pada jam $hour.$minute';
    }

    _activityLogs.add(message);

    if (_activityLogs.length > 100) {
      _activityLogs.removeAt(0); // Hapus entry paling awal
    }

    // Save logs setelah menambahkan
    _saveData();
  }

  void increment() {
    _counter += _step;
    _addLog('increment', _step);
  }

  void decrement() {
    int decrementValue = _step;
    if (_counter >= _step) {
      _counter -= _step;
    } else {
      decrementValue = _counter;
      _counter = 0;
    }
    _addLog('decrement', decrementValue);
  }

  void reset(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Reset'),
          content: const Text('Apakah Anda yakin ingin mereset hitungan ke 0?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _counter = 0;
                _addLog('reset', 0);
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Ya, Reset'),
            ),
          ],
        );
      },
    );
  }
}
