import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gimme_job/constants.dart';
import 'package:gimme_job/screens/authenticate.dart';
import 'package:gimme_job/services/auth_service.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return FutureBuilder(
      future: _firebaseApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            initialData: null,
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Error: ${streamSnapshot.error}',
                    ),
                  ),
                );
              }

              if (streamSnapshot.connectionState == ConnectionState.active) {
                final _user = streamSnapshot.data;
                print(_user);
                if (_user == null) {
                  return Authenticate();
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Login already la'),
                      actions: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _auth.signOut();
                          },
                          icon: Icon(Icons.person),
                          label: Text('Logout'),
                        ),
                      ],
                    ),
                  );
                }
              }
              // Checking the auth state - Loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        // Connecting to Firebase - Loading
        return Scaffold(
          body: Center(
            child: Text(
              "Initialization App...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
