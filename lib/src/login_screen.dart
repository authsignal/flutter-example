import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'authsignal.dart';
import 'home_screen.dart';

String localhost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
String localURL = 'http://$localhost:3030';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = "";

  Future<String?> _signUp() async {
    var response = await http.post(Uri.parse('$localURL/sign-up'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userName': _username,
        }));

    var body = jsonDecode(response.body) as Map<String, dynamic>;

    String? error = body["error"];
    String? token = body["token"];

    if (error != null || token == null) {
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Error: $error");

      return null;
    }

    var result = await authsignal.passkey.signUp(token, userName: _username);

    if (result.error != null) {
      debugPrint("Error: ${result.error}");

      return null;
    } else {
      debugPrint("result token: ${result.data}");

      return result.data;
    }
  }

  Future<String?> _signIn() async {
    var response = await http.post(Uri.parse('$localURL/sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userName': _username,
        }));

    var body = jsonDecode(response.body) as Map<String, dynamic>;

    String? error = body["error"];
    String? token = body["token"];

    if (error != null || token == null) {
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Error: $error");

      return null;
    }

    var result = await authsignal.passkey.signIn(token: body["token"]);

    debugPrint("result token: ${result.data}");

    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'username',
                ),
                onChanged: (text) {
                  setState(() {
                    _username = text;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    String? token = await _signUp();

                    if (token != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(token: token)),
                      );
                    }
                  },
                  child: const Text('Sign up'),
                ),
              ),
              const Text('or'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    String? token = await _signIn();

                    if (token != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(token: token)),
                      );
                    }
                  },
                  child: const Text('Sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
