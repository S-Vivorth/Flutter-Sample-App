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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const platform = const MethodChannel('paymentSdk');
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
      "amount": 20,
      "consumer_code": "001",
      "consumer_name": "ដេវីដ ចន",
      "consumer_name_latin": "David John"
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
              "paymentSdk", arguments);
          if (value.isNotEmpty) {
            var tranData;
            if(Platform.isAndroid) {
              tranData = (json.decode(value))[0]["tran_data"];
            }
            else{
              tranData = value["tran_data"];
            }
            if (tranData["status"].toString() == "0") {
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
            else{
              // do your stuff here when payment is failed
              print("There was a problem during payment.");
            }
          }
        } else {
          return;
        }
      });

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
