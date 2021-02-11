import 'dart:convert';

import 'package:flutter/material.dart';
import 'DetailMovie.dart';
import 'package:http/http.dart' as http;
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var listDisplay = [], listBackup = [];

  TextEditingController ec = TextEditingController();

  Future<List> ambilData() async {
    final dataList =
        await http.get("http://192.168.10.24/movieApps/ambildatafavorite.php");
    return json.decode(dataList.body);
  }

  pembungkusData() {
    ambilData().then((data) {
      listDisplay.addAll(data);
      listBackup.addAll(data);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    pembungkusData();
    ambilData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Favorite",
        ),
      ),
      //Now we are going to open a new file
      // where we will create the layout of the Drawer
      body: Container(
        child: FutureBuilder<List>(
          future: ambilData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ItemMovie(list: listDisplay) //yang ditampilin dari list
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class ItemMovie extends StatelessWidget {
  final List list;
  ItemMovie({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //ambil sendiri dari database tapi tidak ditampung di variabel
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Container(
          child: GestureDetector(
            //supaya kalau di klik bisa menampilkan detail card
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                //list value beraasal dari detailcard.dart
                builder: (BuildContext context) => DetailMovie(
                      list: list,
                      index: i,
                    ))),
            child: Container(
              child: Card(
                elevation: 0.1,
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'http://192.168.10.24/movieApps/images/' +
                              list[i]['gambar'],
                          fit: BoxFit.cover,
                          height: 56.0,
                          width: 56.0,
                        ),
                      ],
                    ),
                  ),
                  // CircleAvatar(
                  //     backgroundImage: NetworkImage(
                  //         'http://192.168.10.24/movieApps/images/' +
                  //             list[i]['gambar'])),
                  title: Text(
                    "${list[i]['judul']}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 3,
                      ),
                      Text("View : ${list[i]['view']} Penonton")
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
