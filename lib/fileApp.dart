import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //파일을 열고 파일 입출력을 돕는 패키지
import 'dart:io';

class FileApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FileApp();
}

class _FileApp extends State<FileApp> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    readCountFile(); //앱이 실행될 때 파일에서 가져온 데이터를 표시하기 위해 호출함
  }

  @override
  Widget build(BuildContext context) {

     // 파일 입출력 또한 환경에 따라 작업이 언제 끝날지 예측불가,따라서 비동기 함수로 만듦
    void writeCountFile(int count) async {
      var dir = await getApplicationDocumentsDirectory(); //getApplicationDocumentsDirectory()로 내부 저장소의 경로를 가져
      File(dir.path + '/count.txt').writeAsStringSync(count.toString());
    }

    void readCountFile() async {
      try {
        var dir = await getApplicationDocumentsDirectory();
        var file = await File(dir.path + '/count.txt').readAsString();
        print(file);
        setState(() {
          _count = int.parse(file);
        });
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('File Example'),
      ),
      body: Container(),
    );
  }
}
