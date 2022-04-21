import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

String imageCat = 'assets/images/khbar.png';

class NewsItem {
  final String title;
  final Map<String, dynamic> user;
  final String url;
  final String text;
  final Map<String, dynamic> media;
  final String universalIdentifier;
  final String date;
  final String index;
  final String self;
  final String language;
  final String userName;
  final Map<String, dynamic> reactions;
  final String profileImageUrlHttps;
  final String topImg;
  final String image;
  NewsItem(
    this.title,
    this.user,
    this.text,
    this.date,
    this.url,
    this.media,
    this.index,
    this.self,
    this.universalIdentifier,
    this.language,
    this.userName,
    this.profileImageUrlHttps,
    this.topImg, [
    this.reactions,
    this.image,
  ]);

  getNewsUrl() {
    String url;

    if (this.user["url"] != null || this.user != null) {
      url = this
          .url
          .replaceAll('http://', '')
          .replaceAll('https://', '')
          .replaceAll('www.', '')
          .replaceAll('.com', '')
          .split('/')[0];
    } else {
      url = this.user["url"];
    }
    return url;
  }

  getNewsDate() {
    String date;
    if (this.date.indexOf("T") > -1) {
      date = this.date.split("T")[0];
    } else {
      date = this.date.split(" ")[0];
    }
    return date;
  }

  getNewsTime() {
    String time;
    if (this.date.indexOf("T") > -1) {
      time = this.date.split("T")[1].split(".")[0];
    } else {
      time = this.date.split("T")[1];
    }
    return time;
  }

  getNewsIcon() {
    Icon icon;
    if (this.index == "rss") {
      icon = Icon(
        Icons.rss_feed,
        color: Colors.indigo,
        size: 15,
      );
    } else if (this.index == "facebook_posts") {
      icon = Icon(
        Typicons.social_facebook,
        color: Colors.indigo,
        size: 15,
      );
    } else if (this.index == "twitter_tweets") {
      icon = Icon(
        Typicons.social_twitter,
        color: Colors.indigo,
        size: 15,
      );
    } else if (this.index == "generic_spiders") {
      icon = Icon(
        Typicons.rss_outline,
        color: Colors.indigo,
        size: 15,
      );
    } else {
      icon = Icon(
        Icons.rss_feed,
        color: Colors.indigo,
        size: 15,
      );
    }
    return icon;
  }

  getNewsImage() {
    String newsImage = "";
    try {
      if (this.index == "twitter_tweets") {
        if (this.media["url"] != null) {
          newsImage = this.media["url"];
          if (this.user["image"] != null) {
            newsImage = this.user["image"];
          } else {
            newsImage =
                "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Logo-khabar.png/260px-Logo-khabar.png";
          }
        } else if (this.user["image"] != null) {
          newsImage = this.user["image"];
        } else {
          newsImage =
              "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Logo-khabar.png/260px-Logo-khabar.png";
        }
      } else {
        if (this.media["url"] != null) {
          newsImage = this.media["url"];
        } else if (this.user["image"] != null) {
          newsImage = this.user["image"];
        } else {
          newsImage =
              "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Logo-khabar.png/260px-Logo-khabar.png";
        }
      }
    } catch (e) {
      newsImage =
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Logo-khabar.png/260px-Logo-khabar.png";
    }
    return newsImage;
  }

  getNewsTextDirection() {
    final TextDirection textDirectionrtl = TextDirection.rtl;
    final TextDirection textDirectiolltr = TextDirection.ltr;
    if (this.language == "ar" || this.language == null) {
      return textDirectionrtl;
    } else {
      return textDirectiolltr;
    }
  }

  getNewsTextAlign() {
    final TextAlign textAlignRight = TextAlign.right;
    final TextAlign textAlignLeft = TextAlign.left;
    if (this.language == "ar" || this.language == null) {
      return textAlignRight;
    } else {
      return textAlignLeft;
    }
  }

  getNewsUserName() {
    if (this.index == "rss") {
      return this
          .url
          .replaceAll('http://', '')
          .replaceAll('https://', '')
          .replaceAll('www.', '')
          .replaceAll('.com', '')
          .split('/')[0];
    }
    if (this.index == "twitter_tweets") {
      return '@${this.user["username"]}';
    } else {
      return this.user["username"];
    }
  }

  getAllNewsUserTitle() {
    if (this.index == "facebook_posts") {
      return this.text;
    } else {
      return this.title;
    }
  }

  getAllNewsUserName() {
    if (this.index == "facebook_posts") {
      return this.userName;
    }
    if (this.index == "rss") {
      return this
          .url
          .replaceAll('http://', '')
          .replaceAll('https://', '')
          .replaceAll('www.', '')
          .replaceAll('.com', '')
          .split('/')[0];
    }
    if (this.index == "twitter_tweets") {
      return '@${this.user["username"]}';
    } else {
      return this.user["username"];
    }
  }

  getAllNewsUserImage() {
    String newsImage = "";
    if (this.index == "twitter_tweets") {
      newsImage = this.image;
    }
    if (this.index == "facebook_posts") {
      if (this.profileImageUrlHttps != null) {
        newsImage = this.profileImageUrlHttps;
      }
    }
    if (this.index == "rss") {
      newsImage = this.topImg;
    }
    if (this.index == "telegram_posts") {
      newsImage = this.topImg;
    }
    if (newsImage == null) {
      newsImage =
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Logo-khabar.png/260px-Logo-khabar.png";
    }
    return newsImage;
  }
}
