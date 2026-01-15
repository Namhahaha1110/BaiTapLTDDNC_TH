import 'package:flutter/material.dart';
import 'login.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.network(
              // link ảnh giống mẫu bạn đưa (có thể thay link khác)
              "https://st4.depositphotos.com/1010735/21836/v/450/depositphotos_218363620-stock-illustration-autumn-welcome-sign-colorful-maple.jpg",
              height: 150,
            ),
            const SizedBox(height: 32),
            const Text(
              "Welcome to Flutter",
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "My name is Lê Hoàng Nam\nStudent Code: 23DH114467",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.orange),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                fixedSize: const Size(150, 70),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
