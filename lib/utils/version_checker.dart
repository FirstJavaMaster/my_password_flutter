import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionChecker {
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

    var localVersionArray = localVersion.replaceAll('v', '').split('.');
    var remoteVersionArray = remoteVersion.replaceAll('v', '').split('.');

    var maxLength = [localVersionArray.length, remoteVersionArray.length].reduce(max);
    for (var i = 0; i < maxLength; i++) {
      int localSubVersion = i < localVersionArray.length ? int.parse(localVersionArray[i]) : 0;
      int remoteSubVersion = i < remoteVersionArray.length ? int.parse(remoteVersionArray[i]) : 0;
      if (localSubVersion == remoteSubVersion) {
        continue;
      }
      if (localSubVersion < remoteSubVersion) {
        return githubReleaseResponse;
      }
    }
    return null;
  }
}

// 后面都是api相关类
class GithubReleaseResponse {
  String? url;
  String? assetsUrl;
  String? uploadUrl;
  String? htmlUrl;
  int? id;
  Author? author;
  String? nodeId;
  String? tagName;
  String? targetCommitish;
  String? name;
  bool? draft;
  bool? prerelease;
  String? createdAt;
  String? publishedAt;
  List<Assets>? assets;
  String? tarballUrl;
  String? zipballUrl;
  String? body;

  GithubReleaseResponse(
      {this.url,
      this.assetsUrl,
      this.uploadUrl,
      this.htmlUrl,
      this.id,
      this.author,
      this.nodeId,
      this.tagName,
      this.targetCommitish,
      this.name,
      this.draft,
      this.prerelease,
      this.createdAt,
      this.publishedAt,
      this.assets,
      this.tarballUrl,
      this.zipballUrl,
      this.body});

  GithubReleaseResponse.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    assetsUrl = json['assets_url'];
    uploadUrl = json['upload_url'];
    htmlUrl = json['html_url'];
    id = json['id'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    nodeId = json['node_id'];
    tagName = json['tag_name'];
    targetCommitish = json['target_commitish'];
    name = json['name'];
    draft = json['draft'];
    prerelease = json['prerelease'];
    createdAt = json['created_at'];
    publishedAt = json['published_at'];
    if (json['assets'] != null) {
      assets = [];
      json['assets'].forEach((v) {
        assets!.add(new Assets.fromJson(v));
      });
    }
    tarballUrl = json['tarball_url'];
    zipballUrl = json['zipball_url'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['assets_url'] = this.assetsUrl;
    data['upload_url'] = this.uploadUrl;
    data['html_url'] = this.htmlUrl;
    data['id'] = this.id;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    data['node_id'] = this.nodeId;
    data['tag_name'] = this.tagName;
    data['target_commitish'] = this.targetCommitish;
    data['name'] = this.name;
    data['draft'] = this.draft;
    data['prerelease'] = this.prerelease;
    data['created_at'] = this.createdAt;
    data['published_at'] = this.publishedAt;
    if (this.assets != null) {
      data['assets'] = this.assets!.map((v) => v.toJson()).toList();
    }
    data['tarball_url'] = this.tarballUrl;
    data['zipball_url'] = this.zipballUrl;
    data['body'] = this.body;
    return data;
  }
}

class Author {
  String? login;
  int? id;
  String? nodeId;
  String? avatarUrl;
  String? gravatarId;
  String? url;
  String? htmlUrl;
  String? followersUrl;
  String? followingUrl;
  String? gistsUrl;
  String? starredUrl;
  String? subscriptionsUrl;
  String? organizationsUrl;
  String? reposUrl;
  String? eventsUrl;
  String? receivedEventsUrl;
  String? type;
  bool? siteAdmin;

  Author(
      {this.login,
      this.id,
      this.nodeId,
      this.avatarUrl,
      this.gravatarId,
      this.url,
      this.htmlUrl,
      this.followersUrl,
      this.followingUrl,
      this.gistsUrl,
      this.starredUrl,
      this.subscriptionsUrl,
      this.organizationsUrl,
      this.reposUrl,
      this.eventsUrl,
      this.receivedEventsUrl,
      this.type,
      this.siteAdmin});

  Author.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    avatarUrl = json['avatar_url'];
    gravatarId = json['gravatar_id'];
    url = json['url'];
    htmlUrl = json['html_url'];
    followersUrl = json['followers_url'];
    followingUrl = json['following_url'];
    gistsUrl = json['gists_url'];
    starredUrl = json['starred_url'];
    subscriptionsUrl = json['subscriptions_url'];
    organizationsUrl = json['organizations_url'];
    reposUrl = json['repos_url'];
    eventsUrl = json['events_url'];
    receivedEventsUrl = json['received_events_url'];
    type = json['type'];
    siteAdmin = json['site_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['avatar_url'] = this.avatarUrl;
    data['gravatar_id'] = this.gravatarId;
    data['url'] = this.url;
    data['html_url'] = this.htmlUrl;
    data['followers_url'] = this.followersUrl;
    data['following_url'] = this.followingUrl;
    data['gists_url'] = this.gistsUrl;
    data['starred_url'] = this.starredUrl;
    data['subscriptions_url'] = this.subscriptionsUrl;
    data['organizations_url'] = this.organizationsUrl;
    data['repos_url'] = this.reposUrl;
    data['events_url'] = this.eventsUrl;
    data['received_events_url'] = this.receivedEventsUrl;
    data['type'] = this.type;
    data['site_admin'] = this.siteAdmin;
    return data;
  }
}

class Assets {
  String? url;
  int? id;
  String? nodeId;
  String? name;
  String? label;
  Author? uploader;
  String? contentType;
  String? state;
  int? size;
  int? downloadCount;
  String? createdAt;
  String? updatedAt;
  String? browserDownloadUrl;

  Assets(
      {this.url,
      this.id,
      this.nodeId,
      this.name,
      this.label,
      this.uploader,
      this.contentType,
      this.state,
      this.size,
      this.downloadCount,
      this.createdAt,
      this.updatedAt,
      this.browserDownloadUrl});

  Assets.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    id = json['id'];
    nodeId = json['node_id'];
    name = json['name'];
    label = json['label'];
    uploader = json['uploader'] != null ? new Author.fromJson(json['uploader']) : null;
    contentType = json['content_type'];
    state = json['state'];
    size = json['size'];
    downloadCount = json['download_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    browserDownloadUrl = json['browser_download_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['name'] = this.name;
    data['label'] = this.label;
    if (this.uploader != null) {
      data['uploader'] = this.uploader!.toJson();
    }
    data['content_type'] = this.contentType;
    data['state'] = this.state;
    data['size'] = this.size;
    data['download_count'] = this.downloadCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['browser_download_url'] = this.browserDownloadUrl;
    return data;
  }
}
