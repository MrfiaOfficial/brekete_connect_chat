import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class ViewFile extends StatefulWidget {
  final String? fileUrl;
  final String? extensions;
  final String? name;
  final String? size;
  final TargetPlatform? platform;

  ViewFile({
    Key? key,
    required this.fileUrl,
    required this.name,
    required this.extensions,
    required this.size,
    required this.platform,
  }) : super(key: key);

  @override
  _ViewFileState createState() => _ViewFileState();
}

class _ViewFileState extends State<ViewFile> {
  late String _localPath;
  ReceivePort _port = ReceivePort();
  String? id;
  int? progress;
  String? taskId;

  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
  @override
  void initState() {
    super.initState();
    _prepareSaveDir();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _bindBackgroundIsolate() async {
    final tasks = await FlutterDownloader.loadTasks();
    tasks!.forEach((task) {
      status = task.status;
      taskId = task.taskId;
    });
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {
        id = data[0];
        status = data[1];
        progress = data[2];
      });
    });
  }

  static String _prettyCountInt(String nums) {
    int bytes = int.parse(nums);
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }

  void _requestDownload() async {
    taskId = await FlutterDownloader.enqueue(
      url: widget.fileUrl.toString(),
      savedDir: _localPath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  void _pauseDownload() async {
    await FlutterDownloader.pause(taskId: taskId!);
  }

  void _resumeDownload() async {
    String? newTaskId = await FlutterDownloader.resume(taskId: taskId!);
    taskId = newTaskId;
  }

  void _retryDownload() async {
    String? newTaskId = await FlutterDownloader.retry(taskId: taskId!);
    taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile() {
    if (taskId != null) {
      return FlutterDownloader.open(taskId: taskId!);
    } else {
      return Future.value(false);
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    // print(
    //     'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;

    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                image: new DecorationImage(
                  image:
                      new AssetImage('assets/images/${widget.extensions}.png'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.name.toString(),
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            SizedBox(height: 10),
            Text(
              _prettyCountInt(widget.size.toString()),
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            SizedBox(height: 20),
            status! == DownloadTaskStatus.running ||
                    status! == DownloadTaskStatus.paused
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      value: progress! / 100,
                      color: Color(0xFF4bd8a4),
                    ),
                  )
                : Container(),
            Padding(
                padding: const EdgeInsets.all(2.0),
                child: _buildActionForTask(status)),
          ],
        ),
      ),
    );
  }

  Widget? _buildActionForTask(status) {
    if (status == DownloadTaskStatus.undefined) {
      // ignore: deprecated_member_use
      return FlatButton(
        color: Colors.green,
        textColor: Colors.white,
        child: Text(
          'Download',
        ),
        onPressed: _requestDownload,
      );
    } else if (status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: _pauseDownload,
        child: Icon(
          Icons.pause,
          color: Colors.red,
          size: 40,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 40.0, minWidth: 40.0),
      );
    } else if (status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: _resumeDownload,
        child: Icon(
          Icons.play_arrow,
          color: Colors.green,
          size: 40,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 40.0, minWidth: 40.0),
      );
    } else if (status == DownloadTaskStatus.complete) {
      // ignore: deprecated_member_use
      return FlatButton(
        color: Colors.green,
        textColor: Colors.white,
        child: Text(
          'Open file',
        ),
        onPressed: () {
          _openDownloadedFile().then((success) {
            if (!success) {
              Flushbar(
                message: "Cannot open this file",
                icon: Icon(
                  Icons.error_outline,
                  size: 28.0,
                  color: Colors.white,
                ),
                duration: Duration(seconds: 5),
                leftBarIndicatorColor: Colors.black,
              )..show(context);
            }
          });
        },
      );
    } else if (status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: _retryDownload,
            child: Icon(
              Icons.refresh,
              color: Colors.green,
              size: 40,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 40.0, minWidth: 40.0),
          )
        ],
      );
    } else if (status == DownloadTaskStatus.enqueued) {
      return Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  Future<void> _prepareSaveDir() async {
    _localPath =
        (await _findLocalPath())! + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path;
  }
}
