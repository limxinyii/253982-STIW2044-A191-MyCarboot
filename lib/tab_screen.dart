import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab_2/item.dart';
import 'package:lab_2/itemdetail.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
//import 'package:lab_2/mainscreen.dart';
import 'package:lab_2/user.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'SlideRightRoute.dart';
import 'enterexit.dart';

double perpage = 1;

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.redAccent));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.orange[300],
            resizeToAvoidBottomPadding: false,
            body: RefreshIndicator(
              key: refreshKey,
              color: Colors.redAccent,
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/background.png",
                                fit: BoxFit.fitWidth,
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text("MyCarboot",
                                        style: TextStyle(
                                            fontFamily: 'Pacifico',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 300,
                                    height: 140,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.person,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.user.name
                                                            .toUpperCase() ??
                                                        "Not registered",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Source Sans Pro'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    _currentAddress,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Source Sans Pro'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.credit_card,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text("You have " +
                                                      widget.user.credit +
                                                      " Credit",
                                                       style: TextStyle(
                                                            fontFamily: 'Source Sans Pro'
                                                            ),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Colors.redAccent,
                              padding: EdgeInsets.all(5.0),
                              child: Center(
                                child: Text("Item Available",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Source Sans Pro',
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == data.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _onItemDetail(
                            data[index]['itemid'],
                            data[index]['itemprice'],
                            data[index]['itemdesc'],
                            data[index]['itemowner'],
                            data[index]['itemimage'],
                            data[index]['itemtime'],
                            data[index]['itemname'],
                            data[index]['itemlatitude'],
                            data[index]['itemlongitude'],
                            data[index]['itemrating'],
                            widget.user.email,
                            widget.user.name,
                            widget.user.credit,
                          ),
                          onLongPress: _onItemDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "http://myondb.com/myapp/images/${data[index]['itemimage']}.jpg")))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['itemname']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        RatingBar(
                                          itemCount: 5,
                                          itemSize: 12,
                                          initialRating: double.parse(
                                              data[index]['itemrating']
                                                  .toString()),
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("RM " + data[index]['itemprice']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['itemtime']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> makeRequest() async {
    String urlLoadItems = "http://myondb.com/myapp/php/load_items.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading items");
    pr.show();
    http.post(urlLoadItems, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      //"radius": widget.user.radius ?? "10",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["items"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onItemDetail(
      String itemid,
      String itemprice,
      String itemdesc,
      String itemowner,
      String itemimage,
      String itemtime,
      String itemname,
      String itemlatitude,
      String itemlongitude,
      String itemrating,
      String email,
      String name,
      String credit) {
    Item item = new Item(
        itemid: itemid,
        itemname: itemname,
        itemowner: itemowner,
        itemdes: itemdesc,
        itemprice: itemprice,
        itemtime: itemtime,
        itemimage: itemimage,
        itemworker: null,
        itemlat: itemlatitude,
        itemlon: itemlongitude,
        itemrating: itemrating);
    //print(data);

    Navigator.push(context,
        SlideRightRoute(page: ItemDetail(item: item, user: widget.user)));
  }

  void _onItemDelete() {
    print("Delete");
  }
}
