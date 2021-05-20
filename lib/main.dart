import 'package:flutter/material.dart';
import 'package:my_password_flutter/page/cart_page.dart';
import 'package:my_password_flutter/page/home_page.dart';
import 'package:my_password_flutter/page/msg_page.dart';
import 'package:my_password_flutter/page/person_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new FramePage(),
    );
  }
}

class FramePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FrameState();
  }
}

class FrameState extends State<FramePage> {
  // 导航栏项目
  final List<BottomNavigationBarItem> bottomItemList = [
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.home),
      label: "首页",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.green,
      icon: Icon(Icons.message),
      label: "消息",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.amber,
      icon: Icon(Icons.shopping_cart),
      label: "购物车",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.red,
      icon: Icon(Icons.person),
      label: "个人中心",
    )
  ];
  final pages = [HomePage(), MsgPage(), CartPage(), PersonPage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('底部导航栏'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomItemList,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          if (index != currentIndex) {
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
      body: pages[currentIndex],
    );
  }
}
