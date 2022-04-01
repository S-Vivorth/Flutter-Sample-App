import 'package:flutter/material.dart';
import 'package:flutter_sample_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class PaymentSucceeded extends StatelessWidget {

  final String orderRef,bankName,bankRef,transId,status;
  PaymentSucceeded(this.orderRef,this.bankName,this.bankRef,this.transId,this.status);
  Future<dynamic> transVerify() async{
    const String url = "http://203.217.169.102:50209/transaction/verify/v1";
    Map<String, String> mainheader = {
      "accept" : "application/json",
      "Content-type": "application/json",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJQYXltZW50R2F0ZXdheSIsInN1YiI6IkVEQyIsImhhc2giOiJCQ0ZEQzE1MC0zMjRGLTQzRjQtQkQ3Qi0zMTVGN0Y5NDM3NDAifQ.OZ9AqnbRucNmVlJzQt6kqkRjDDDPjMAN81caYwqKuX4",
    };

    final response = await http.post(Uri.parse(url),headers: mainheader,body: json.encoder.convert(
        {"tran_id": transId}));
    print(json.encoder.convert(
        {"tran_id": transId}));

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: transVerify(),
        builder: (context, AsyncSnapshot<dynamic> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            final tranData = snapshot.data["data"];
            print(snapshot.data);
            return Column(children: [
              Container(
                width: double.infinity,
                color: Color(0xFF6200EE),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.done,
                      size: 80,
                      color: Colors.white,
                    ),
                    Text(
                      "Payment Succeeded",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 20),
                  child: IntrinsicHeight(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Order #${orderRef}"),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(tranData["tran_date"]),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14, bottom: 5, top: 5),
                                        color: Colors.green,
                                        child: Text("Paid"),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Heng Samnang",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "No. 3H, St. 368, Borey Vimean Phnom Penh, Cambodia",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Method",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 16),
                                  ),
                                  Text(bankName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16))
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Reference",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 16),
                                  ),
                                  Text(bankRef,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16))
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 16),
                                  ),
                                  Text(tranData["tran_date"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16))
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 140),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sub Total:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Text("${tranData["tran_amount"]}USD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 140, top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Fee:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Text("${tranData["fee_amount"]}USD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 140, top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Text("${tranData["total_amount"]}USD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Download",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Print",
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14))
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 40),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: '')));
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF6200EE))),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Text("Continue Shopping"),
                                )),
                          )
                        ]),
                  ),
                ),
              ),
            ]);
          }
        },
      ),
    );
  }
}
