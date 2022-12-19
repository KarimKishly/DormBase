import 'package:flutter/material.dart';
import 'reusable/methods.dart';
import 'reusable/constants.dart';
import 'sqlconn/Services.dart';
class Booking extends StatelessWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: buildAppBar(),
      body: FutureBuilder(
        future: Services.getBookings(userID: userID),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.hasData) {
        List<dynamic> bookings = snapshot.data;
        return ListView.builder(
          itemCount: bookings.length,
            itemBuilder: (context, i) {
            return buildBookingCard(bookings[i]);
            }
            );
        }
      }
      return Container();
      },),
    );
  }

  Card buildBookingCard(Map<String, dynamic> bookings) {
    return Card(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Text(
              bookings['dormName'],
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Text(bookings['roomNumber']),
          ),
          Row(
            children: [
              Container(
                child: Text(bookings['rent']),
              ),
              Container(
                child: Text(bookings['dateRental']),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
