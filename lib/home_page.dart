import 'package:flutter/material.dart';
import 'auth.dart';
import 'assesment_page.dart';
import 'login.dart';
import 'signup.dart'; // Import the SignupPage

class HomePage extends StatefulWidget {
  final AuthService authService;

  HomePage({required this.authService});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<bool> isLoggedInFuture; // Declare Future<bool> variable

  @override
  void initState() {
    super.initState();
    isLoggedInFuture =
        widget.authService.isLoggedIn(); // Initialize Future<bool> variable
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedInFuture,
      builder: (context, snapshot) {
        bool isLoggedIn =
            snapshot.data ?? false; // Get boolean value from snapshot

        return Scaffold(
          appBar: AppBar(
            title: Text('Assessment App'),
            backgroundColor: Colors.blue, // Setting app bar color to blue
            actions: [
              // Conditional display of action button based on login status
              if (isLoggedIn)
                TextButton(
                  onPressed: () {
                    widget.authService.logout();
                    setState(
                        () {}); // Refresh the state to reflect logout status
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
                    setState(() {
                      isLoggedInFuture = widget.authService
                          .isLoggedIn(); // Update Future<bool> variable
                    });
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
                backgroundColor: Colors.blue, // Setting text color to white
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
          backgroundColor:
              Colors.blue.shade50, // Setting background color to light blue
        );
      },
    );
  }
}
