import 'package:flutter/material.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _chkRemember = false;

  final _userController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // validate giống Register: trống => báo lỗi ngay dưới ô input
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    // hợp lệ mới hiện OK
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "OK | remember=$_chkRemember | user=${_userController.text.trim()}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tuan_01")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nếu bạn muốn tránh 404 thì dùng Image.asset sau khi add assets
                  Image.network(
                    "https://icons.veryicon.com/png/miscellaneous/two-color-icon-library/user-286.png",
                    height: 250,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.account_circle, size: 120);
                    },
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "LOGIN INFORMATION",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: "User name",
                      icon: Icon(Icons.account_circle),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? "";
                      if (v.isEmpty) return "Vui lòng nhập User name";
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.key),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? "";
                      if (v.isEmpty) return "Vui lòng nhập Password";
                      if (v.length < 6) return "Password tối thiểu 6 ký tự";
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Checkbox(
                        value: _chkRemember,
                        onChanged: (value) {
                          setState(() => _chkRemember = value ?? false);
                        },
                      ),
                      const Text(
                        "Remember me",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Forgot Password tapped"),
                            ),
                          );
                        },
                        child: const Text("Forgot Password"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _onLogin,
                      child: const Text("OK"),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Register()),
                          );
                        },
                        child: const Text("Register"),
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
}
