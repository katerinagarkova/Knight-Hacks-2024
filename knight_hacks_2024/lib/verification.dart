import 'package:flutter/material.dart';

import 'main.dart';
import 'token.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    super.initState();
    // Call sendVerification when the page is initialized
  }

  void _handleSubmit(BuildContext context) async {
    try {
      await verifyUser(emailVerify, code);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // Set background color to red
          content: Center(
            child: Text(
              '$e', // Convert the error to a string to display
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          duration: const Duration(seconds: 5), // Adjust the duration as needed
        ),
      );
      Future.delayed(Duration(seconds: 5), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15), // Added SizedBox
              Align(
                alignment: Alignment.center,
                child: Text(
                  'BloomBuddy',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 53,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ), // Added Align
              const SizedBox(height: 30.0),
              Center(
                child: Text(
                  "Send Verification Link to $emailVerify:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign
                      .center, // Optional, to center the text within its container
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () => _handleSubmit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14532d).withBlue(255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                ),
                child: const SizedBox(
                  width: 350,
                  child: Text(
                    'Send Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
