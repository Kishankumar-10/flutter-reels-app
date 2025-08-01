import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection_container.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  InjectionContainer.init();
  runApp(const ReelsApp());
}

class ReelsApp extends StatelessWidget {
  const ReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: InjectionContainer.categoryProvider),
        ChangeNotifierProvider.value(value: InjectionContainer.videoProvider),
      ],
      child: MaterialApp(
        title: 'Reels App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}