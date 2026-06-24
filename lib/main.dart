import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/views/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'id_ID';
  await initializeDateFormatting('id_ID', null);

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
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}
