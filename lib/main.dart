import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const TolonginApp());
}

class TolonginApp extends StatelessWidget {
  const TolonginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tolongin',
      debugShowCheckedModeBanner: false,
      home: const SupabaseConnectionTestPage(),
    );
  }
}

class SupabaseConnectionTestPage extends StatelessWidget {
  const SupabaseConnectionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SupabaseService.currentSession;

    return Scaffold(
      appBar: AppBar(title: const Text('Tolongin')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            session == null
                ? 'Supabase berhasil diinisialisasi.\nBelum ada user login.'
                : 'Supabase berhasil diinisialisasi.\nUser sedang login.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
