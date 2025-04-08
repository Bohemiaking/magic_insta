import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magic_insta/utils/constants/app_enums.dart';

class InstagramPostModel {
  String? inputUrl;
  String? id;
  InstagramPostType? type;
  String? shortCode;
  String? caption;
  List<String>? hashtags;
  List<dynamic>? mentions;
  String? url;
  int? commentsCount;
  int? dimensionsHeight;
  int? dimensionsWidth;
  String? displayUrl;
  List<String>? images;
  String? videoURL;
  String? alt;
  int? likesCount;
  DateTime? timestamp;
  List<ChildPost>? childPosts;
  String? locationName;
  String? locationId;
  String? ownerFullName;
  String? ownerUsername;
  String? ownerId;
  bool? isSponsored;

  InstagramPostModel({
    this.inputUrl,
    this.id,
    this.type,
    this.shortCode,
    this.caption,
    this.hashtags,
    this.mentions,
    this.url,
    this.commentsCount,
    this.dimensionsHeight,
    this.dimensionsWidth,
    this.displayUrl,
    this.images,
    this.videoURL,
    this.alt,
    this.likesCount,
    this.timestamp,
    this.childPosts,
    this.locationName,
    this.locationId,
    this.ownerFullName,
    this.ownerUsername,
    this.ownerId,
    this.isSponsored,
  });

  factory InstagramPostModel.fromJson(Map<String, dynamic> json) =>
      InstagramPostModel(
        inputUrl: json["inputUrl"],
        id: json["id"],
        type:
            json["type"] == 'Video'
                ? InstagramPostType.video
                : json['type'] == 'Sidecar'
                ? InstagramPostType.sidecar
                : InstagramPostType.singleImage,
        shortCode: json["shortCode"],
        caption: json["caption"],
        hashtags:
            json["hashtags"] == null
                ? []
                : List<String>.from(json["hashtags"]!.map((x) => x)),
        mentions:
            json["mentions"] == null
                ? []
                : List<dynamic>.from(json["mentions"]!.map((x) => x)),
        url: json["url"],
        commentsCount: json["commentsCount"],
        dimensionsHeight: json["dimensionsHeight"],
        dimensionsWidth: json["dimensionsWidth"],
        displayUrl: json["displayUrl"],
        images:
            json["images"] == null
                ? null
                : List<String>.from(json["images"]!.map((x) => x)),
        videoURL: json['videoUrl'],
        alt: json["alt"],
        likesCount: json["likesCount"],
        timestamp:
            json["timestamp"] == null
                ? null
                : DateTime.parse(json["timestamp"]),
        childPosts:
            json["childPosts"] == null
                ? []
                : List<ChildPost>.from(
                  json["childPosts"]!.map((x) => ChildPost.fromJson(x)),
                ),
        locationName: json["locationName"],
        locationId: json["locationId"],
        ownerFullName: json["ownerFullName"],
        ownerUsername: json["ownerUsername"],
        ownerId: json["ownerId"],
        isSponsored: json["isSponsored"],
      );

  Map<String, dynamic> toJson() => {
    "inputUrl": inputUrl,
    "id": id,
    "type":
        type == InstagramPostType.video
            ? 'Video'
            : type == InstagramPostType.sidecar
            ? 'Sidecar'
            : 'Image',
    "shortCode": shortCode,
    "caption": caption,
    "hashtags":
        hashtags == null ? [] : List<dynamic>.from(hashtags!.map((x) => x)),
    "mentions":
        mentions == null ? [] : List<dynamic>.from(mentions!.map((x) => x)),
    "url": url,
    "commentsCount": commentsCount,
    "dimensionsHeight": dimensionsHeight,
    "dimensionsWidth": dimensionsWidth,
    "displayUrl": displayUrl,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "alt": alt,
    "likesCount": likesCount,
    "videoUrl": videoURL,
    "timestamp": timestamp?.toIso8601String(),
    "childPosts":
        childPosts == null
            ? []
            : List<dynamic>.from(childPosts!.map((x) => x.toJson())),
    "locationName": locationName,
    "locationId": locationId,
    "ownerFullName": ownerFullName,
    "ownerUsername": ownerUsername,
    "ownerId": ownerId,
    "isSponsored": isSponsored,
    'createdAt': FieldValue.serverTimestamp(),
  };
}

class ChildPost {
  String? id;
  String? type;
  String? shortCode;
  String? caption;
  List<dynamic>? hashtags;
  List<dynamic>? mentions;
  String? url;
  int? commentsCount;
  String? firstComment;
  List<dynamic>? latestComments;
  int? dimensionsHeight;
  int? dimensionsWidth;
  String? displayUrl;
  List<dynamic>? images;
  String? alt;
  dynamic likesCount;
  dynamic timestamp;
  List<dynamic>? childPosts;
  dynamic ownerId;

  ChildPost({
    this.id,
    this.type,
    this.shortCode,
    this.caption,
    this.hashtags,
    this.mentions,
    this.url,
    this.commentsCount,
    this.firstComment,
    this.latestComments,
    this.dimensionsHeight,
    this.dimensionsWidth,
    this.displayUrl,
    this.images,
    this.alt,
    this.likesCount,
    this.timestamp,
    this.childPosts,
    this.ownerId,
  });

  factory ChildPost.fromJson(Map<String, dynamic> json) => ChildPost(
    id: json["id"],
    type: json["type"],
    shortCode: json["shortCode"],
    caption: json["caption"],
    hashtags:
        json["hashtags"] == null
            ? []
            : List<dynamic>.from(json["hashtags"]!.map((x) => x)),
    mentions:
        json["mentions"] == null
            ? []
            : List<dynamic>.from(json["mentions"]!.map((x) => x)),
    url: json["url"],
    commentsCount: json["commentsCount"],
    firstComment: json["firstComment"],
    latestComments:
        json["latestComments"] == null
            ? []
            : List<dynamic>.from(json["latestComments"]!.map((x) => x)),
    dimensionsHeight: json["dimensionsHeight"],
    dimensionsWidth: json["dimensionsWidth"],
    displayUrl: json["displayUrl"],
    images:
        json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
    alt: json["alt"],
    likesCount: json["likesCount"],
    timestamp: json["timestamp"],
    childPosts:
        json["childPosts"] == null
            ? []
            : List<dynamic>.from(json["childPosts"]!.map((x) => x)),
    ownerId: json["ownerId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "shortCode": shortCode,
    "caption": caption,
    "hashtags":
        hashtags == null ? [] : List<dynamic>.from(hashtags!.map((x) => x)),
    "mentions":
        mentions == null ? [] : List<dynamic>.from(mentions!.map((x) => x)),
    "url": url,
    "commentsCount": commentsCount,
    "firstComment": firstComment,
    "latestComments":
        latestComments == null
            ? []
            : List<dynamic>.from(latestComments!.map((x) => x)),
    "dimensionsHeight": dimensionsHeight,
    "dimensionsWidth": dimensionsWidth,
    "displayUrl": displayUrl,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "alt": alt,
    "likesCount": likesCount,
    "timestamp": timestamp,
    "childPosts":
        childPosts == null ? [] : List<dynamic>.from(childPosts!.map((x) => x)),
    "ownerId": ownerId,
  };
}
