import 'package:dorm_base/dorm_page/constants.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[500],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review['username'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: List.generate(
                5,
                    (index) {
                  return Icon(
                      (index < int.parse(review['rating'].substring(0,1)))
                        ? Icons.star
                        : Icons.star_border,
                    color: primaryColor,
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Text(review['reviewDescription']),
          ],
        ),
      ),
    );
  }
}

