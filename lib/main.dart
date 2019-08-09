import 'package:flutter/material.dart';
import 'package:hello_world/app_store/app_state.dart';
import 'package:hello_world/app_store/chat_provider.dart';
import 'package:provider/provider.dart';
import 'blogs.dart';
import './pages/login/login.dart';
const kHostUrl="http://192.168.0.32:49615";
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      builder: (_) => AppState(),
      child: ChangeNotifierProvider<ChatProvider>(
          builder: (_) => ChatProvider(),
          child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.green[800],
                accentColor: Colors.green[600],
              ),
              home: LoginPage())),
    );
  }
}
