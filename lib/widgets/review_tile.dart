import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewTile extends StatelessWidget {
  final Map review;
  const ReviewTile({Key key, @required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: review['userImg'],
            imageBuilder: (context, imageProvider) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            width: 10,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Text(
                  review['username'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  review['date'].substring(0, 10),
                  style: TextStyle(color: Colors.grey[700]),
                )
              ],
            ),
            SizedBox(height: 5),
            Text(
              review['description'],
              maxLines: 3,
            ),
            SizedBox(height: 5),
            SmoothStarRating(
              rating: review['star'].toDouble(),
              isReadOnly: true,
              size: 20,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              color: Colors.yellow,
              // onRated: (value) {
              //   print("rating value -> $value");
              //   // print("rating value dd -> ${value.truncate()}");
              // },
            )
          ])
        ],
      ),
    );
  }
}
