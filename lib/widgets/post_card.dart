import 'package:flutter/material.dart';
import 'package:bazzar/screens/post.dart';

class PostCard extends StatelessWidget {
  final Map post;
  const PostCard({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=> PostScreen(
              postId: post['_id']
            )
          ));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(post['user']['profileImg']),
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
                              Text(post['user']['username']),
                              Text('${post['views']} views')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post['location']),
                              Text('4 months ago')
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
                child: Text(post['title']),
              ),
              Image(
                image: NetworkImage(post['images'][0]),
                height: 250,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }
}
