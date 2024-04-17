import 'package:flutter/material.dart';
import 'package:curio/Views/community/createCommunity.dart';
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
        if (!favoriteCommunities.any((x) => x.id == community.id)) {
          favoriteCommunities.add(community);
          print('Added to favorites: ${community.name}');
        }
      } else {
        int index = favoriteCommunities.indexWhere((x) => x.id == community.id);
        if (index != -1) {
          favoriteCommunities.removeAt(index);
          print('Removed from favorites: ${community.name}');
        }
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
                onTap: () {},
              ),
            ],
          ),
          if (favoriteCommunities.isNotEmpty)
            ExpansionTile(
              title: const Text('Favorites'),
              children: favoriteCommunities.map((community) {
                return ListTile(
                  title: Text('r/${community.name}'),
                  trailing: FavoriteButton(
                    community: community,
                    isFavorite: favoriteCommunities.contains(community),
                    toggleFavorite: toggleFavorite,
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
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => createCommunity()),
                            );
                          },
                          child: ListTile(
                            leading: Icon(Icons.add),
                            title: Text('Create a Community'),
                          ),
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
