import 'package:bazzar/screens/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bazzar/screens/post.dart';
import 'package:jiffy/jiffy.dart';
import 'widgets.dart';
import 'package:bazzar/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String heroIndex;
  const PostCard({Key key, @required this.post, @required this.heroIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PostScreen(
                        // https from s3 causing issues
                        postId: post.id,
                        postImg:
                            post.images[0].replaceAll('https', 'http'))));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: PhotoHero(
                        photo: post.user.profileImg
                            .replaceAll('https', 'http'),
                        width: 30,
                        tag: heroIndex,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                  username: post.user.username,
                                  profileImg: post.user.profileImg,
                                  heroIndex: heroIndex),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(post.user.username),
                                Text('${post.views} views')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(post.location),
                                Text(Jiffy(post.createdAt).fromNow())
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(post.title),
                ),
                CachedNetworkImage(
                  imageUrl: post.images[0].replaceAll('https', 'http'),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    height: 250,
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
