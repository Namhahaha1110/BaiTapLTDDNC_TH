import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiExampleWidget extends StatefulWidget {
  const ApiExampleWidget({super.key});

  @override
  State<ApiExampleWidget> createState() => _ApiExampleWidgetState();
}

class _ApiExampleWidgetState extends State<ApiExampleWidget> {
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _user;
  final Random _random = Random();
  int _totalUsers = 0;
  int? _lastSkip;

  Future<int> _fetchTotalUsers() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/users?limit=1&skip=0'),
    );

    if (response.statusCode != 200) {
      return 0;
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final total = data['total'];

    if (total is int) {
      return total;
    }

    if (total is String) {
      return int.tryParse(total) ?? 0;
    }

    return 0;
  }

  Future<void> _fetchUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_totalUsers <= 0) {
        _totalUsers = await _fetchTotalUsers();
      }

      if (_totalUsers <= 0) {
        throw Exception('Không lấy được số lượng user từ API');
      }

      int skip = _random.nextInt(_totalUsers);
      if (_totalUsers > 1) {
        while (skip == _lastSkip) {
          skip = _random.nextInt(_totalUsers);
        }
      }

      final response = await http.get(
        Uri.parse('https://dummyjson.com/users?limit=1&skip=$skip'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final users = data['users'];

        if (users is! List || users.isEmpty || users.first is! Map) {
          throw Exception('Dữ liệu user trả về không hợp lệ');
        }

        final user = Map<String, dynamic>.from(users.first as Map);
        final total = data['total'];

        if (total is int) {
          _totalUsers = total;
        }

        _lastSkip = skip;

        setState(() {
          _user = user;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Lỗi API: HTTP ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Không thể gọi API: $e';
        _isLoading = false;
      });
    }
  }

  String _fullName(Map<String, dynamic> user) {
    final firstName = (user['firstName'] ?? '').toString();
    final lastName = (user['lastName'] ?? '').toString();
    return '$firstName $lastName'.trim();
  }

  String _address(Map<String, dynamic> user) {
    final rawAddress = user['address'];
    if (rawAddress is! Map<String, dynamic>) {
      return 'Không có';
    }

    final street = (rawAddress['address'] ?? '').toString();
    final city = (rawAddress['city'] ?? '').toString();
    final state = (rawAddress['state'] ?? '').toString();
    final country = (rawAddress['country'] ?? '').toString();

    return [
      street,
      city,
      state,
      country,
    ].where((item) => item.trim().isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : _fetchUser,
          child: const Text('Gọi API'),
        ),
        const SizedBox(height: 8),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
        if (_error != null)
          Text(
            _error!,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (!_isLoading && _error == null && _user != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kết quả: #${(_user!['id'] ?? '').toString()} - ${_fullName(_user!)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Email: ${(_user!['email'] ?? '').toString()}'),
              Text('Username: ${(_user!['username'] ?? '').toString()}'),
              Text('SĐT: ${(_user!['phone'] ?? '').toString()}'),
              Text('Tuổi: ${(_user!['age'] ?? '').toString()}'),
              Text('Giới tính: ${(_user!['gender'] ?? '').toString()}'),
              Text(
                'Địa chỉ: ${_address(_user!)}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
      ],
    );
  }
}
