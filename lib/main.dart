import 'package:flutter/material.dart';
import 'package:ten_pearls/dummy_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import 'package:auro_avatar/auro_avatar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterJam(),
    );
  }
}

class FlutterJam extends StatefulWidget {
  @override
  _FlutterJamState createState() => _FlutterJamState();
}

class _FlutterJamState extends State<FlutterJam> {
  List<String> _myList = [
    'Length',
    'Mass',
    'Weight',
    'Area',
    'Time',
    'Length',
    'Mass',
    'Weight',
    'Area',
    'Time',
    'Length',
    'Mass',
    'Weight',
    'Area',
    'Time'
  ];

  DummyDataList _dummyDataList;
  bool _isLoading = true;

  Future<String> getDummyData() async {
    var url = 'https://jsonplaceholder.typicode.com/users';
    var response = await http.get(url);
    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      _dummyDataList = DummyDataList.fromJson(dataConvertedToJSON);
      _isLoading = false;
    });

    return 'success';
  }

  dismissPerson(person) {
    if (_dummyDataList.dummyDataList.contains(person)) {
      //_personList is list of person shown in ListView
      setState(() {
        _dummyDataList.dummyDataList.remove(person);
      });
    }
  }

  openGoogleMAp(lat, lng) {}

  @override
  void initState() {
    this.getDummyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Study Jam <3"),
        actions: <Widget>[Icon(Icons.check)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _dummyDataList.dummyDataList.length,
              itemBuilder: (context, index) {
                final item = _dummyDataList.dummyDataList[index].name;
                return Slidable(
                  key: Key(item),
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  // onDismissed: (direction) {
                  //   dismissPerson(_dummyDataList.dummyDataList[index].name);
                  //   Scaffold.of(context).showSnackBar(
                  //       SnackBar(content: Text("$item dismissed")));
                  // },
                  child: GestureDetector(
                    onTap: () async {
                      var _myLat =
                          _dummyDataList.dummyDataList[index].address.geo.lat;
                      var _myLng =
                          _dummyDataList.dummyDataList[index].address.geo.lng;
                      var origin = "$_myLat,$_myLng";
                      final AndroidIntent intent = new AndroidIntent(
                          action: 'action_view',
                          data: Uri.encodeFull(
                              "https://www.google.com/maps/search/?api=1&query=" +
                                  _myLat +
                                  "," +
                                  _myLng),
                          package: 'com.google.android.apps.maps');
                      intent.launch();
                    },
                    child: ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        child: InitialNameAvatar(
                          _dummyDataList.dummyDataList[index].name,
                          circleAvatar: true,
                        ),
                      ),
                      title: Text(
                        _dummyDataList.dummyDataList[index].name,
                        style: TextStyle(color: Colors.brown),
                      ),
                      trailing: Icon(Icons.location_on),
                      subtitle: Text(_dummyDataList
                          .dummyDataList[index].address.zipcode
                          .toString()),
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Like',
                      color: Colors.blue,
                      icon: Icons.thumb_up,
                      //onTap: () => dismissPerson(
                        //  _dummyDataList.dummyDataList[index].name),
                    ),
                    IconSlideAction(
                      caption: 'Share',
                      color: Colors.indigo,
                      icon: Icons.share,
                      //onTap: () => _showSnackBar('Share'),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'More',
                      color: Colors.black45,
                      icon: Icons.more_horiz,
                      //onTap: () => _showSnackBar('More'),
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => dismissPerson(
                          _dummyDataList.dummyDataList[index].name),
                    ),
                  ],
                );
              }),
    );
  }
}
