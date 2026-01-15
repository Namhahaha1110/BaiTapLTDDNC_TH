import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _repassController = TextEditingController();

  bool _agree = false;
  bool _hidePass = true;
  bool _hideRePass = true;

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _repassController.dispose();
    super.dispose();
  }

  void _submit() {
    final okForm = _formKey.currentState?.validate() ?? false;
    if (!okForm) return;

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bạn cần đồng ý điều khoản")),
      );
      return;
    }

    // Demo: chỉ hiện thông báo (chưa có backend)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đăng ký OK: user=${_userController.text}")),
    );

    // Quay về Login
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nếu bạn đã có ảnh local, thay bằng Image.asset(...)
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 120,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "REGISTER INFORMATION",
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
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Nhập username";
                      if (v.trim().length < 3)
                        return "Username tối thiểu 3 ký tự";
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      icon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Nhập email";
                      final email = v.trim();
                      if (!email.contains("@") || !email.contains(".")) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _passController,
                    obscureText: _hidePass,
                    decoration: InputDecoration(
                      labelText: "Password",
                      icon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _hidePass = !_hidePass),
                        icon: Icon(
                          _hidePass ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Nhập mật khẩu";
                      if (v.length < 6) return "Mật khẩu tối thiểu 6 ký tự";
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _repassController,
                    obscureText: _hideRePass,
                    decoration: InputDecoration(
                      labelText: "Confirm password",
                      icon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _hideRePass = !_hideRePass),
                        icon: Icon(
                          _hideRePass ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Nhập lại mật khẩu";
                      if (v != _passController.text)
                        return "Mật khẩu không khớp";
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _agree,
                        onChanged: (v) => setState(() => _agree = v ?? false),
                      ),
                      const Expanded(
                        child: Text(
                          "Tôi đồng ý với điều khoản sử dụng",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text("CREATE ACCOUNT"),
                    ),
                  ),

                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to Login"),
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
