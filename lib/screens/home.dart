import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:bazzar/models/models.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool refreshLoading = false;
  @override
  // ignore: must_call_super
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
    final List<Post> data = providerPost.getPostsResults;
    print('posts from provider => ${providerPost.getPosts}');
    print('WIDGET BUILD HOME');

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.grey[300],
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  floating: true,
                  pinned: false,
                  actions: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Bazzar',
                          style: TextStyle(
                            color: const Color(0xFF8D6E63),
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
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.black54),
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
                                          vertical: 12, horizontal: 14),
                                      child: SizedBox(
                                        width: 4,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation(
                                                  const Color(0xFF8D6E63)),
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
              ];
            },
            body: RefreshIndicator(
              onRefresh: () async {
                FocusScope.of(context).unfocus();
                setState(() {
                  refreshLoading = true;
                });
                await providerPost.fetchPosts();
                setState(() {
                  refreshLoading = false;
                });
              },
              child: !providerPost.getLoading || refreshLoading
                  ? ListView.builder(
                    padding: EdgeInsets.all(0),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        if (index == data.length - 1 &&
                            posts['next'] != null) {
                          providerPost.loadMore();
                          return _reachedEnd();
                        }
                        return PostCard(
                          post: data[index],
                          heroIndex: index.toString(),
                        );
                      },
                    )
                  : Loading(
                      backgroundColor: Colors.transparent,
                    ),
            ),
          ),
        ),
      ),
    );
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
