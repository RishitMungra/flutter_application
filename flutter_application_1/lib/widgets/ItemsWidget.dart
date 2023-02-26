import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 1.1),
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      shrinkWrap: true,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: FutureBuilder<http.Response>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount:
                        jsonDecode(snapshot.data!.body.toString()).length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "itemPage");
                                      },
                                      child: Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Image.network(
                                                (jsonDecode(snapshot.data!.body
                                                            .toString())[index]
                                                        ['image'])
                                                    .toString(),
                                                height: 120,
                                                width: 120,
                                              ),
                                            ),
                                            Container(
                                              child: Expanded(
                                                  child: Column(
                                                children: [
                                                  Text(
                                                      (jsonDecode(snapshot
                                                                  .data!.body
                                                                  .toString())[
                                                              index]['name'])
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Price : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text("\$",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent)),
                                                      Text(
                                                        (jsonDecode(snapshot
                                                                    .data!.body
                                                                    .toString())[
                                                                index]['price'])
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating: 3,
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 1.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.redAccent,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                ],
                                              )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              future: getAll()),
        )
      ],
    );
  }
}

Future<http.Response> getAll() async {
  var response = await http
      .get(Uri.parse("https://63f9e668beec322c57e98171.mockapi.io/app"));
  print(response.body.toString());
  return response;
}
