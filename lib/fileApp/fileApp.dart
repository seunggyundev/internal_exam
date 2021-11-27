import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //파일을 열고 파일 입출력을 돕는 패키지
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class FileApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FileApp();
}

class _FileApp extends State<FileApp> {
  int _count = 0;
  List<String> itemList = List.empty(growable: true);
  TextEditingController controller = TextEditingController();

  void writeFruit(String fruit) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = await File(dir.path + '/fruit.txt').readAsString();  //현재 fruit.txt파일의 내용을 가져옴
    file = file + '\n' + fruit;  //추가할 때는 반드시 '\n'으로 구분자를 넣는다, 파라미터로 받은 과일을 추가
    File(dir.path + '/fruit.txt').writeAsStringSync(file);  //추가한 후 다시 파일에 기록
  }

  Future<List<String>> readListFile() async{
    List<String> itemList = List.empty(growable: true);
    var key = 'first';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? firstCheck = pref.getBool(key);  // firstCheck변수는 이후에 파일을 처음 열었는 지 확인하는 용도
    var dir = await getApplicationDocumentsDirectory();

    //fileExist변수는 파일이 있는지를 확인하는 용도
    bool fileExist = await File(dir.path + 'fruit.txt').exists();  //File().exists()로 내부 저장소에 파일(fruit.txt)이 있는지를 확인한 후 변수에 bool값으로 저장

    // ||는 둘 중 하나가 트루이면 트루 리턴
    //파일을 처음 열었거나 없는 경우
    if (firstCheck == null || firstCheck == false || fileExist == false) {
      pref.setBool(key, true);  //공유 환경설정에 true값을 저장해 파일을 연 것으로 기록
      var file = await DefaultAssetBundle.of(context).loadString('repo/fruit.txt');  //애셋에 등록한 파일(repo/fruit.txt)을 읽어서
      File(dir.path + '/fruit.txt').writeAsStringSync(file);  //내부 저장소에 똑같은 파일을 만듦
      var array = file.split('\n');  //파일의 데이터를 줄바꿈 문자('\n')를 기준으로 나누어 배열형태로 만듦
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    } else {
      var file = await File(dir.path + '/fruit.txt').readAsString();
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    }
  }

  @override
  void initState() {
    super.initState();
    readCountFile();  //앱이 실행될 때 파일에서 가져온 데이터를 표시하기 위해 호출함
    initData();
  }

  void initData() async {
    var result = await readListFile();
    setState(() {
      itemList.addAll(result);
    });
  }

  // 파일 입출력 또한 환경에 따라 작업이 언제 끝날지 예측불가,따라서 비동기 함수로 만듦
  void writeCountFile(int count) async {
    var dir =
    await getApplicationDocumentsDirectory(); //getApplicationDocumentsDirectory()로 내부 저장소의 경로를 가져옴
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('File Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: Center(
                          child: Text(
                            itemList[index],
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      );
                    },
                  itemCount: itemList.length,
                    ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeFruit(controller.value.text);
          setState(() {
            itemList.add(controller.value.text);
          });
          },
        child: Icon(Icons.add),
      ),
    );
  }
}
