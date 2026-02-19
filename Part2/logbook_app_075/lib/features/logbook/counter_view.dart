import 'package:flutter/material.dart';
import 'package:logbook_app_075/features/onboarding/onboarding_view.dart';
import 'counter_controller.dart';

class CounterView extends StatefulWidget {
  // Tambahkan variabel final untuk menampung nama
  final String username;

  // Update Constructor agar mewajibkan (required) kiriman nama
  const CounterView({super.key, required this.username});
  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 11) {
      return '☀️ Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return '🌤️ Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return '🌅 Selamat Sore';
    } else {
      return '🌙 Selamat Malam';
    }
  }

  // Warna banner berdasarkan jam
  Color _getBannerColor() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 11) {
      return Colors.orange.shade100;
    } else if (hour >= 11 && hour < 15) {
      return Colors.yellow.shade100;
    } else if (hour >= 15 && hour < 18) {
      return Colors.deepOrange.shade100;
    } else {
      return Colors.indigo.shade100;
    }
  }

  @override
  void initState() {
    super.initState();
    // Load counter dari SharedPreferences saat widget pertama kali dibuat
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    await _controller.loadCounter(widget.username);
    setState(() {}); // Refresh UI setelah load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Gunakan widget.username untuk menampilkan data dari kelas utama
        title: Text("Logbook: ${widget.username}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Kita siapkan tombol logout di sini untuk Fase 3 nanti
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 1. Munculkan Dialog Konfirmasi
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi Logout"),
                    content: const Text(
                      "Apakah Anda yakin? Data yang belum disimpan mungkin akan hilang.",
                    ),
                    actions: [
                      // Tombol Batal
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context), // Menutup dialog saja
                        child: const Text("Batal"),
                      ),
                      // Tombol Ya, Logout
                      TextButton(
                        onPressed: () {
                          // Menutup dialog
                          Navigator.pop(context);

                          // 2. Navigasi kembali ke Onboarding (Membersihkan Stack)
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingView(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Ya, Keluar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Welcome Banner ────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: _getBannerColor(),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: Text(
                  '${_getGreeting()}, ${widget.username}!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Total Hitungan:"),
              Text(
                '${_controller.value}',
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 30),
              // Tombol tambah dan kurang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () => setState(() => _controller.decrement()),
                      icon: const Icon(Icons.remove, color: Colors.white),
                      iconSize: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _controller.reset(context);
                        setState(() {}); // Update UI setelah reset
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      iconSize: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () => setState(() => _controller.increment()),
                      icon: const Icon(Icons.add, color: Colors.white),
                      iconSize: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Slider untuk step
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Step: ${_controller.step}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: _controller.step.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '${_controller.step}',
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _controller.setStep(value.toInt());
                        });
                      },
                    ),
                    const Text(
                      'Pilih step 1 - 10',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Log Aktivitas
              const Text(
                'Log Aktivitas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _controller.activityLogs.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada aktivitas',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _controller.activityLogs.length > 5
                            ? 5
                            : _controller.activityLogs.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final logIndex =
                              _controller.activityLogs.length - 1 - index;
                          final message = _controller.activityLogs[logIndex];

                          Color bgColor;
                          if (message.contains('menambahkan')) {
                            bgColor = Colors.green.shade100;
                          } else if (message.contains('mengurangi')) {
                            bgColor = Colors.red.shade100;
                          } else {
                            bgColor = Colors.yellow.shade100;
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
