import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab_2/user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'item.dart';
import 'mainscreen.dart';

class ItemDetail extends StatefulWidget {
  final Item item;
  final User user;

  const ItemDetail({Key key, this.item, this.user}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.redAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          backgroundColor: Colors.orange[300],
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(
              'ITEM DETAILS',
              style: TextStyle(
                fontFamily: 'Source Sans Pro',
                fontSize: 21,
              ),
            ),
            backgroundColor: Colors.deepOrange,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                item: widget.item,
                user: widget.user,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Item item;
  final User user;
  DetailInterface({this.item, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(
          double.parse(widget.item.itemlat), double.parse(widget.item.itemlon)),
      zoom: 17,
    );
    print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Text(widget.item.itemname.toUpperCase(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Source Sans Pro',
                letterSpacing: 2.0)),
        SizedBox(height: 10),
        Container(
          width: 280,
          height: 270,
          child: Image.network(
              'http://myondb.com/myapp/images/${widget.item.itemimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          widget.item.itemtime,
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'ITEM DESCRIPTION',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5, fontSize: 16
                ),
              ),
              SizedBox(
                height: 5,
              ),
               Text(widget.item.itemdes,
               style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontSize: 16
                ),
               ),
               SizedBox(height: 15),
                Text(
                'ITEM PRICE',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5, fontSize: 16
                ),
              ),
              SizedBox(
                height: 5,
              ),
               //SizedBox(height: 6),
               Text("RM" + widget.item.itemprice,
               style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontSize: 16
                ),
               ),
               SizedBox(height: 15),
                Text(
                'LOCATION',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5, fontSize: 16
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                width: 340,
                child: GoogleMap(
                  // 2
                  initialCameraPosition: _myLocation,
                  // 3
                  mapType: MapType.normal,
                  // 4

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              SizedBox(height: 15),

              /*Table(children: [
                TableRow(children: [
                  Text("ITEM DESCRIPTION",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Source Sans Pro',
                          letterSpacing: 0.5,
                          fontSize: 15)),
                  Text(widget.item.itemdes),
                ]),
                TableRow(children: [
                  Text("Item Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("RM" + widget.item.itemprice),
                ]),
                TableRow(children: [
                  Text("Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("")
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                width: 340,
                child: GoogleMap(
                  // 2
                  initialCameraPosition: _myLocation,
                  // 3
                  mapType: MapType.normal,
                  // 4

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),*/
              SizedBox(
                height: 5,
              ),
              Container(
                width: 300,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'Purchase Item',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onAcceptItem,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptItem() {
    if (widget.user.email == "user@noregister") {
      Toast.show("Please Login First", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      _showDialog();
    }
    print("Add to cart");
  }

  void _showDialog() {
    // flutter defined function
    if (int.parse(widget.user.credit) < 1) {
      Toast.show("Credit not enough ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Buy " + widget.item.itemname),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> acceptRequest() async {
    String urlLoadItems = "http://myondb.com/myapp/php/accept_item.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Purchase Item");
    pr.show();
    http.post(urlLoadItems, body: {
      "itemid": widget.item.itemid,
      "email": widget.user.email,
      "credit": widget.user.credit,
      "itemprice": widget.item.itemprice,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
        _onLogin(widget.user.email, context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  void _onLogin(String email, BuildContext ctx) {
    String urlgetuser = "http://myondb.com/myapp/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1], email: dres[2], phone: dres[3], credit: dres[4]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
