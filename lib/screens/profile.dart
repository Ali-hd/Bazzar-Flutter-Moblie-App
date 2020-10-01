import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/models/models.dart';
import 'package:bazzar/services/api.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String profileImg;
  final String heroIndex;
  const ProfileScreen(
      {Key key,
      @required this.username,
      @required this.profileImg,
      @required this.heroIndex})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  double rating = 5.0;
  String reviewText = '';

  @override
  void initState() {
    super.initState();
    print('widget username = ${widget.username}');
    if (widget.username != 'Please login') {
      final providerUser = Provider.of<UserProvider>(context, listen: false);
      providerUser.fetchUser(widget.username);
    }
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print('building profile screen');
    final providerUser = Provider.of<UserProvider>(context, listen: false);
    if(providerUser.getUser != null && providerUser.getUser.username != widget.username ){
      providerUser.fetchUser(widget.username);
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.username),
            centerTitle: false,
            backgroundColor: const Color(0xFF8D6E63),
            actions: [
              Consumer<UserProvider>(
                builder: (context, providerUser, child) {
                  final user = providerUser.getUser;
                  final account = providerUser.getAccount;
                  if (providerUser.loading) {
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: SizedBox(
                          width: 25,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(Colors.black54),
                          ),
                        ));
                  } else if (account != null) {
                    return user != null && user.id == account['_id']
                        ? Container(
                            child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileSettings(
                                      user: user,
                                    ),
                                  ));
                                },
                                icon: Icon(
                                  Icons.settings,
                                  size: 21,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Settings',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )),
                          )
                        : Container(
                            child: FlatButton.icon(
                                onPressed: () {
                                  _openReview(context);
                                },
                                icon: Icon(
                                  Icons.rate_review,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Rate',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                )),
                          );
                  } else {
                    return Container();
                  }
                },
              )
            ]),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: NestedScrollView(headerSliverBuilder:
              (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                // sliveroverlap and sliver safeArea prevents list item from getting under sliver pinned header
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    floating: widget.username == 'Please login' ? false : true,
                    pinned: widget.username == 'Please login' ? false : true,
                    expandedHeight:
                        widget.username == 'Please login' ? 200 : 450,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<UserProvider>(
                                  builder: (context, providerUser, child) {
                                    final user = providerUser.getUser;
                                    return Container(
                                      margin:
                                          EdgeInsets.only(top: 30, bottom: 20),
                                      child: PhotoHero(
                                        width: 110,
                                        tag: widget.heroIndex,
                                        photo: widget.username == 'Please login'
                                            ? widget.profileImg
                                            : user == null
                                                ? widget.profileImg
                                                : widget.profileImg !=
                                                        user.profileImg
                                                    ? user.profileImg
                                                    : widget.profileImg,
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            Center(
                              child: Text(
                                widget.username == 'Please login'
                                    ? 'Register to use all bazzar features'
                                    : widget.username,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Consumer<UserProvider>(
                                builder: (context, providerUser, child) {
                              final user = providerUser.getUser;
                              if (user != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Info',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Divider(),
                                          Text(user.description.length < 1
                                              ? 'No bio provided.'
                                              : user.description),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Bio',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          Divider(),
                                          // added a sizedbox because arabic text takes more height
                                          SizedBox(
                                            height: 18,
                                            child: Text(
                                              user.location.length < 1
                                                  ? 'No Location provided.'
                                                  : user.location,
                                              maxLines: 1,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Location',
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                          Divider(),
                                          Text(Jiffy(user.createdAt)
                                              .format("MMMM do yyyy")),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Member since',
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3),
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        )),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(45),
                      child: Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Consumer<UserProvider>(
                            builder: (context, providerUser, child) {
                              if (widget.username != 'Please login') {
                                return TabBar(
                                  controller: controller,
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelColor: Colors.black87,
                                  unselectedLabelColor: Color(0xff5f6368),
                                  isScrollable: true,
                                  labelPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  indicator: MD2Indicator(
                                      indicatorHeight: 4,
                                      indicatorColor: const Color(0xFF8D6E63),
                                      indicatorSize: MD2IndicatorSize.normal),
                                  tabs: [
                                    Container(
                                      width: 60,
                                      child: Tab(
                                        child: Center(
                                          child: Text(
                                            'Posts',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      child: Tab(
                                        child: Center(
                                          child: Text(
                                            'Reviews',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      child: Tab(
                                        child: Center(
                                          child: Text(
                                            'Likes',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          )),
                    ),
                  ),
                ),
              ),
            ];
          }, body:
              Consumer<UserProvider>(builder: (context, providerUser, child) {
            final _account = providerUser.getAccount;
            final user = providerUser.getUser;
            if (user != null && widget.username != 'Please login') {
              return TabBarView(
                controller: controller,
                children: [
                  ListView.builder(
                    itemCount: user.posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          PostTile(
                            post: user.posts[index],
                          ),
                          Divider(
                            height: 0,
                          )
                        ],
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: user.ratings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ReviewTile(
                            review: user.ratings[index],
                          ),
                          Divider(
                            height: 0,
                          )
                        ],
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: user.liked.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          PostTile(
                            post: user.liked[index],
                          ),
                          Divider(
                            height: 0,
                          )
                        ],
                      );
                    },
                  ),
                ],
              );
            } else if (_account == null && !providerUser.loading && widget.username == 'Please login') {
              return AuthBtns();
            } else {
              return Loading(
                backgroundColor: Colors.transparent,
              );
            }
          })),
        ));
  }

  void _openReview(context) {
    showModalBottomSheet(
        context: context,
        // isScrollControlled: false,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 60),
                        SmoothStarRating(
                            allowHalfRating: true,
                            onRated: (value) {
                              print('rating value = $value');
                            },
                            starCount: 5,
                            rating: rating,
                            size: 30,
                            isReadOnly: false,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            color: Colors.yellow,
                            borderColor: Colors.yellow,
                            spacing: 0.0),
                        SizedBox(height: 15),
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'How was your experience?',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            focusColor: const Color(0xFF8D6E63),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black54),
                            ),
                          ),
                          cursorColor: const Color(0xFF8D6E63),
                          maxLines: null,
                          onChanged: (text) {
                            reviewText = text;
                          },
                        )
                      ]),
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: ClipOval(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: SizedBox(
                    width: 80,
                    height: 30,
                    child: RaisedButton(
                      onPressed: () async {
                        final values =
                            ReviewUser(star: rating, description: reviewText);
                        dynamic response = await API().rateUser(
                            Provider.of<UserProvider>(context, listen: false)
                                .getUser.username,
                            values);
                        print(response.body);
                        Navigator.pop(context);
                      },
                      color: const Color(0xFF8D6E63),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
