import 'package:flutter/material.dart';
import 'package:instagram_clone/enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;
  BottomNavBar({this.items, this.selectedItem, this.onTap});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: BottomNavItem.values.indexOf(selectedItem),
      items: items
          .map(
            (item, icon) => MapEntry(
              item.toString(),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(icon, size: 30),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
