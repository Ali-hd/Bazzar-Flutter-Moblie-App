import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero(
      {Key key, this.photo, this.onTap, this.width, this.radius, this.tag})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;
  final double radius;
  final String tag;

  Widget build(BuildContext context) {
    return SizedBox(
      // multiple heros having the same tag because its displayed in a list view
      // where multiple widgets take you to the same user
      // add index of list to widgets to solve problem
      width: width,
      child: Hero(
        tag: tag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: CachedNetworkImage(
              imageUrl: photo,
              imageBuilder: (context, imageProvider) => Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Container(
                padding: EdgeInsets.all(40),
                width: width,
                height: width,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(const Color(0xFF8D6E63)),
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 55,
                backgroundImage:
                    NetworkImage('https://i.imgur.com/iV7Sdgm.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
