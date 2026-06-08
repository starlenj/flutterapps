import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/Core/shell/main_shell.dart';
import 'package:todoapp/Features/Bookmark/ui/bookmark_add_page.dart';
import 'package:todoapp/Features/Bookmark/ui/bookmark_detail_page.dart';
import 'package:todoapp/Features/Bookmark/ui/bookmark_list_page.dart';
import 'package:todoapp/Features/Home/ui/home_page.dart';
import 'package:todoapp/Features/Search/ui/search_page.dart';
import 'package:todoapp/Features/Settings/ui/settings_page.dart';
import 'package:todoapp/Features/Tags/ui/tags_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: ((context, state, child) => MainShell(child: child)),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/tags',
            name: 'tags',
            builder: (context, state) => const TagsPage(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const BookmarkListPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: ((context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BookmarkDetailPage(bookmarkId: id);
        }),
      ),
      GoRoute(
        path: '/add',
        name: 'add',
        builder: ((context, state) {
          final url = state.uri.queryParameters['url'];
          return BookmarkAddPage(initialUrl: url);
        }),
      ),
    ],
  );
});
