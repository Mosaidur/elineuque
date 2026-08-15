import 'package:flutter/material.dart';
import 'campaign_model.dart';

class BusinessDiscoverModel {
  final String id;
  final String name;
  final String category;
  final double distanceMi;
  final double rating;
  final String rewardPerReferral;
  final int activePromoters;
  final bool isVerified;
  final IconData icon;
  final Color iconColor;
  final String location;
  final String hours;
  final String website;
  final String referralSlug;
  final List<CampaignModel> campaigns;

  const BusinessDiscoverModel({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceMi,
    required this.rating,
    required this.rewardPerReferral,
    required this.activePromoters,
    this.isVerified = true,
    required this.icon,
    required this.iconColor,
    required this.location,
    required this.hours,
    required this.website,
    required this.referralSlug,
    required this.campaigns,
  });

  String get referralLink => 'eliv.app/r/rifat354798/$referralSlug';
  String get distanceText => '${distanceMi.toStringAsFixed(1)} mi';
  String get ratingText => rating.toStringAsFixed(1);
}
