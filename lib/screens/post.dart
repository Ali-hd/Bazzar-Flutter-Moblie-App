import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/screens/profile.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:bazzar/widgets/widgets.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  final String postImg;
  const PostScreen({Key key, this.postId, this.postImg}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int _current = 0;
  String commentText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SinglePostProvider>(context, listen: false)
          .fetchSinglePost(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerPost = Provider.of<SinglePostProvider>(context, listen: true);
    final providerUser = Provider.of<UserProvider>(context, listen: true);
    final post = providerPost.getSinglePost;
    final _account = providerUser.getAccount;

    final List<Widget> comments = post != null && post['comments'].length > 0
        ? post['comments']
            .map<Widget>((comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    PhotoHero(
                      photo: comment['user']['profileImg']
                          .replaceAll('https', 'http'),
                      width: 30,
                      tag: comment['createdAt'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                username: comment['user']['username'],
                                profileImg: comment['user']['profileImg']
                                    .replaceAll('https', 'http'),
                                heroIndex: comment['createdAt']),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment['user']['username'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(' • '),
                              Text(Jiffy(comment['createdAt']).format("MM/d/yyy, hh:mm:ss a")),
                            ],
                          ),
                          Text(
                            comment['description'],
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ))
            .toList()
        : [Text('No Comments')];

    void setCommentText(String text) {
      setState(() {
        commentText = text;
      });
    }

    void setIndex(int index){
      setState(() {
        _current = index;
      });
    }

    void postComment() async {
      await providerPost.comment(commentText, post['_id']);
    }

    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return PostBottomSheet(
            setCommentText: setCommentText,
            postComment: postComment,
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: Colors.grey[300],
        // only reason for using the Layoutbuilder is to make the loader expand to the remaining height
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
              child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeader(
                  providerPost: providerPost,
                  providerUser: providerUser,
                  postImg: widget.postImg,
                  setIndex: setIndex,
                  currentIndex: _current,
                  minExtent: 100,
                  maxExtent: 270,
                )
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              post != null
                  ? SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    post['title'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    post['description'],
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            PostDivider(label: 'Post Information'),
                            Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Icon(
                                          Icons.place,
                                          size: 15,
                                        ),
                                        Text('Location: ${post['location']}'),
                                      ]),
                                      Row(children: [
                                        Icon(
                                          Icons.equalizer,
                                          size: 15,
                                        ),
                                        Text('Views: ${post['views']}'),
                                      ])
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Icon(
                                          Icons.date_range,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text('Submitted: ${Jiffy(post['createdAt']).format("MMM do yyyy")}')
                                      ]),
                                      Row(children: [
                                        Icon(
                                          Icons.favorite_border,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text('Likes: ${post['likes']}'),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  PostDivider(
                                    label: 'Seller Information',
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: PhotoHero(
                                          photo: post['user']['profileImg']
                                              .replaceAll('https', 'http'),
                                          width: 32,
                                          tag: 'seller',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ProfileScreen(
                                                    username: post['user']
                                                        ['username'],
                                                    profileImg: post['user']
                                                            ['profileImg']
                                                        .replaceAll(
                                                            'https', 'http'),
                                                    heroIndex: 'seller'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        post['user']['username'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'OpenSans',
                                            color: Colors.black87),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 10,
                                    thickness: 1,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    children: comments,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        bottom: 20, top: 10),
                                    child: 
                                    _account != null ?
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(
                                            _account['profileImg']
                                                .replaceAll('https', 'http'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              _settingModalBottomSheet(
                                                  context);
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey[600]),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(4),
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 10),
                                              child: Text('Post a comment'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ) : Container(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverFillRemaining(
                      child: Loading(),
                    ),
            ],
          )),
        ));
  }
}
