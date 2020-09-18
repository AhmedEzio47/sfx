import 'package:flutter/material.dart';

class BuildDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  @override
  Widget build(BuildContext context) {
    return buildDrawer(context);
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/bookmarks');
            },
            title: Text(
              'Bookmarks',
            ),
            leading: Icon(
              Icons.bookmark_border,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
              //Navigator.pop(context);
            },
            title: Text(
              'Settings',
            ),
            leading: Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
    );
  }
}
