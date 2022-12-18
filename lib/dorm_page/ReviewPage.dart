import 'package:flutter/material.dart';
import 'ReviewCard.dart';
import 'constants.dart';
import 'package:dorm_base/reusable/methods.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> reviews = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color:textColorLight
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            itemCount: reviews.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ReviewCard(review: reviews[index], key: null,);
            },
          ),
        ],
      ),
    );
  }
}
