import 'package:flutter/material.dart';
import 'package:curio/Views/community/createCommunity.dart';
import 'package:curio/Views/sidebars/LeftSideBarAll.dart';
import 'package:curio/services/api_service.dart';
import 'package:curio/Models/community_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../community/profile.dart';

class CustomSidebar extends StatefulWidget {
  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  List<Community> favoriteCommunities = [];
  List<Community> communities = [];
  bool isLoading = true;


   @override
  void initState() {
    super.initState();
    fetchCommunities(context).then((value) {
      setState(() {
        communities = value;
        isLoading = false;
      });
    });
  }

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
            const SizedBox(height: 50),
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
            if (isLoading) 
              const CircularProgressIndicator(),
            if (!isLoading && communities.isEmpty) 
              const ListTile(
                title: Text('Join communities to see them here'),
              ),
            if (!isLoading && communities.isNotEmpty)
              ExpansionTile(
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
                    child: const ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Create a Community'),
                    ),
                  ),
                  ...communities.map((community) {
                    return ListTile(
                      title: Text('r/${community.name}'),
                      trailing: FavoriteButton(
                        community: community,
                        isFavorite: favoriteCommunities.contains(community),
                        toggleFavorite: toggleFavorite,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => communityProfile(communityName: community.name),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
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
