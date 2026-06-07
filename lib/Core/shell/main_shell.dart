import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = ['/home', '/tags', '/search', '/settings'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _tabs.indexWhere((t) => location.startsWith(t));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TabItem(
              icon: Icons.home_outlined,
              label: 'Home',
              path: '/home',
              context: context,
            ),
            _TabItem(
              icon: Icons.label_outlined,
              label: 'Tags',
              path: '/tags',
              context: context,
            ),
            const SizedBox(width: 48),
            _TabItem(
              icon: Icons.label_outlined,
              label: 'Tags',
              path: '/tags',
              context: context,
            ),
            _TabItem(
              icon: Icons.search,
              label: 'Search',
              path: '/search',
              context: context,
            ),
            _TabItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              path: '/settings',
              context: context,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('add'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final BuildContext context;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.context,
  });
  @override
  Widget build(BuildContext buildContext) {
    final location = GoRouterState.of(context).uri.toString();
    final isActive = location.startsWith(path);
    return InkWell(
      onTap: () => context.go(path),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
