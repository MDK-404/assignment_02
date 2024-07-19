//
import 'package:flutter/material.dart';
import 'auth.dart';
import 'assesment_page.dart';
import 'login.dart';
import 'signup.dart';

class HomePage extends StatefulWidget {
  final AuthService authService;

  HomePage({required this.authService});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<bool> isLoggedInFuture;

  @override
  void initState() {
    super.initState();
    isLoggedInFuture = widget.authService.isLoggedIn();
  }

  Future<void> _updateLoginStatus() async {
    setState(() {
      isLoggedInFuture = widget.authService.isLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedInFuture,
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.data ?? false;

        return Scaffold(
          appBar: AppBar(
            title: Text('Assessment App'),
            backgroundColor: Colors.blue,
            actions: [
              if (isLoggedIn)
                TextButton(
                  onPressed: () async {
                    await widget.authService.logout();
                    await _updateLoginStatus(); // Update login status after logout
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              else
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignupPage(authService: widget.authService),
                      ),
                    );
                    await _updateLoginStatus(); // Update login status after signup
                  },
                  child: Text(
                    'Signup',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AssessmentPage(authService: widget.authService),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Take Assessment',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.blue.shade50,
        );
      },
    );
  }
}
