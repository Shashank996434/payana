import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cproject/pages/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  bool isLoading = false;
  String errorMessage = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/register.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.black),
          title: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Create Your Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField("Agency Name", (val) => name = val,
                            validator: (val) =>
                            val!.isEmpty ? 'Enter your name' : null),
                        const SizedBox(height: 12),
                        _buildTextField("Email", (val) => email = val,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) =>
                            val!.isEmpty ? 'Enter your email' : null),
                        const SizedBox(height: 12),
                        _buildTextField("Password", (val) => password = val,
                            obscureText: true,
                            validator: (val) =>
                            val!.isEmpty ? 'Enter your password' : null),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _signUp,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF273671)),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Text("Register",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        if (errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(errorMessage,
                                style: const TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("or Sign Up with",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF273671),
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon("assets/google.png", _signInWithGoogle),
                      const SizedBox(width: 24),
                      _socialIcon("assets/apple.png", _signInWithApple),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          );
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, Function(String) onChanged,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator}) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _socialIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath, height: 50, width: 50),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      try {
        // Check if agency name already exists
        final existingAgency = await _firestore
            .collection('agencies')
            .where('name', isEqualTo: name.trim())
            .get();

        if (existingAgency.docs.isNotEmpty) {
          setState(() {
            errorMessage = 'Agency name already exists.';
            isLoading = false;
          });
          return;
        }

        // Create account
        final userCred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        // Store agency data
        await _firestore.collection('agencies').add({
          'name': name.trim(),
          'email': email.trim(),
          'created_at': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message ?? 'Something went wrong';
        });
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      setState(() => errorMessage = "Google sign-in failed");
    }
  }

  Future<void> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      setState(() => errorMessage = "Apple sign-in failed");
    }
  }
}
