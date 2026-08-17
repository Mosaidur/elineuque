import 'package:flutter/material.dart';

class CommentModel {
  final String id;
  final String userId;
  final String username;
  final String handle;
  final String avatarEmoji;
  final String text;
  final DateTime createdAt;
  int likes;
  bool isLiked;
  List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.handle,
    required this.avatarEmoji,
    required this.text,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    List<CommentModel>? replies,
  }) : replies = replies ?? [];
}

class CommunityPostModel {
  final String id;
  final String userId;
  final String username;
  final String handle;
  final String avatarEmoji;
  final String? businessTag;
  final Color? businessTagColor;
  final String content;
  final DateTime createdAt;
  int likes;
  bool isLiked;
  bool isFireReaction; // fire emoji instead of heart
  List<CommentModel> comments;

  CommunityPostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.handle,
    required this.avatarEmoji,
    this.businessTag,
    this.businessTagColor,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    this.isFireReaction = false,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  int get commentCount => comments.fold(
        0,
        (sum, c) => sum + 1 + c.replies.length,
      );
}
