import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import '../providers/auth.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

enum AuthMode { login, signup }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> key = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authMap = {'username': '', 'password': ''};
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: _deviceSize.width * 0.05),
      elevation: 8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.login
            ? _deviceSize.height * 0.32
            : _deviceSize.height * 0.4,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authMap['username'] = val!;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'too short';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authMap['password'] = val!;
                  },
                ),
                if (_authMode == AuthMode.signup)
                  AnimatedContainer(
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.signup ? 120 : 0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.signup,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'Consfirm Password'),
                        validator: _authMode == AuthMode.signup
                            ? (value) {
                                if (value! != _passwordController.text) {
                                  return "passwords doesn't match";
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(300, 50),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          _authMode == AuthMode.login ? 'Login' : 'SignUp',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _authMode = _authMode == AuthMode.login
                            ? AuthMode.signup
                            : AuthMode.login;
                      });
                    },
                    child: Text(_authMode == AuthMode.login
                        ? "Doesn't have an account?"
                        : 'Already have an account?'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit() async {
    if (!key.currentState!.validate()) return;
    key.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authMap['username']!, _authMap['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authMap['username']!, _authMap['password']!);
      }
    } on HttpException {
      print('');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
