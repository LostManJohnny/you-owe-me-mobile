import 'package:flutter/material.dart';
import '../style/theme/theme_text_styles.dart';
import 'drawer.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final bool? showDrawer;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? leading;
  final Widget? bottomNavigationBar;

  const CommonScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showDrawer = true,
    this.actions,
    this.floatingActionButton,
    this.leading,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyleTheme.screenTitle,
        ),
        actions: actions,
        leading: leading,
      ),
      drawer: showDrawer! ? DrawerView() : null,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButton != null ? FloatingActionButtonLocation.centerFloat : null,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
