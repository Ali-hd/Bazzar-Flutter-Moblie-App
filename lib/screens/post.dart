import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false)
          .fetchSinglePost(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerPost = Provider.of<PostProvider>(context, listen: true);
    final post = providerPost.getSinglePost;
    final _account =
        Provider.of<UserProvider>(context, listen: false).getAccount;
    final List<dynamic> imgList =
        post != null ? post['images'] : [widget.postImg];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Image.network(item.replaceAll('https', 'http'),
                          fit: BoxFit.cover, width: 1000.0)),
                ),
              ),
            ))
        .toList();

    // String readTimestamp(int timestamp) {
    // var now = DateTime.now();
    // var format = DateFormat('HH:mm a');
    // var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    // var diff = now.difference(date);
    // var time = '';

    // if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    //   time = format.format(date);
    // } else if (diff.inDays > 0 && diff.inDays < 7) {
    //   if (diff.inDays == 1) {
    //     time = diff.inDays.toString() + ' DAY AGO';
    //   } else {
    //     time = diff.inDays.toString() + ' DAYS AGO';
    //   }
    // } else {
    //   if (diff.inDays == 7) {
    //     time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
    //   } else {

    //     time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
    //   }
    // }

    // return time;
    // }

    final List<Widget> comments = post != null && post['comments'].length > 0
        ? post['comments']
            .map<Widget>((comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(comment['user']
                              ['profileImg']
                          .replaceAll('https', 'http')),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(comment['createdAt']),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                comment['description'],
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ))
            .toList()
        : [Text('No Comments')];

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            post != null ? post['title'] : 'Loading..',
            style:
                TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.brown[400],
          actions: [
            providerPost.spLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: SizedBox(
                      width: 25,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation(Colors.black54),
                      ),
                    ))
                : Container()
          ],
        ),
        // only reason for using the Layoutbuilder is to make the loader expand to the remaining height
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 5,
                            left: 10,
                            right: 10,
                          ),
                          color: Colors.white,
                          child: Text(
                            post != null ? post['title'] : '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    child: CarouselSlider(
                      items: imageSliders,
                      options: CarouselOptions(
                          aspectRatio: 16 / 11,
                          viewportFraction: 0.9,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.map((url) {
                        int index = imgList.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Color.fromRGBO(141, 110, 99, 0.9)
                                : Color.fromRGBO(141, 110, 99, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  post != null
                      ? Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 15,
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
                                        Text('Submitted: 2 months ago'),
                                      ]),
                                      // Row(children: [
                                      //   Icon(
                                      //     Icons.equalizer,
                                      //     size: 15,
                                      //   ),
                                      //   Text('Views: ${post['views']}'),
                                      // ])
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
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(
                                              post['user']['profileImg']
                                                  .replaceAll('https', 'http')),
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
                                      )),
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
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(
                                              _account['profileImg']
                                                  .replaceAll('https', 'http')),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            enabled: true,
                                            minLines: 2,
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            textAlign: TextAlign.start,
                                            cursorWidth: 1,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          const Radius.circular(
                                                              4))),
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              hintText: 'Post a comment',
                                              labelStyle: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            cursorColor: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: constraint.maxHeight - 290),
                          child: Loading(),
                        ),
                ],
              ),
            );
          }),
        ));
  }
}
