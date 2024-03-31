class AccountInfo {
  AccountInfo({
    required this.images,
    required this.rememberPerCommunity,
    required this.id,
    required this.username,
    required this.gender,
    required this.language,
    required this.locationCustomization,
    required this.displayName,
    required this.about,
    required this.socialLinks,
    required this.nSFW,
    required this.allowFollow,
    required this.contentVisibility,
    required this.activeInCommunityVisibility,
    required this.clearHistory,
    required this.block,
    required this.viewBlockedPeople,
    required this.mute,
    required this.viewMutedCommunities,
    required this.adultContent,
    required this.autoPlayMedia,
    required this.communityThemes,
    required this.communityContentSort,
    required this.globalContentView,
    required this.openPostsInNewTab,
    required this.mentions,
    required this.comments,
    required this.upvotesPosts,
    required this.upvotesComments,
    required this.replies,
    required this.newFollowers,
    required this.postsYouFollow,
    required this.newFollowerEmail,
    required this.chatRequestEmail,
    required this.unsubscribeFromAllEmails,
    required this.v,
  });
  late final Images images;
  late final RememberPerCommunity rememberPerCommunity;
  late final String id;
  late final String username;
  late final String gender;
  late final String language;
  late final String locationCustomization;
  late final String displayName;
  late final String about;
  late final String socialLinks;
  late final bool nSFW;
  late final bool allowFollow;
  late final bool contentVisibility;
  late final bool activeInCommunityVisibility;
  late final bool clearHistory;
  late final List<Block> block;
  late final List<ViewBlockedPeople> viewBlockedPeople;
  late final List<Mute> mute;
  late final List<ViewMutedCommunities> viewMutedCommunities;
  late final bool adultContent;
  late final bool autoPlayMedia;
  late final bool communityThemes;
  late final String communityContentSort;
  late final String globalContentView;
  late final bool openPostsInNewTab;
  late final bool mentions;
  late final bool comments;
  late final bool upvotesPosts;
  late final bool upvotesComments;
  late final bool replies;
  late final bool newFollowers;
  late final bool postsYouFollow;
  late final bool newFollowerEmail;
  late final bool chatRequestEmail;
  late final bool unsubscribeFromAllEmails;
  late final int v;

  AccountInfo.fromJson(Map<String, dynamic> json) {
    images = Images.fromJson(json['images']);
    rememberPerCommunity =
        RememberPerCommunity.fromJson(json['rememberPerCommunity']);
    id = json['_id'];
    username = json['username'];
    gender = json['gender'];
    language = json['language'];
    locationCustomization = json['locationCustomization'];
    displayName = json['displayName'];
    about = json['about'];
    socialLinks = json['socialLinks'];
    nSFW = json['NSFW'];
    allowFollow = json['allowFollow'];
    contentVisibility = json['contentVisibility'];
    activeInCommunityVisibility = json['activeInCommunityVisibility'];
    clearHistory = json['clearHistory'];
    block = List.from(json['block']).map((e) => Block.fromJson(e)).toList();
    viewBlockedPeople = List.from(json['viewBlockedPeople'])
        .map((e) => ViewBlockedPeople.fromJson(e))
        .toList();
    mute = List.from(json['mute']).map((e) => Mute.fromJson(e)).toList();
    viewMutedCommunities = List.from(json['viewMutedCommunities'])
        .map((e) => ViewMutedCommunities.fromJson(e))
        .toList();
    adultContent = json['adultContent'];
    autoPlayMedia = json['autoplayMedia'];
    communityThemes = json['communityThemes'];
    communityContentSort = json['communityContentSort'];
    globalContentView = json['globalContentView'];
    openPostsInNewTab = json['openPostsInNewTab'];
    mentions = json['mentions'];
    comments = json['comments'];
    upvotesPosts = json['upvotesPosts'];
    upvotesComments = json['upvotesComments'];
    replies = json['replies'];
    newFollowers = json['newFollowers'];
    postsYouFollow = json['postsYouFollow'];
    newFollowerEmail = json['newFollowerEmail'];
    chatRequestEmail = json['chatRequestEmail'];
    unsubscribeFromAllEmails = json['unsubscribeFromAllEmails'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['images'] = images.toJson();
    data['rememberPerCommunity'] = rememberPerCommunity.toJson();
    data['_id'] = id;
    data['username'] = username;
    data['gender'] = gender;
    data['language'] = language;
    data['locationCustomization'] = locationCustomization;
    data['displayName'] = displayName;
    data['about'] = about;
    data['socialLinks'] = socialLinks;
    data['NSFW'] = nSFW;
    data['allowFollow'] = allowFollow;
    data['contentVisibility'] = contentVisibility;
    data['activeInCommunityVisibility'] = activeInCommunityVisibility;
    data['clearHistory'] = clearHistory;
    data['block'] = block.map((e) => e.toJson()).toList();
    data['viewBlockedPeople'] =
        viewBlockedPeople.map((e) => e.toJson()).toList();
    data['mute'] = mute.map((e) => e.toJson()).toList();
    data['viewMutedCommunities'] =
        viewMutedCommunities.map((e) => e.toJson()).toList();
    data['adultContent'] = adultContent;
    data['autoplayMedia'] = autoPlayMedia;
    data['communityThemes'] = communityThemes;
    data['communityContentSort'] = communityContentSort;
    data['globalContentView'] = globalContentView;
    data['openPostsInNewTab'] = openPostsInNewTab;
    data['mentions'] = mentions;
    data['comments'] = comments;
    data['upvotesPosts'] = upvotesPosts;
    data['upvotesComments'] = upvotesComments;
    data['replies'] = replies;
    data['newFollowers'] = newFollowers;
    data['postsYouFollow'] = postsYouFollow;
    data['newFollowerEmail'] = newFollowerEmail;
    data['chatRequestEmail'] = chatRequestEmail;
    data['unsubscribeFromAllEmails'] = unsubscribeFromAllEmails;
    data['__v'] = v;
    return data;
  }
}

class Images {
  Images({
    required this.pfp,
    required this.banner,
  });
  late final String pfp;
  late final String banner;

  Images.fromJson(Map<String, dynamic> json) {
    pfp = json['pfp'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pfp'] = pfp;
    data['banner'] = banner;
    return data;
  }
}

class RememberPerCommunity {
  RememberPerCommunity({
    required this.rememberContentSort,
    required this.rememberContentView,
  });
  late final bool rememberContentSort;
  late final bool rememberContentView;

  RememberPerCommunity.fromJson(Map<String, dynamic> json) {
    rememberContentSort = json['rememberContentSort'];
    rememberContentView = json['rememberContentView'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rememberContentSort'] = rememberContentSort;
    data['rememberContentView'] = rememberContentView;
    return data;
  }
}

class Block {
  Block({
    required this.username,
    required this.id,
  });
  late final String username;
  late final String id;

  Block.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['_id'] = id;
    return data;
  }
}

class ViewBlockedPeople {
  ViewBlockedPeople({
    required this.username,
    required this.id,
  });
  late final String username;
  late final String id;

  ViewBlockedPeople.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['_id'] = id;
    return data;
  }
}

class Mute {
  Mute({
    required this.username,
    required this.id,
  });
  late final String username;
  late final String id;

  Mute.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['_id'] = id;
    return data;
  }
}

class ViewMutedCommunities {
  ViewMutedCommunities({
    required this.communityId,
    required this.id,
  });
  late final String communityId;
  late final String id;

  ViewMutedCommunities.fromJson(Map<String, dynamic> json) {
    communityId = json['communityId'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['communityId'] = communityId;
    data['_id'] = id;
    return data;
  }
}
