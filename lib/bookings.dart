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
        print(bookings);
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
      color: Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                bookings['dormName'],
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(bookings['roomNumber'], style: TextStyle(fontSize: 16)),
            ),
            Row(
              children: [
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text('\$ ${bookings['rent']}'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Text(bookings['dateRental']),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
