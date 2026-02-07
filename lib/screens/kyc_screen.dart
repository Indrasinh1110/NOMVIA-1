import 'package:flutter/material.dart';
import '../state/app_state.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({super.key});

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final appState = AppState.instance;
  final _nameController = TextEditingController();
  final _aadharController = TextEditingController();
  final _panController = TextEditingController();
  bool _isLoading = false;

  void _submitKYC() {
    if (_nameController.text.isEmpty ||
        _aadharController.text.isEmpty ||
        _panController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      appState.isKycCompleted = true;
      if (appState.currentUser != null) {
        appState.currentUser = appState.currentUser!.copyWith(
          isKycCompleted: true,
        );
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KYC submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete KYC'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify Your Identity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please provide the following information to complete your KYC verification.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name (as per Aadhar)',
                hintText: 'Enter your full name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _aadharController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Aadhar Number',
                hintText: 'XXXX XXXX XXXX',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _panController,
              decoration: const InputDecoration(
                labelText: 'PAN Number',
                hintText: 'ABCDE1234F',
              ),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your information is secure and will only be used for verification purposes.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitKYC,
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Submit KYC'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    super.dispose();
  }
}
