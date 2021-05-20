import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);

class AccountListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AccountListState();
  }
}

class AccountListState extends State<AccountListWidget> {
  var wordList = new List.from(generateWordPairs().take(20));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Password'),
      ),
      body: _buildRowList(),
    );
  }

  Widget _buildRowList() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemCount: wordList.length,
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          // if (i.isOdd) return new Divider();
          return _buildRow(i);
        });
  }

  Widget _buildRow(index) {
    String word = wordList[index].asPascalCase;
    return new ListTile(
      title: new Text(
        index.toString() + "、" + word,
        style: _biggerFont,
      ),
      onTap: () {
        Fluttertoast.showToast(msg: word + " clicked!!");
      },
    );
  }
}
