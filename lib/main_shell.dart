import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'data/materials_repository.dart';
import 'explore_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';
import 'widgets/app_bottom_nav.dart';

/// Root shell: tabbed Home / Library / Explore / Profile with shared bottom nav.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.materialsRepository});

  final MaterialsRepository? materialsRepository;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tabIndex = 0;
  late final MaterialsRepository _materialsRepo;

  @override
  void initState() {
    super.initState();
    _materialsRepo =
        widget.materialsRepository ?? MaterialsRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _tabIndex,
        children: [
          const HomeDashboardPage(),
          LibraryScreen(repository: _materialsRepo),
          const ExploreScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
    );
  }
}
