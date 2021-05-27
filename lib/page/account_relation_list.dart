import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/entity/account_relation.dart';
import 'package:my_password_flutter/utils/constants.dart';

class AccountRelationList extends StatefulWidget {
  final int sourceId;

  AccountRelationList(this.sourceId);

  @override
  State<StatefulWidget> createState() {
    return AccountRelationListState(sourceId);
  }
}

class AccountRelationListState extends State<AccountRelationList> {
  // 当前 account ID
  final int sourceId;

  // 现有的account列表
  List<Account> accountList = [];

  // 已关联的 account 列表
  List<AccountRelation> relationList = [];

  // 选择 account 时的 keyword
  String keyword = '';

  // 构造方法
  AccountRelationListState(this.sourceId);

  @override
  void initState() {
    super.initState();
    DatabaseUtils.getDatabase().then((db) {
      // 先查 account 列表, 再查 relation 列表
      db.accountDao.findAll().then((accountList) {
        this.accountList = accountList;
        db.accountRelationDao.findListBySourceId(sourceId).then((relationList) {
          setState(() {
            print('查询关系列表 $relationList');
            this.relationList = relationList;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: () {
        var divider = Divider();
        List<Widget> rowList = [];
        this.relationList.forEach((relation) {
          if (rowList.isNotEmpty) {
            rowList.add(divider);
          }
          var targetAccount = accountList.firstWhere((account) => account.id == relation.target_id);
          var row = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                targetAccount.site_name + ' - ' + targetAccount.user_name,
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
        });
        // 添加最后一个下划线和按钮
        if (rowList.isNotEmpty) {
          rowList.add(divider);
        }
        rowList.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                '点击添加 +',
                textScaleFactor: 1.1,
              ),
              onPressed: () {
                _showDialogOfAccountPick();
              },
            ),
          ],
        ));
        return rowList;
      }(),
    );
  }

  void _showDialogOfAccountPick() {
    _filterAccountList().then((accountListFilter) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [
                ListTile(title: () {
                  return TextButton(
                    child: Text(keyword.isEmpty ? '点我筛选 >' : '筛选条件【$keyword】 >'),
                    onPressed: () {
                      _showDialogOfKeywordPick();
                    },
                  );
                }()),
                Expanded(
                  child: ListView.builder(
                    itemCount: accountListFilter.length,
                    itemBuilder: (BuildContext context, int index) {
                      var account = accountListFilter[index];
                      return ListTile(
                        title: Text(account.id.toString() + '、' + account.site_name),
                        onTap: () => Navigator.of(context).pop(account.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ).then((targetId) {
        if (targetId == null) {
          return;
        }
        // 添加关联关系
        var relation = AccountRelation(null, sourceId, targetId, '');
        DatabaseUtils.getDatabase().then((db) {
          db.accountRelationDao.add(relation).then((id) {
            setState(() {
              relation.id = id;
              relationList.add(relation);
            });
          });
        });
      });
    });
  }

  // 过滤account列表
  Future<List<Account>> _filterAccountList() async {
    var excludeIdSet = relationList.map((e) => e.target_id).toSet();
    excludeIdSet.add(sourceId);

    return accountList.where((account) {
      if (excludeIdSet.contains(account.id)) {
        return false;
      }
      if (keyword.isEmpty) {
        return true;
      }
      if (keyword == Constants.keywordNo) {
        return RegExp(r'[0-9]').hasMatch(account.site_pin_yin_name);
      } else {
        return account.site_pin_yin_name.startsWith(keyword.toUpperCase()) || account.site_pin_yin_name.startsWith(keyword.toLowerCase());
      }
    }).toList();
  }

  void _showDialogOfKeywordPick() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [
                ListTile(title: Text('选择keyword')),
                Expanded(child: Text('abc')),
              ],
            ),
          );
        }).then((value) => print(value));
  }

  void _deleteRelation(AccountRelation relation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('确定要删除此关联关系吗?'),
          actions: [
            TextButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('删除', style: TextStyle(color: Colors.red)),
              onPressed: () {
                DatabaseUtils.getDatabase().then((db) {
                  db.accountRelationDao.deleteByEntity(relation).then((value) {
                    setState(() {
                      relationList = relationList.where((element) => element.id != relation.id).toList();
                      Navigator.of(context).pop(true);
                    });
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }
}
