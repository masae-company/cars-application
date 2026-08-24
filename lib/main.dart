import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // Get from environment variables or use defaults
  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://glkaocrdikixgjybzutn.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsa2FvY3JkaWtpeGdqeWJ6dXRuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA5MDAxMDksImV4cCI6MjA3NjQ3NjEwOX0.6v-GGHNgzK77WJtkri89bgfZGq_6gOqVlxygfzmO9yg',
  );

  await SupabaseConfig.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
