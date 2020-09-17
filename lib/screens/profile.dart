import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchUser(widget.username);
    });
  }

  String selectedTab = 'Posts';

  void setTab(tab) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        selectedTab = tab;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context, listen: true);
    final user = providerUser.getUser;
    print('building profile screen');
    print(user);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.username),
          centerTitle: false,
          backgroundColor: Colors.brown[400],
          actions: [
            providerUser.loading
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
          ]),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 20),
                    child: PhotoHero(
                      width: 110,
                      tag: widget.heroIndex,
                      photo: widget.profileImg,
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  widget.username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                child: user != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: TextStyle(color: Colors.grey[600]),
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
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Divider(),
                                Text(user['createdAt'].substring(0, 10)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Member since',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            color: Colors.grey,
                          ),
                          Container(
                            child: DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    height: 40,
                                    padding: EdgeInsets.symmetric(vertical: 1),
                                    child: TabBar(
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
                                          indicatorHeight: 3,
                                          indicatorColor: Colors.brown[400],
                                          indicatorSize:
                                              MD2IndicatorSize.normal),
                                      tabs: [
                                        GestureDetector(
                                          // onTap: () {
                                          //   setTab('Posts');
                                          // },
                                          child: Container(
                                            width: 60,
                                            padding: EdgeInsets.all(0),
                                            child: Center(
                                              child: Text(
                                                'Posts',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                          FontWeight.w700),
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
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    height: (selectedTab == 'Reviews'
                                            ? 92
                                            : 130 * user['posts'].length + 10)
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
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
