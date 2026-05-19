import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/input_form.dart';
import '../widgets/map_viewer.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _socialController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(text: "Islamabad");
  bool _loading = false;

  Future<void> _analyze() async {
    setState(() => _loading = true);

    // Build request body without weather_alert (backend will fetch weather automatically)
    final Map<String, dynamic> requestBody = {
      "social_text": _socialController.text.trim(),
      "location": _locationController.text.trim(),
    };

    try {
      final backendUrl = kIsWeb
          ? "http://localhost:8000/analyze"
          : "http://10.0.2.2:8000/analyze";
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(data: data)),
        );
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Failed to connect to backend: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CIRO - Crisis Orchestrator"),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InputForm(
              socialController: _socialController,
              locationController: _locationController,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _loading ? null : _analyze,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.analytics),
              label: Text(_loading ? "Analyzing..." : "Detect & Respond"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Live Map (mock - will be upgraded with Google Maps)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: MapViewer(location: _locationController.text),
            ),
          ],
        ),
      ),
    );
  }
}