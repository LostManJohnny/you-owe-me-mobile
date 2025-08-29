import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_owe_us/bloc/auth/auth_bloc.dart';
import 'package:you_owe_us/domain/auth/user_profile.dart';
import 'package:you_owe_us/style/theme/theme_text_styles.dart';

import '../../app_config.dart';
import '../di.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  DrawerViewState createState() => DrawerViewState();
}

class DrawerViewState extends State<DrawerView> {
  final appConfig = c<AppConfig>();
  String? _version;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final packageInfo = await appConfig.packageInfo;
    if (!mounted) return;
    setState(() => _version = packageInfo.version);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select<AuthBloc, UserProfile?>((b) => b.state.userProfile);

    return Drawer(
      child: ListView(
        children: [
          Center(
            child: Text(
              appConfig.appName,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Fira Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text('Version : ${_version ?? "..."}',
                style: TextStyleTheme.drawerVersion),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Text(
                'Hello ${profile?.username ?? "..."}!',
                style: TextStyleTheme.drawerWelcome,
              ),
            ),
          ),
          const Divider(indent: 10, endIndent: 10, thickness: 2),
        ],
      ),
    );
  }
}
