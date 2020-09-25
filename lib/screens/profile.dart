import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/models/models.dart';
import 'package:bazzar/services/api.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:flutter/material.dart';
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

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedTab = 'Posts';
  double rating = 5.0;
  String reviewText = '';
  void setTab(tab) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        selectedTab = tab;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context, listen: false);
    print('building profile screen');
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
                }else if (account != null) {
                  return user != null && user['_id'] == account['_id']
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
      body: GestureDetector(onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      }, child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<UserProvider>(
                          builder: (context, providerUser, child) {
                            final user = providerUser.getUser;
                            return Container(
                              margin: EdgeInsets.only(top: 30, bottom: 20),
                              child: PhotoHero(
                                width: 110,
                                tag: widget.heroIndex,
                                photo: user == null
                                    ? widget.profileImg
                                    : widget.profileImg != user['profileImg']
                                        ? user['profileImg']
                                        : widget.profileImg,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    Center(
                      child:Text(
                        widget.username == 'Please login' ? 'Register to use all bazzar features' : widget.username,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    FutureBuilder(
                        future: providerUser.fetchUser(widget.username),
                        builder: (context, snapshot) {
                          print('snapshoot = ${snapshot.data}');
                          if (snapshot.hasData) {
                            return Container(child: Consumer<UserProvider>(
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
                                          Text(user['description'].length < 1
                                              ? 'No bio provided.'
                                              : user['description']),
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
                                              user['location'].length < 1
                                                  ? 'No Location provided.'
                                                  : user['location'],
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
                                          Text(user['createdAt']
                                              .substring(0, 10)),
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
                                          EdgeInsets.symmetric(vertical: 5),
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      child: DefaultTabController(
                                        length: 3,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              height: 40,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1),
                                              child: TabBar(
                                                labelStyle: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15),
                                                indicatorSize:
                                                    TabBarIndicatorSize.label,
                                                labelColor: Colors.black87,
                                                unselectedLabelColor:
                                                    Color(0xff5f6368),
                                                isScrollable: true,
                                                labelPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                indicator: MD2Indicator(
                                                    indicatorHeight: 3,
                                                    indicatorColor:
                                                        const Color(0xFF8D6E63),
                                                    indicatorSize:
                                                        MD2IndicatorSize
                                                            .normal),
                                                tabs: [
                                                  GestureDetector(
                                                    // onTap: () {
                                                    //   setTab('Posts');
                                                    // },
                                                    child: Container(
                                                      width: 60,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Center(
                                                        child: Text(
                                                          'Posts',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    // onTap: () {
                                                    //   setTab('Reviews');
                                                    // },
                                                    child: Container(
                                                      width: 60,
                                                      child: Tab(
                                                        child: Center(
                                                          child: Text(
                                                            'Reviews',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    // onTap: () {
                                                    //   setTab('Likes');
                                                    // },
                                                    child: Container(
                                                      width: 60,
                                                      child: Tab(
                                                        child: Center(
                                                          child: Text(
                                                            'Likes',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              height: (selectedTab == 'Reviews'
                                                      ? 92
                                                      : 130 *
                                                              user['posts']
                                                                  .length +
                                                          10)
                                                  .toDouble(),
                                              // height: 92,
                                              child: TabBarView(
                                                children: [
                                                  Column(
                                                    children: user['posts']
                                                        .map<Widget>(
                                                          (item) => Column(
                                                            children: [
                                                              PostTile(
                                                                post: item,
                                                              ),
                                                              Divider(
                                                                height: 0,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                  Column(
                                                    children: user['ratings']
                                                        .map<Widget>(
                                                          (item) => Column(
                                                            children: [
                                                              ReviewTile(
                                                                review: item,
                                                              ),
                                                              Divider(
                                                                height: 0,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                  // others uses cant see my liked
                                                  Icon(Icons.directions_bike),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return AuthBtns();
                              }
                            }));
                          } else {
                            return Expanded(
                                child: Loading(
                                    backgroundColor: Colors.transparent));
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
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
                                .getUser['username'],
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
