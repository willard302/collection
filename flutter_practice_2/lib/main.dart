import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: HomePage(),));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Dio dio = Dio();
  Map allData = {};

  getData()async{
    try {
      Response res = await dio.get('https://wic.heo.taipei/OpenData/API/Rain/Get?stationNo=&loginId=open_rain&dataKey=85452C1D');
      if(res.statusCode == 200 && res.data != null){
        allData = res.data;
      }
    }on DioException catch(e){
      if (kDebugMode) {
        print('dio error, $e');
      }
      rethrow;
    } catch(e){
      if (kDebugMode) {
        print('other error, $e');
      }
      rethrow;
    }
  }

  Future<Response?> getApi() async{
    Response res;
    try {
      res = await dio.get('https://wic.heo.taipei/OpenData/API/Rain/Get?stationNo=&loginId=open_rain&dataKey=85452C1D');
      if(res.statusCode == 200 && res.data != null){
        if (kDebugMode) {
          print(res.data['data']);
        }
        return res;
      }
    } on DioException catch(e) {
      print('dio error $e');
      rethrow;
    } catch (e) {
      print('other error $e');
      rethrow;
    }
    return res;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    allData = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: <Widget>[
          Container(
            height: 78,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://www.shuangxi.ntpc.gov.tw/userfiles/3270500/images/e-bus_banner.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: size.width*0.1,
                alignment: Alignment.center,
                child: Text('No', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              ),Container(
                width: size.width*0.3,
                alignment: Alignment.center,
                child: Text('stationName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              ),Container(
                width: size.width*0.4,
                alignment: Alignment.center,
                child: Text('recTime', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              ),Container(
                width: size.width*0.1,
                alignment: Alignment.center,
                child: Text('rain', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              ),
            ],
          ),
          Expanded(child: FutureBuilder(
            future: getApi(),
            builder: (BuildContext context, AsyncSnapshot snap) {
              if(snap.hasData){
                Response res = snap.data;
                return ListView.builder(
                  itemCount: res.data['data'].length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic>? data = res.data['data'][index];
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: size.width*0.1,
                            alignment: Alignment.center,
                            child: Text('${data?['stationNo']}'),
                          ),Container(
                            width: size.width*0.3,
                            alignment: Alignment.center,
                            child: Text('${data?['stationName']}'),
                          ),Container(
                            width: size.width*0.4,
                            alignment: Alignment.center,
                            child: Text('${data?['recTime']}'),
                          ),Container(
                            width: size.width*0.1,
                            alignment: Alignment.center,
                            child: Text('${data?['rain']}'),
                          ),
                        ],
                      ),
                    );
                  }
                );
              }else{
                return Center(child: CircularProgressIndicator());
              }
            },
          ))
        ],
      ),),
    );
  }
}

