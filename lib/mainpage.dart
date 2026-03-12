import 'dart:io';
import 'package:flutter/material.dart';

import 'page/defaultwidget.dart';
import 'page/home_dashboard.dart';
import 'page/register.dart';
import 'page/login.dart';
import 'page/info_tab.dart';
import 'page/product_list_screen.dart';
import 'page/product_grid_screen.dart';
import 'page/product_table_screen.dart';
import 'page/firebase_category_manager_screen.dart';
import 'page/firebase_product_list_screen.dart';
import 'page/firebase_product_manager_screen.dart';
import 'state/api_example_widget.dart';
import 'state/counter_bloc_widget.dart';
import 'state/counter_getx_widget.dart';
import 'state/counter_inherited_widget.dart';
import 'state/counter_mobx_widget.dart';
import 'state/counter_provider_widget.dart';
import 'state/counter_redux_widget.dart';
import 'state/counter_riverpod_widget.dart';
import 'state/counter_stateful_widget.dart';
import 'state/session.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  int _selectedDemoIndex = 0;

  static const List<String> _demoTitles = [
    'StatefulWidget',
    'Provider',
    'GetX',
    'Riverpod',
    'Bloc/Cubit',
    'InheritedWidget',
    'MobX',
    'Redux',
    'API',
  ];

  Widget _buildDemoWidget(int index) {
    switch (index) {
      case 0:
        return const CounterStatefulWidget();
      case 1:
        return const CounterProviderWidget();
      case 2:
        return CounterGetXWidget();
      case 3:
        return const CounterRiverpodWidget();
      case 4:
        return const CounterBlocWidget();
      case 5:
        return const CounterInheritedWidget();
      case 6:
        return const CounterMobXWidget();
      case 7:
        return CounterReduxWidget();
      case 8:
        return const ApiExampleWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  void _safeSetIndex(int i, int max) {
    if (i < 0) i = 0;
    if (i > max) i = 0;
    _selectedIndex = i;
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;

    // ✅ CHỈ HIỆN INFO KHI: có user và KHÔNG phải guest
    final showInfo = user != null && !session.isGuest;

    final headerName = user?.fullname ?? 'Guest';
    final headerEmail = user?.email ?? '—';

    final avatarPath =
        session.avatarPath; // ✅ avatar hiện tại (null nếu chưa có / guest)

    final pages = <Widget>[
      HomeDashboard(),
      const DefaultWidget(title: 'Contact'),
      showInfo ? const InfoTab() : const RegisterPage(),
    ];

    final navItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.contact_mail),
        label: 'Contact',
      ),
      BottomNavigationBarItem(
        icon: Icon(showInfo ? Icons.supervised_user_circle : Icons.person_add),
        label: showInfo ? 'Info' : 'Register',
      ),
    ];

    _safeSetIndex(_selectedIndex, pages.length - 1);

    return Scaffold(
      appBar: AppBar(title: const Text('My App Navigator')),

      // ================= DRAWER =================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: (avatarPath != null)
                        ? FileImage(File(avatarPath))
                        : null,
                    child: (avatarPath == null)
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    headerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    headerEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            ListTile(
              leading: Icon(
                showInfo ? Icons.supervised_user_circle : Icons.person_add,
              ),
              title: Text(showInfo ? 'Info' : 'Register'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.cloud, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Firebase Firestore',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.orange),
              title: const Text('Quản lý danh mục (Firebase)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirebaseCategoryManagerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2, color: Colors.orange),
              title: const Text('Quản lý sản phẩm (Firebase)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirebaseProductManagerScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.view_list, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Hiển thị sản phẩm',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.blue),
              title: const Text('Sản phẩm SQLite (List)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.amber),
              title: const Text('Sản phẩm Firebase (List)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirebaseProductListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on, color: Colors.blue),
              title: const Text('Sản phẩm SQLite (Grid)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductGridScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_rows, color: Colors.blue),
              title: const Text('Sản phẩm SQLite (Table)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductTableScreen()),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.developer_board, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'State & API',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Chọn một phương pháp quản lý state hoặc demo API để xem ví dụ trực tiếp.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          _demoTitles.length,
                          (i) => ChoiceChip(
                            label: Text(_demoTitles[i]),
                            selected: _selectedDemoIndex == i,
                            selectedColor: Colors.blue.shade100,
                            onSelected: (_) {
                              setState(() {
                                _selectedDemoIndex = i;
                              });
                            },
                          ),
                        ),
                      ),
                      const Divider(height: 22),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _buildDemoWidget(_selectedDemoIndex),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                session.logout();
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: pages[_selectedIndex],

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: navItems,
      ),
    );
  }
}
