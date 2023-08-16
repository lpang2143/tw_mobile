import 'package:flutter/material.dart';

class Performer {
  int performerId;
  String performerName;
  String performerType;
  String logoImgUrl;
  String color;

  Performer({
    required this.performerId,
    required this.performerName,
    required this.performerType,
    required this.logoImgUrl,
    required this.color,
  });

  factory Performer.fromJson(Map<String, dynamic> json) {
    return Performer(
      performerId: json['performer_id'],
      performerName: json['performer_name'],
      performerType: json['performer_type'],
      logoImgUrl: json['logo_img_url'],
      color: json['color'],
    );
  }

  static List<Performer> fromJsonList(List<dynamic> jsonList) {
    List<Performer> performers = [];
    for (var json in jsonList) {
      performers.add(Performer.fromJson(json));
    }
    return performers;
  }

  Map<String, dynamic> toJson() {
    return {
      'performer_id': performerId,
      'performer_name': performerName,
      'performer_type': performerType,
      'logo_img_url': logoImgUrl,
      'color': color,
    };
  }

  int getPerformerId() {
    return performerId;
  }

  String getPerformerName() {
    return performerName;
  }

  String getPerformerType() {
    return performerType;
  }

  String getLogoImgUrl() {
    return logoImgUrl;
  }

  Widget getLogoImage() {
    return Image.network(logoImgUrl);
  }

  String getColor() {
    return color;
  }
}

String getAttributeValueById(
    List<Performer> performers, int performerId, String attributeName) {
  for (Performer performer in performers) {
    if (performer.getPerformerId() == performerId) {
      switch (attributeName) {
        case 'performerName':
          return performer.getPerformerName();
        case 'performerType':
          return performer.getPerformerType();
        case 'logoImgUrl':
          return performer.getLogoImgUrl();
        case 'color':
          return performer.getColor();
        default:
          return '';
      }
    }
  }
  return '';
}
