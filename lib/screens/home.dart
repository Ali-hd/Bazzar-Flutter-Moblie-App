import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bazzar/services/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  // @override
  // void initState() {
  //   super.initState();
  //   print('component mounted');
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<PostProvider>(context, listen: false)
  //     .fetchPosts();
  //    });
  // }

  static const List<String> cities = [
    'All',
    'Riyadh',
    'Jeddah',
    'Makkah',
    'Qatif',
    'Yanbu',
    'Hafr Al-Batin',
    'Taif',
    'Tabuk',
    'Buraydah',
    'Unaizah',
    'Jubail',
    'Jizan',
    'Al Jawf',
    'Hofuf',
    'Gurayat',
    'Dhahran',
    'Bisha',
    'Arar',
    'Abha'
  ];

  @override
  Widget build(BuildContext context) {
    final providerPost = Provider.of<PostProvider>(context, listen: true);
    final providerUser = Provider.of<UserProvider>(context, listen: false);
    if (!providerPost.getLoading && providerPost.getPosts == null) {
      providerPost.fetchPosts();
    }
    if(!providerUser.loading && providerUser.getAccount == null){
      providerUser.fetchAccout();
    }
    final Map posts = providerPost.getPosts;
    final List data = providerPost.getPostsResults;
    print('posts from provider => ${providerPost.getPosts}');
    print('WIDGET BUILD HOME');
    ScrollController _scrollController = ScrollController();

    // @override
    // void dispose(){
    //   _scrollController.dispose();
    //   super.dispose();
    // }
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: Colors.grey[300],
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              actions: [
                Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Bazzar',
                          style: TextStyle(
                              color: Colors.brown[400],
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.2),
                        ))),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.black54),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black54),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8))),
                          labelText: 'Search for anything',
                          labelStyle: TextStyle(color: Colors.black54),
                          suffixIcon: Icon(Icons.search),
                        ),
                        cursorColor: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 60,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Center(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.horizontal,
                    itemCount: cities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            providerPost.setCurrentCity(cities[index]);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              decoration:
                                  cities[index] == providerPost.getCurrentCity
                                      ? BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                          width: 2,
                                          color: Colors.brown[400],
                                        )))
                                      : null,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                cities[index],
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 7,
                    ),
                  ),
                ),
              ),
            ),
            !providerPost.getLoading
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == data.length - 1 && posts['next'] != null) {
                          providerPost.loadMore();
                          return _reachedEnd();
                        }
                        return PostCard(post: data[index]);
                      },
                      childCount: data.length,
                    ),
                  )
                : SliverFillRemaining(child: Loading()),
            // FutureBuilder(
            //     future: API().getPosts(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return SliverToBoxAdapter(
            //             child: Consumer<PostProvider>(
            //                 builder: (_, posts, __) => Container(
            //                       child: Center(child: Text('got data ${posts.getLoading}')),
            //                     )));
            //       } else {
            //         return SliverFillRemaining(child: Loading());
            //       }
            //     })
          ],
        ),
      ),
    ));
  }
}

Widget _reachedEnd() {
  print('reached bottom');
  return Padding(
    padding: EdgeInsets.all(10),
      child: Center(
      child: Column(
        children: [
              SpinKitThreeBounce(
          color: Colors.brown,
          size: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text('fetching more posts',
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),),
        )
        ],
      ),
    ),
  );
}
