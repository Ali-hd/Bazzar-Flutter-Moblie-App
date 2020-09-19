import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  

  

  @override
  Widget build(BuildContext context) {
    final providerPost = Provider.of<PostProvider>(context, listen: true);
    final providerUser = Provider.of<UserProvider>(context, listen: false);
    if (!providerPost.getLoading && providerPost.getPosts == null) {
      providerPost.fetchPosts();
    }
    if (!providerUser.loading && providerUser.getAccount == null) {
      providerUser.fetchAccout();
    }
    final Map posts = providerPost.getPosts;
    final List data = providerPost.getPostsResults;
    print('posts from provider => ${providerPost.getPosts}');
    print('WIDGET BUILD HOME');

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
                        letterSpacing: -1.2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.black54),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black54),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(8),
                            ),
                          ),
                          labelText: 'Search for anything',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          suffixIcon: providerPost.searchLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  child: SizedBox(
                                    width: 3,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.brown[400]),
                                    ),
                                  ),
                                )
                              : Icon(Icons.search),
                        ),
                        cursorColor: Colors.black54,
                        onChanged: (text) {
                          print(text);
                          providerPost.searchPosts(text);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: CitiesFilter(),
            ),
            SliverToBoxAdapter(
              child: TimeFilter(),
            ),
            !providerPost.getLoading
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == data.length - 1 && posts['next'] != null) {
                          providerPost.loadMore();
                          return _reachedEnd();
                        }
                        return PostCard(
                            post: data[index], heroIndex: index.toString());
                      },
                      childCount: data.length,
                    ),
                  )
                : SliverFillRemaining(
                    child: Loading(),
                  ),
          ],
        ),
      ),
    ));
  }
}

Widget _reachedEnd() {
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
            child: Text(
              'fetching more posts',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    ),
  );
}
