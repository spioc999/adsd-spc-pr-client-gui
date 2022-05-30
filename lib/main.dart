import 'dart:io';
import 'package:client_tcp/home_notifier.dart';
import 'package:client_tcp/home_screen.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setWindowSize(const Size(800,600));
    await DesktopWindow.setMinWindowSize(const Size(800,600));
    await DesktopWindow.setMaxWindowSize(const Size(800,600));
  }
  
  runApp(const TcpClientApp());
}

class TcpClientApp extends StatelessWidget {
  const TcpClientApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCP Client - SPC & PR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: ChangeNotifierProvider(
        create: (_) => HomeNotifier(),
        child: const HomeScreen(),
      ),
    );
  }
}
