import 'package:flutter/material.dart';
import "./auth_provider.dart";
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onDefaultUserPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onLogoutPressed;
  final VoidCallback? onMainPagePressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onDefaultUserPressed,
    this.onProfilePressed,
    this.onLoginPressed,
    this.onLogoutPressed,
    this.onMainPagePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoggedIn = context.watch<AuthState>().isAuthorized;

    return AppBar(
      backgroundColor: theme.colorScheme.inversePrimary,
      leading: ClipOval(
        child: Transform.scale(
          scale: 1.6,
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("../web/icons/logo.png"),
                fit: BoxFit.cover,
                alignment: Alignment(-0.2, -0.2),
              ),
            ),
          ),
        ),
      ),
      title: Text(title),
      actions: [
        if (onDefaultUserPressed != null)
          IconButton(
            icon: const Icon(Icons.verified_user),
            onPressed: onDefaultUserPressed,
          ),
        if (isLoggedIn && onProfilePressed != null)
          IconButton(
            icon: const Icon(Icons.account_box_outlined),
            onPressed: onProfilePressed,
          ),
        if (!isLoggedIn && onLoginPressed != null)
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: onLoginPressed,
          ),
        if (isLoggedIn && onLogoutPressed != null)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogoutPressed,
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: onMainPagePressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

