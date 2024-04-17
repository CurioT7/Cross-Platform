import 'package:curio/Views/community/createCommunity.dart';
import 'package:flutter/material.dart';
import 'package:curio/Views/sidebars/LeftSideBarAll.dart';
import 'package:curio/services/api_service.dart'; 
import 'package:curio/Models/community_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

 class CustomSidebar extends StatefulWidget {
  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  List<Community> favoriteCommunities = [];

  Future<List<Community>> fetchCommunities(BuildContext context) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String token = sharedPrefs.getString('token')!;
    print('Fetching communities from user token: $token');
    final communities = await ApiService().getCommunities(token, context);
    return communities ?? [];
  }

  void toggleFavorite(Community community, bool isFavorite) {
  setState(() {
    if (isFavorite) {
      favoriteCommunities.add(community);
    } else {
      favoriteCommunities.remove(community);
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
                    ExpansionTile(
            title: const Text('Recently Visited'),
            children: <Widget>[
              ListTile(
                title: const Text('Subreddit 1'),
                trailing: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Implement your delete functionality here
                  },
                ),
              ),
              ListTile(
                title: const Text('Subreddit 2'),
                trailing: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Implement your delete functionality here
                  },
                ),
              ),
              ListTile(
                title: const Text('See All'),
                onTap: () {


                },
              ),
            ],
                      ),
              if (favoriteCommunities.isNotEmpty)
                        ExpansionTile(
                          title: const Text('Favorites'),
                          children: favoriteCommunities.map((community) {
                            return ListTile(
                              title: Text('r/${community.name}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.star),
                                onPressed: () => toggleFavorite(community, false),
                              ),
                            );
                          }).toList(),
                        ),

          const Divider(),
          FutureBuilder<List<Community>>(
            future: fetchCommunities(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const ListTile(
                    title: Text('Join communities to see them here'),
                  );
                } else {
                  return ExpansionTile(
                    title: const Text('Your Communities'),
                    children: <Widget>[
                      ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => {
                            Navigator.pop(context),
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => createCommunity()),
                            )
                          },
                        ),
                        title: const Text('Create a Community'),
                      ),
                      ...snapshot.data!.map((community) {
                        return ListTile(
                          title: Text('r/${community.name}'),
                          trailing: FavoriteButton(
              community: community,
              isFavorite: favoriteCommunities.contains(community),
              toggleFavorite: toggleFavorite,
            ),
                        );
                      }).toList(),
                    ],
                  );
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('All'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
 class FavoriteButton extends StatelessWidget {
  final Community community;
  final bool isFavorite;
  final Function(Community, bool) toggleFavorite;

  FavoriteButton({
    required this.community,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isFavorite ? Icons.star : Icons.star_border),
      onPressed: () {
        toggleFavorite(community, !isFavorite);
      },
    );
  }
}