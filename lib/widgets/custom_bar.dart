import 'package:flutter/material.dart';

class CustomBar extends StatelessWidget implements PreferredSizeWidget {
  final String appTitle;
  final List<Widget> act;
  final bool implyLeading;

  CustomBar({
    @required this.appTitle,
    this.act,
    this.implyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppBar(
        automaticallyImplyLeading: implyLeading,
        centerTitle: true,
        title: Text(
          appTitle,
          style: TextStyle(
            fontFamily: "Anton",
            fontSize: 25,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: act,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
