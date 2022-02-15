import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/bo/github_release_response.dart';
import 'package:my_password_flutter/bo/version_comparer.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckUtils {
  static final String _remoteVersionCheckApi = "https://api.github.com/repos/FirstJavaMaster/my_password_flutter/releases/latest";

  // 检查更新
  // 常规版: 整个检查流程都有提示
  static Future<void> check(BuildContext context) async {
    // 展示等待对话框
    SmartDialog.showLoading(msg: '检查中...');
    // 对比版本
    try {
      GithubReleaseResponse? githubReleaseResponse = await _findNewVersion();
      if (githubReleaseResponse == null) {
        SmartDialog.showToast('已经是最新版本');
      } else {
        _showNewVersion(context, githubReleaseResponse);
      }
    } catch (error) {
      SmartDialog.showToast('检查失败 ${error.toString()}');
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  // 检查更新
  // 安静版: 只在有新版本时才有提示, 否则没有其他任何提示
  static Future<void> checkQuiet(BuildContext context) async {
    try {
      GithubReleaseResponse? githubReleaseResponse = await _findNewVersion();
      if (githubReleaseResponse != null) {
        _showNewVersion(context, githubReleaseResponse);
      }
    } catch (dioError) {
      print(dioError);
    }
  }

  // 提示升级
  static _showNewVersion(BuildContext context, GithubReleaseResponse githubReleaseResponse) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("发现新版本")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(githubReleaseResponse.tagName.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
              Text(githubReleaseResponse.body.toString()),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("将来再说", style: TextStyle(color: Colors.black38)),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text("前往下载"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
                String urlString = githubReleaseResponse.htmlUrl ?? '';
                canLaunch(urlString).then((value) => value ? launch(urlString) : Fluttertoast.showToast(msg: '地址错误: $urlString'));
              },
            ),
          ],
        );
      },
    );
  }

  // 根据传入的两个版本号比较大小. 当且仅当remoteVersion版本高于localVersion时返回新版本信息
  static Future<GithubReleaseResponse?> _findNewVersion() async {
    // 本地版本
    var packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    // 远程版本
    var response = await Dio().get(_remoteVersionCheckApi);
    var githubReleaseResponse = GithubReleaseResponse.fromJson(json.decode(response.toString()));
    String remoteVersion = githubReleaseResponse.tagName ?? '';
    if (remoteVersion.isEmpty) {
      Fluttertoast.showToast(msg: '获取新版本失败');
      print('获取新版本失败:\n$response');
    }
    // 比较
    if (VersionComparer(localVersion).compareTo(VersionComparer(remoteVersion)) >= 0) {
      return null;
    } else {
      return githubReleaseResponse;
    }
  }
}
