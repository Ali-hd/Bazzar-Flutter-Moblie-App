import 'package:bazzar/Providers/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverHeader implements SliverPersistentHeaderDelegate {
  final SinglePostProvider providerPost;
  final UserProvider providerUser;
  final String postImg;
  final Function setIndex;
  final int currentIndex;

  SliverHeader({
    this.providerPost,
    this.providerUser,
    this.postImg,
    this.setIndex,
    this.currentIndex,
    this.minExtent,
    this.maxExtent,
  });
  double maxExtent;
  double minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final post = providerPost.getSinglePost;
    final _account = providerUser.getAccount;
    final List<dynamic> imgList = post != null ? post['images'] : [postImg];

    final List<Widget> imageSliders = imgList
        .map(
          (item) => Container(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: item.replaceAll('https', 'http'),
                imageBuilder: (context, imageProvider) => Container(
                  height: 270,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        )
        .toList();

    return Stack(alignment: Alignment.center, children: [
      Container(
        color: Colors.black,
        child: imgList.length > 1
            ? CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    height: shrinkOffset >= 158 ? 112 : 270 - shrinkOffset,
                    // aspectRatio: 16 / 11,
                    enlargeCenterPage: true,
                    viewportFraction: 1.03,
                    onPageChanged: (index, reason) {
                      setIndex(index);
                    }),
              )
            : CachedNetworkImage(
                imageUrl: postImg,
                imageBuilder: (context, imageProvider) => Container(
                  height: 270,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
      ),
      imgList.length > 1
          ? Positioned(
              bottom: 20,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[700]),
                        color: currentIndex == index
                            ? Color.fromRGBO(208, 209, 214, 1)
                            : Color.fromRGBO(208, 209, 214, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          : Container(),
      Positioned(
        top: 10,
        left: 10,
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 10,
                    ),
                  ]),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 10,
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                if (_account != null && post != null) {
                  String likeType = await providerPost.handleLike(postImg);
                  print('like type = $likeType');
                  providerUser.handlePostLike(likeType, post['_id']);
                }
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 10,
                    ),
                  ]),
                  child: Icon(
                    _account != null &&
                            post != null &&
                            _account['liked'].contains(post['_id'])
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _account != null &&
                            post != null &&
                            _account['liked'].contains(post['_id'])
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}
