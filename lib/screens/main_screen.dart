import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../services/app_data_service.dart';
import 'home_screen.dart';
import 'cases_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int index;
  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  final screens = const [
    HomeScreen(),
    CasesScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataService>(
      builder: (context, data, _) {
        final unreadMessages = data.totalUnreadMessages;
        return Scaffold(
          body: IndexedStack(index: index, children: screens),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) => setState(() => index = value),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.blue,
            unselectedItemColor: AppColors.slate,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                activeIcon: Icon(Icons.work),
                label: 'Mis casos',
              ),
              BottomNavigationBarItem(
                icon: _MessageBadge(count: unreadMessages, active: false),
                activeIcon: _MessageBadge(count: unreadMessages, active: true),
                label: 'Mensajes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageBadge extends StatelessWidget {
  final int count;
  final bool active;
  const _MessageBadge({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(active ? Icons.chat_bubble : Icons.chat_bubble_outline),
        if (count > 0)
          Positioned(
            right: -8,
            top: -5,
            child: Container(
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
