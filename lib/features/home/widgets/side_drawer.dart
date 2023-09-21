import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zilogic/common/loading_page.dart';
import 'package:zilogic/features/auth/controller/auth_controller.dart';
import 'package:zilogic/features/user_profile/view/user_profile_view.dart';
import 'package:zilogic/features/zconnect/view/zconnect_view.dart';
import 'package:zilogic/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 25,
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  UserProfileView.route(currentUser),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.article,
                size: 25,
              ),
              title: const Text(
                'ZConnect',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(context, ZConnectView.route());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 25,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
