import 'package:flutter/material.dart';

import 'authsignal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.token});

  final String token;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _challengeID;

  @override
  void initState() {
    super.initState();

    authsignal.push.addCredential(widget.token).then((res) => {
          if (res.error != null)
            {debugPrint('Error adding credential: ${res.error}')}
          else
            {debugPrint('Credential added: ${res.data}')}
        });
  }

  @override
  void deactivate() {
    super.deactivate();

    authsignal.push.removeCredential().then((res) => {
          if (res.error != null)
            {debugPrint('Error removing credential: ${res.error}')}
          else
            {debugPrint('Credential removed: ${res.data}')}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Logged in!'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    authsignal.push.getChallenge().then((res) => {
                          if (res.error != null)
                            {
                              debugPrint(
                                  'Error getting challenge: ${res.error}')
                            }
                          else
                            {
                              if (res.data != null)
                                {setState(() => _challengeID = res.data)}
                              else
                                {debugPrint('No challenge')}
                            }
                        });
                  },
                  child: const Text('Get challenge'),
                ),
                Text(_challengeID ?? "No challenge"),
                ElevatedButton(
                  onPressed: () {
                    if (_challengeID == null) {
                      return;
                    }

                    authsignal.push
                        .updateChallenge(_challengeID!, true)
                        .then((res) => {
                              if (res.error != null)
                                {
                                  debugPrint(
                                      'Error updating challenge: ${res.error}')
                                }
                            });
                  },
                  child: const Text('Approve challenge'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_challengeID == null) {
                      return;
                    }

                    authsignal.push
                        .updateChallenge(_challengeID!, false)
                        .then((res) => {
                              if (res.error != null)
                                {
                                  debugPrint(
                                      'Error updating challenge: ${res.error}')
                                }
                            });
                  },
                  child: const Text('Reject challenge'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Logout'),
                ),
              ]),
        )));
  }
}
