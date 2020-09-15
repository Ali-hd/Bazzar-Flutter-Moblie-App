import 'package:bazzar/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  const PostScreen({Key key, this.postId}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int _current = 0;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<PostProvider>(context, listen: false)
      .fetchSinglePost(widget.postId);
     });
  }

  @override
  Widget build(BuildContext context) {
    final providerPost = Provider.of<PostProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          title: Text(providerPost.getSinglePost != null ? providerPost.getSinglePost['title']: 'Loading'),
          centerTitle: true,
          backgroundColor: Colors.brown[400],
        ),
        body: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 16 / 11,
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.amber),
                        child: Text(
                          'text $i',
                          style: TextStyle(fontSize: 16.0),
                        ));
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 2, 3, 4, 5].map((url) {
                int index = [1, 2, 3, 4, 5].indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(141, 110, 99, 0.9)
                        : Color.fromRGBO(141, 110, 99, 0.4),
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }
}
