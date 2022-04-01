import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sample_app/payment_success.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const platform = const MethodChannel('bill24Sdk');
  TextEditingController orderRefController = new TextEditingController();
  var language = "en";
  var switchValue = false;

  Future<dynamic> getSessionId() async {
    const clientId = "fmDJiZyehRgEbBJTkXc7AQ==";
    const url = "http://203.217.169.102:50209";
    Map<String, String> mainheader = {
      "accept": "application/json",
      "Content-type": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJQYXltZW50R2F0ZXdheSIsInN1YiI6IkVEQyIsImhhc2giOiJCQ0ZEQzE1MC0zMjRGLTQzRjQtQkQ3Qi0zMTVGN0Y5NDM3NDAifQ.OZ9AqnbRucNmVlJzQt6kqkRjDDDPjMAN81caYwqKuX4",
    };
    var payload =
    {
    "customer": {
    "customer_ref": "C00001",
    "customer_email": "example@gmail.com",
    "customer_phone": "010801252",
    "customer_name": "test customer"
    },
    "billing_address": {
    "province": "Phnom Penh",
    "country": "Cambodia",
    "address_line_2": "string",
    "postal_code": "12000",
    "address_line_1": "No.01, St.01, Toul Kork"
    },
    "description": "Extra note",
    "language": "km",
    "order_items": [
    {
    "item_ref": "001",
    "amount": 10
    }
    ],
    "payment_success_url": "/payment/success",
    "currency": "USD",
    "amount": 1,
    "pay_later_url": "/payment/paylater",
    "shipping_address": {
    "province": "Phnom Penh",
    "country": "Cambodia",
    "address_line_2": "string",
    "postal_code": "12000",
    "address_line_1": "No.01, St.01, Toul Kork"
    },
    "order_ref":"${orderRefController.text}",
    "payment_fail_url": "payment/fail",
    "payment_cancel_url": "payment/cancel",
    "continue_shopping_url": "http://localhost:8090/order"
    };
    final response = await http.post(Uri.parse(url + "/order/create/v1"),
        body: json.encoder.convert(payload), headers: mainheader);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  void callSdk() async {
    var value;
    List<String> arguments = [];
    try {
      getSessionId().then((result) async {
        if (result["code"] == "000") {
          if (switchValue == true) {
            language = "kh";
            arguments.add(result["data"]["session_id"]);
            arguments.add(language);
          }
          else{
            language = "en";
            arguments.add(result["data"]["session_id"]);
            arguments.add(language);
          }
          value = await platform.invokeMethod(
              "bill24Sdk", arguments);
          if (value.isNotEmpty) {
            var tranData;
            if(Platform.isAndroid) {
              print((json.decode(value))[0]["tran_data"]);
              tranData = (json.decode(value))[0]["tran_data"];
            }
            else{
              tranData = value["tran_data"];
            }


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentSucceeded(
                        tranData["order_ref"].toString(),
                        tranData["bank_name_en"].toString(),
                        tranData["bank_ref"].toString(),
                        tranData["trans_id"].toString(),
                        tranData["status"].toString())));
          }
        } else {
          return;
        }
      });

      const sample_response = """
      ["tran_data": {
      "bank_name_en" = ACLEDA;
      "bank_name_kh" = "\U17a2\U17c1\U179f\U17ca\U17b8\U179b\U17b8\U178a\U17b6";
      "bank_ref" = FT220840WCB4789H;
      "order_ref" = "Optional(123124)";
      status = 0;
      "trans_id" = 9wzcLMPS;
      }, "payment_success_url": /payment/success]
      """;
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/checkout.png"),
                    fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                        child: Container(
                          height: 40,
                          width: 200,
                          child: TextField(
                            controller: orderRefController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: -5, left: 10),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: 'OrderRef',
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: 'Enter order ref here',
                                hintStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'ភាសាខ្មែរ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: CupertinoSwitch(
                                value: switchValue,
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = !switchValue;
                                  });
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () {
                            callSdk();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF6200EE))),
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: Text("Checkout"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
