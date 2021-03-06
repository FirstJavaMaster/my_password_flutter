import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/entity/account_binding.dart';
import 'package:my_password_flutter/utils/constants.dart';

import 'account.dart';

class BindingList extends StatefulWidget {
  final int sourceId;

  BindingList(this.sourceId);

  @override
  State<StatefulWidget> createState() {
    return BindingListState(sourceId);
  }
}

class BindingListState extends State<BindingList> {
  // 当前 account ID
  final int sourceId;

  // 现有的account列表
  List<Account> accountList = [];

  // 已过滤的account列表
  List<Account> accountListFilter = [];

  // 已关联的 account 列表
  List<AccountBinding> relationList = [];

  // 选择 account 时的 keyword
  String keyword = '';

  // 构造方法
  BindingListState(this.sourceId);

  @override
  void initState() {
    super.initState();
    DatabaseUtils.getDatabase().then((db) {
      // 先查 account 列表, 再查 relation 列表
      db.accountDao.findAll().then((accountList) {
        this.accountList = accountList;
        db.accountBindingDao.findListBySourceId(sourceId).then((relationList) {
          setState(() {
            this.relationList = relationList;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.sourceId == 0
        ? Center(child: Text('< 请先保存基本信息'))
        : Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: () {
                List<Widget> rowList = [];
                this.relationList.forEach((relation) {
                  var targetAccount = accountList.firstWhere((account) => account.id == relation.targetId);
                  var row = Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        targetAccount.siteName + ' - ' + targetAccount.userName,
                        textScaleFactor: 1.2,
                      ),
                      TextButton(
                        child: Text('移除'),
                        onPressed: () => _deleteRelation(relation),
                        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.red)),
                      )
                    ],
                  );
                  rowList.add(row);
                  rowList.add(Divider());
                });
                rowList.add(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        '点击添加 +',
                        textScaleFactor: 1.1,
                      ),
                      onPressed: () {
                        _filterAccountList();
                        _showDialogOfAccountPick();
                      },
                    ),
                  ],
                ));
                return rowList;
              }(),
            ),
          );
  }

  void _showDialogOfAccountPick() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateOfAccountPickDialog) {
            return Dialog(
              child: Column(
                children: [
                  ListTile(title: () {
                    return TextButton(
                      child: Text(keyword.isEmpty ? '点击筛选 >' : '筛选条件【$keyword】'),
                      onPressed: () {
                        _showDialogOfKeywordPick(setStateOfAccountPickDialog);
                      },
                    );
                  }()),
                  Expanded(
                    child: this.accountListFilter.isEmpty
                        ? Text('~ 空空如也 ~')
                        : ListView.separated(
                            itemCount: accountListFilter.length,
                            itemBuilder: (BuildContext context, int index) {
                              var account = accountListFilter[index];
                              return ListTile(
                                title: Text(account.siteName + ' - ' + account.userName),
                                onTap: () => Navigator.of(context).pop(account.id),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => Divider(),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((targetId) {
      if (targetId == null) {
        return;
      }
      // 添加关联关系
      var relation = AccountBinding(null, sourceId, targetId, '');
      DatabaseUtils.getDatabase().then((db) {
        db.accountBindingDao.add(relation).then((id) {
          setState(() {
            relation.id = id;
            relationList.add(relation);
          });
          _relationChanged();
          Fluttertoast.showToast(msg: '关联成功');
        });
      });
    });
  }

  // 过滤account列表
  void _filterAccountList() {
    var excludeIdSet = relationList.map((e) => e.targetId).toSet();
    excludeIdSet.add(sourceId);

    var accountListFilter = accountList.where((account) {
      if (excludeIdSet.contains(account.id)) {
        return false;
      }
      if (keyword.isEmpty) {
        return true;
      }
      return keyword == account.getTagChar();
    }).toList();
    setState(() {
      this.accountListFilter = accountListFilter;
    });
  }

  void _showDialogOfKeywordPick(StateSetter setStateOfAccountPickDialog) {
    // 提供一个不过滤的选择
    String noFilter = "-";
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('选择', textAlign: TextAlign.center),
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: () {
                // 把所有选择放在一起
                var pickArrays = [noFilter];
                pickArrays.addAll(Constants.keywordList);
                return pickArrays.map((keyword) {
                  return TextButton(
                    child: Text(
                      keyword,
                      textScaleFactor: 1.2,
                    ),
                    onPressed: () => Navigator.of(context).pop(keyword),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(1, 1)),
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                    ),
                  );
                }).toList();
              }(),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == null) {
        return;
      }
      if (value == noFilter) {
        value = '';
      }
      setStateOfAccountPickDialog(() {
        this.keyword = value;
        _filterAccountList();
      });
    });
  }

  void _deleteRelation(AccountBinding relation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('确定要移除此关联关系吗?'),
          actions: [
            TextButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('移除', style: TextStyle(color: Colors.red)),
              onPressed: () {
                DatabaseUtils.getDatabase().then((db) {
                  db.accountBindingDao.deleteByEntity(relation).then((value) {
                    setState(() {
                      relationList = relationList.where((element) => element.id != relation.id).toList();
                      Navigator.of(context).pop(true);
                    });
                    _relationChanged();
                    Fluttertoast.showToast(msg: '移除成功');
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  /// 账号绑定关系变化时调用此方法
  void _relationChanged() {
    // 通知父组件
    IdChangeNotification(this.sourceId).dispatch(context);
  }
}
