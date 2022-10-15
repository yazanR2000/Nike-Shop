import 'package:flutter/material.dart';
import '../providers/auth.dart' as a;

enum AuthState { Login, Signup }

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  AuthState _authState = AuthState.Login;
  late FocusNode myFocusNode;

  final Map<String, String?> _user = {
    "email": null,
    "password": null,
  };

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  Future _tryToLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isWaiting = !_isWaiting;
      });
      if (_authState == AuthState.Login) {
        await a.Auth.tryToLogin(_user['email']!, _user['password']!, context);
      } else {
        await a.Auth.tryToSignup(_user['email']!, _user['password']!, context);
      }
      setState(() {
        _isWaiting = !_isWaiting;
      });
    }
  }

  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "images/logo.png",
                    height: 150,
                    width: 170,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user['email'] = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 5) {
                        return "Your Password should be at least 5 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user['password'] = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.password),
                    ),
                    textInputAction: _authState == AuthState.Login
                        ? TextInputAction.done
                        : TextInputAction.next,
                    obscureText: true,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                //Spacer(),
                if (_isWaiting)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!_isWaiting)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: _tryToLogin,
                          child: Text(
                            _authState == AuthState.Login ? "Login" : "Signup",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                // const SizedBox(
                //   height: 10,
                // ),
                if (!_isWaiting)
                  Row(
                    children: [
                      Text(_authState == AuthState.Login
                          ? "Don't have an account ? "
                          : "Already have an account"),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _authState = _authState == AuthState.Login
                                ? AuthState.Signup
                                : AuthState.Login;
                          });
                        },
                        child: Text(
                            _authState == AuthState.Login ? "Signup" : "Login"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
