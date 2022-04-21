import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

String imageCat = 'assets/images/khbar.png';

class CategorySources {
  String id;
  String type;
  String name;
  String data;
  String url;
  String categoryName;
  String categorySourcs;
  String icon;
  String self;

  CategorySources(
    this.id,
    this.type,
    this.name,
    this.data,
    this.url,
    this.categoryName,
    this.categorySourcs,
    this.icon,
    this.self,
  );

  getNewsIcon() {
    Icon icon;
    if (this.type == "rss") {
      icon = Icon(
        Icons.rss_feed,
        size: 15,
        color: Colors.indigo,
      );
    } else if (this.type == "facebook_posts" || this.type == "facebook") {
      icon = Icon(
        Typicons.social_facebook,
        size: 15,
        color: Colors.indigo,
      );
    } else if (this.type == "twitter-stream") {
      icon = Icon(
        Typicons.social_twitter,
        size: 15,
        color: Colors.indigo,
      );
    } else if (this.type == "generic_spiders") {
      icon = Icon(
        Typicons.rss_outline,
        color: Colors.indigo,
        size: 15,
      );
    }
    if (icon == null) {
      icon = Icon(
        Icons.rss_feed,
        color: Colors.indigo,
        size: 15,
      );
    }
    print(icon);
    return icon;
  }

  getNewsImage() {
    if (this.icon != null) {
      return Stack(
        children: <Widget>[
          ClipRRect(
            child: Image.network(
              this.icon,
              width: 83.0,
              height: 83.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Material(
              // eye button (customised radius)
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(50.0),
              ),
              color: Colors.white,

              child: InkWell(
                splashColor: Colors.white,
                // inkwell onPress colour
                child: SizedBox(
                  width: 18,
                  height: 18,
                  //customisable size of 'button'
                  child: this.getNewsIcon(),
                ),
                onTap: () {}, // or use onPressed: () {}
              ),
            ),
          ),
        ],
      );
    } else {
      if (this.type == "twitter-stream") {
        return Stack(
          children: <Widget>[
            ClipRRect(
              child: Image.network(
                "https://fuze7.com/wp-content/uploads/2016/07/Twitter-icon.png",
                width: 83.0,
                height: 83.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Material(
                // eye button (customised radius)
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(50.0),
                ),
                color: Colors.white,

                child: InkWell(
                  splashColor: Colors.white,
                  // inkwell onPress colour
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    //customisable size of 'button'
                    child: this.getNewsIcon(),
                  ),
                  onTap: () {}, // or use onPressed: () {}
                ),
              ),
            ),
          ],
        );
      } else {
        return Stack(
          children: <Widget>[
            ClipRRect(
              child: Image.asset(
                imageCat,
                width: 83.0,
                height: 83.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Material(
                // eye button (customised radius)
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(50.0),
                ),
                color: Colors.white,

                child: InkWell(
                  splashColor: Colors.white,
                  // inkwell onPress colour
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    //customisable size of 'button'
                    child: this.getNewsIcon(),
                  ),
                  onTap: () {}, // or use onPressed: () {}
                ),
              ),
            ),
          ],
        );
      }
    }
  }
}
