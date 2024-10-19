// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:live_streaming/pages/auth/login.dart';
import 'package:live_streaming/pages/live_page.dart';
import 'package:live_streaming/services/auth_service.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  /// Users who use the same liveID can join the same live streaming.
  final liveTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());

  /// Get the current Firebase user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the current Firebase user
    User? user = getCurrentUser();
    String displayName = user?.displayName ?? "No Name";
    String email = user?.email ?? "No Email";
    String userID = user?.uid ?? "No ID";
    String photoURL = user?.photoURL ?? "";

    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(150, 50),
      backgroundColor: Colors.orangeAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    // Jump to the live page

    void jumpToLivePage(BuildContext context,
        {required String liveID, required bool isHost}) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LivePage(liveID: liveID, isHost: isHost),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FluttLive',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();

              // Navigate to LoginPage after signing out
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthService().getCurrentUser() != null
                      ? HomePage()
                      : LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Avatar and Firebase User Info
              CircleAvatar(
                backgroundImage: NetworkImage(photoURL),
                radius: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome, $displayName',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Email: $email',
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'User ID: $userID',
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              Divider(),

              // Description Section
              const Text(
                'Welcome to FluttLive! Start a new live stream or join an ongoing one by entering a live ID.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              // Live ID Input Field
              TextFormField(
                controller: liveTextCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white12,
                  labelText: 'Enter Live ID',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white38),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Start and Join Live Stream Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      if (ZegoUIKitPrebuiltLiveStreamingController()
                          .minimize
                          .isMinimizing) {
                        // Prevent multiple instances when minimized
                        return;
                      }

                      jumpToLivePage(
                        context,
                        liveID: liveTextCtrl.text.trim(),
                        isHost: true,
                      );
                    },
                    child: const Text(
                      'Start a Live',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      if (ZegoUIKitPrebuiltLiveStreamingController()
                          .minimize
                          .isMinimizing) {
                        return;
                      }

                      jumpToLivePage(
                        context,
                        liveID: liveTextCtrl.text.trim(),
                        isHost: false,
                      );
                    },
                    child: const Text(
                      'Join a Live',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Instruction for Testing
              const Text(
                'Please test with two or more devices to simulate live streaming.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
