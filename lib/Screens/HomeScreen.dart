import 'dart:convert';

import 'package:flutter/material.dart';
import 'DetailMovie.dart';
import 'Drawer.dart';
import 'package:http/http.dart' as http;
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  final String iduser;
  final String email;
  final String username;
  HomeScreen({this.iduser, this.email, this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var listDisplay = [], listBackup = [];
  List<bool> listFavorite = [];
  // List<bool> listUnFavorite = [];

  TextEditingController ec = TextEditingController();
  Future<List> ambilData() async {
    setState(() {
      listDisplay.clear();
      listFavorite.clear();
      listBackup.clear();
      // listUnFavorite.clear();
    });
    final dataList =
        await http.get("http://192.168.10.24/movieApps/ambildata.php");
    final resFavorite =
        await http.get("http://192.168.10.24/movieApps/ambildatafavorite.php");
    // final resUnFavorite =
    //     await http.get("http://172.16.0.8/movieApps/hapusdatafavorite.php");

    listDisplay = json.decode(dataList.body);
    List tempFavorite = json.decode(resFavorite.body);
    // List tempUnFavorite = json.decode(resUnFavorite.body);

    listDisplay.forEach((e) {
      if (tempFavorite
              .where((a) => e['id_movie'] == a['id_movie'])
              .toList()
              .length >
          0) {
        listFavorite.add(true);
      } else {
        listFavorite.add(false);
      }
    });

    setState(() {
      listBackup = listDisplay;
    });
    return json.decode(dataList.body);
  }

  // Future<List> hapusDataFavorite() async {
  //   setState(() {
  //     listDisplay.clear();
  //     listFavorite.clear();
  //     listBackup.clear();
  //     listUnFavorite.clear();
  //   });

  //   final resUnFavorite =
  //       await http.get("http://192.168.10.24/movieApps/hapusdatafavorite.php");
  //   List tempUnFavorite = json.decode(resUnFavorite.body);
  // }

  Future<List> pembungkusData() async {
    List data = await ambilData();
    listDisplay = data;
    listBackup = data;
    return data;
  }

  @override
  void initState() {
    super.initState();
    // pembungkusData();
    ambilData();
  }

  @override
  Widget build(BuildContext context) {
    print("username : ${widget.username}");
    return RefreshIndicator(
      onRefresh: () async {
        ambilData();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Movie Apps",
          ),
          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(
          //         EvaIcons.searchOutline,
          //         color: Colors.white,
          //       ),
          //       onPressed: (null))
          // ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10.0, top: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.0),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Cari Nama Film",
                        contentPadding: EdgeInsets.only(left: 20),
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.search),
                        ),
                      ),
                      controller: ec,
                      onChanged: (value) {
                        setState(() {
                          listDisplay = listDisplay
                              .where((e) => "${e['judul']}"
                                  .toLowerCase()
                                  .contains(ec.text.toLowerCase()))
                              .toList();
                          if (value.isEmpty) {
                            listDisplay = listBackup;
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        //Now we are going to open a new file
        // where we will create the layout of the Drawer
        drawer: Drawer(
          child: MainDrawer(
            iduser: widget.iduser,
            email: widget.email,
            username: widget.username,
          ),
        ),
        body: Container(
          child: FutureBuilder<List>(
            // future: pembungkusData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return listDisplay.length != 0
                  ? ItemMovie(
                      list: listDisplay,
                      listFavorite: listFavorite,
                      iduser: widget.iduser) //yang ditampilin dari list
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemMovie extends StatefulWidget {
  String iduser;
  final List list;
  final List<bool> listFavorite;
  ItemMovie({this.list, this.iduser, this.listFavorite});

  @override
  _ItemMovieState createState() => _ItemMovieState();
}

class _ItemMovieState extends State<ItemMovie> {
  Future<void> tambahData(idMovie) async {
    var url = "http://192.168.10.24/movieApps/tambahfavorite.php";
    final responseData = await http.post(url, body: {
      "id_movie": idMovie,
    });
  }

  Future<void> hapusData(idMovie) async {
    var url = "http://192.168.10.24/movieApps/hapusdatafavorit.php";
    final responseData = await http.post(url, body: {
      "id_movie": idMovie,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //ambil sendiri dari database tapi tidak ditampung di variabel
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        return Container(
            child: GestureDetector(
          //supaya kalau di klik bisa menampilkan detail card
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              //list value beraasal dari detailcard.dart
              builder: (BuildContext context) => DetailMovie(
                    list: widget.list,
                    index: i,
                  ))),
          child: Container(
            child: Card(
                elevation: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Image.network(
                          'http://192.168.10.24/movieApps/images/' +
                              widget.list[i]['gambar'],
                          fit: BoxFit.cover,
                          width: 900,
                          height: 1000,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.list[i]['judul']}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.access_alarm_rounded),
                                  Text(" ${widget.list[i]['view']} tayang"),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            iconSize: 30,
                            icon: Icon(Icons.favorite),
                            color: widget.listFavorite[i]
                                ? Colors.red
                                : Colors.grey,
                            onPressed: () async {
                              if (widget.listFavorite[i] == true) {
                                await hapusData(widget.list[i]['id_movie']);
                              } else {
                                await tambahData(widget.list[i]['id_movie']);
                              }
                              setState(() {
                                widget.listFavorite[i] =
                                    !widget.listFavorite[i];
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SafeArea(
                        child: Text(
                          "${widget.list[i]['deskripsi']}",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      )
                    ],
                  ),
                )

                //   elevation: 50,
                //   shadowColor: Colors.black,
                //   color: Colors.blue,
                //   child: SizedBox(
                //     width: 300,
                //     height: 500,
                //     child: Padding(
                //       padding: const EdgeInsets.all(20.0),
                //       child: Column(
                //         children: [
                //           CircleAvatar(
                //             backgroundColor: Colors.green[500],
                //             radius: 108,
                //             child: CircleAvatar(
                //               backgroundImage: NetworkImage(
                //                   "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"), //NetworkImage
                //               radius: 100,
                //             ), //CircleAvatar
                //           ), //CirclAvatar
                //           //SizedBox
                //           Text(
                //             'GeeksforGeeks',
                //             style: TextStyle(
                //               fontSize: 30,
                //               color: Colors.green[900],
                //               fontWeight: FontWeight.w500,
                //             ), //Textstyle
                //           ), //Text
                //           SizedBox(
                //             height: 10,
                //           ), //SizedBox
                //           Text(
                //             'wbdhwbdhwbdwbdywdywdbywdywdvwydvwydvw',
                //             style: TextStyle(
                //               fontSize: 15,
                //               color: Colors.green[900],
                //             ), //Textstyle
                //           ), //Text
                //         //SizedBox
                //           SizedBox(
                //             child: RaisedButton(
                //               onPressed: () => null,
                //               color: Colors.green,
                //               child: Padding(
                //                 padding: const EdgeInsets.all(4.0),
                //                 child: Row(
                //                   children: [
                //                     Icon(Icons.touch_app),
                //                     Text('Visit'),
                //                   ],
                //                 ), //Row
                //               ), //Padding
                //             ), //RaisedButton
                //           ) //SizedBox
                //         ],
                //       ), //Column
                //     ), //Padding
                //   ), //SizedBox
                // ),

                //Card ,
                // child: Card(
                //   elevation: 0.1,
                //   child: ListTile(
                //     leading: Container(
                //       width: 60,
                //       height: 60,
                //       child: Column(
                //         children: <Widget>[
                //           Image.network(
                //             'http://172.16.0.8/movieApps/images/' +
                //                 widget.list[i]['gambar'],
                //             fit: BoxFit.cover,
                //             height: 56.0,
                //             width: 56.0,
                //           ),
                //         ],
                //       ),
                //     ),
                //     // CircleAvatar(
                //     //     backgroundImage: NetworkImage(
                //     //         'http://192.168.10.24/movieApps/images/' +
                //     //             list[i]['gambar'])),
                //     title: Text(
                //       "${widget.list[i]['judul']}",
                //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                //     ),
                //     trailing: Column(
                //       children: <Widget>[
                //         IconButton(
                //           icon: Icon(Icons.favorite),
                //           color:
                //               widget.listFavorite[i] ? Colors.red : Colors.grey,
                //           onPressed: () async {
                //             if (widget.listFavorite[i] == true) {
                //               await hapusData(widget.list[i]['id_movie']);
                //             } else {
                //               await tambahData(widget.list[i]['id_movie']);
                //             }
                //             setState(() {
                //               widget.listFavorite[i] = !widget.listFavorite[i];
                //             });
                //           },
                //         ),
                //       ],
                //     ),
                //     subtitle: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //           height: 3,
                //         ),
                //         Text("View : ${widget.list[i]['view']} tayang")
                //       ],
                //     ),
                //   ),
                // ),
                ),
          ),
        ));
      },
    );
  }
}
