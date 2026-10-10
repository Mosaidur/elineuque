import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/community_post_model.dart';

class FeedController extends GetxController {
  // ── Navigation ──────────────────────────────────────────────────
  final selectedNavIndex = 3.obs; // Feed tab is index 3

  // ── Compose ─────────────────────────────────────────────────────
  final isComposerOpen = false.obs;
  final postController = TextEditingController();
  final isPosting = false.obs;
  final isLoading = false.obs;

  // ── Posts ────────────────────────────────────────────────────────
  final posts = <CommunityPostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSamplePosts();
    if (!Get.testMode) {
      fetchPosts();
    }
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      final res = await ApiClient.get(ApiConstants.posts, withAuth: true);
      if (res.success && res.data is List) {
        final list = res.data as List;
        if (list.isNotEmpty) {
          final mapped = list.map((item) {
            final p = item as Map<String, dynamic>;
            final id = p['_id']?.toString() ?? p['id']?.toString() ?? '';
            final content = p['content']?.toString() ?? '';
            final userObj = p['userId'] ?? p['author'];
            final userName = userObj is Map ? (userObj['name'] ?? 'Promoter') : 'Promoter';
            final userHandle = userObj is Map ? (userObj['handle'] ?? 'member') : 'member';
            final createdAt = DateTime.tryParse(p['createdAt']?.toString() ?? '') ?? DateTime.now();
            final likesCount = (p['likes'] as List?)?.length ?? (p['likeCount'] as num?)?.toInt() ?? 0;
            final isLiked = p['isLiked'] == true;

            return CommunityPostModel(
              id: id,
              userId: userObj is Map ? (userObj['_id']?.toString() ?? 'u') : 'u',
              username: userName.toString(),
              handle: '@$userHandle',
              avatarEmoji: '✨',
              content: content,
              createdAt: createdAt,
              likes: likesCount,
              isLiked: isLiked,
              comments: [],
            );
          }).toList();

          posts.assignAll(mapped);
        }
      }
    } catch (e) {
      debugPrint('Error fetching community posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadSamplePosts() {
    final now = DateTime.now();
    posts.assignAll([
      CommunityPostModel(
        id: 'p1',
        userId: 'u1',
        username: 'Alicia M.',
        handle: '@alicia_earns',
        avatarEmoji: '👩',
        businessTag: 'Kava Brew',
        businessTagColor: const Color(0xFFFFA726),
        content:
            "Just hit my 50th referral at Kava Brew! Their oat latte is genuinely unreal — friends keep going back. \$1,250 earned this month 🔥",
        createdAt: now.subtract(const Duration(hours: 1)),
        likes: 142,
        isLiked: false,
        isFireReaction: true,
        comments: [
          CommentModel(
            id: 'c1',
            userId: 'u2',
            username: 'Jordan T.',
            handle: '@jtpromoter',
            avatarEmoji: '👨',
            text: 'Congrats!! 🎉 That\'s incredible. How long did it take to hit 50?',
            createdAt: now.subtract(const Duration(minutes: 45)),
            likes: 12,
            replies: [
              CommentModel(
                id: 'r1',
                userId: 'u1',
                username: 'Alicia M.',
                handle: '@alicia_earns',
                avatarEmoji: '👩',
                text: 'About 3 weeks! Consistent sharing really pays off 💪',
                createdAt: now.subtract(const Duration(minutes: 30)),
                likes: 5,
              ),
            ],
          ),
          CommentModel(
            id: 'c2',
            userId: 'u3',
            username: 'Simone V.',
            handle: '@simone_local',
            avatarEmoji: '🧑',
            text: 'Kava Brew is the best one. High repeat customers!',
            createdAt: now.subtract(const Duration(minutes: 20)),
            likes: 8,
          ),
        ],
      ),
      CommunityPostModel(
        id: 'p2',
        userId: 'u2',
        username: 'Jordan T.',
        handle: '@jtpromoter',
        avatarEmoji: '👨',
        businessTag: 'FitZone Gym',
        businessTagColor: const Color(0xFF42A5F5),
        content:
            "FitZone bumped their referral reward to \$40 per conversion. Already sent 8 people this week. Commission adds up fast 💪",
        createdAt: now.subtract(const Duration(hours: 3)),
        likes: 90,
        isLiked: true,
        isFireReaction: true,
        comments: [
          CommentModel(
            id: 'c3',
            userId: 'u4',
            username: 'Marcus L.',
            handle: '@marcusl',
            avatarEmoji: '🧔',
            text: 'FitZone is 🔥 just got my first 3 referrals approved!',
            createdAt: now.subtract(const Duration(hours: 2)),
            likes: 6,
          ),
        ],
      ),
      CommunityPostModel(
        id: 'p3',
        userId: 'u3',
        username: 'Simone V.',
        handle: '@simone_local',
        avatarEmoji: '🧑',
        businessTag: 'Luna Spa',
        businessTagColor: const Color(0xFFAB47BC),
        content:
            "Luna Spa was absolutely luxurious. Easy to promote when you genuinely believe in it. 4 referrals converted in 2 days!",
        createdAt: now.subtract(const Duration(hours: 6)),
        likes: 67,
        isLiked: false,
        comments: [],
      ),
    ]);
  }

  // ── Composer Actions ─────────────────────────────────────────────
  void openComposer() => isComposerOpen.value = true;
  void closeComposer() {
    isComposerOpen.value = false;
    postController.clear();
  }

  Future<void> submitPost() async {
    final text = postController.text.trim();
    if (text.isEmpty) return;

    isPosting.value = true;
    try {
      final res = await ApiClient.post(
        ApiConstants.posts,
        body: {'content': text},
        withAuth: true,
      );

      if (res.success) {
        closeComposer();
        await fetchPosts();
        if (Get.context != null && Get.key.currentState?.overlay != null) {
          Get.snackbar(
            'Success',
            'Your post has been published to the community!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        final newPost = CommunityPostModel(
          id: 'p_${DateTime.now().millisecondsSinceEpoch}',
          userId: 'me',
          username: 'You',
          handle: '@me',
          avatarEmoji: '😊',
          content: text,
          createdAt: DateTime.now(),
          likes: 0,
        );
        posts.insert(0, newPost);
        closeComposer();
      }
    } catch (_) {
      closeComposer();
    } finally {
      isPosting.value = false;
    }
  }

  // ── Like Post ────────────────────────────────────────────────────
  void togglePostLike(String postId) {
    final idx = posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = posts[idx];
    post.isLiked = !post.isLiked;
    post.likes += post.isLiked ? 1 : -1;
    posts.refresh();

    // Call API in background
    ApiClient.post(ApiConstants.likePost(postId), withAuth: true);
  }

  // ── Comments Sheet ───────────────────────────────────────────────
  void openComments(CommunityPostModel post) {
    Get.bottomSheet(
      _CommentsSheet(post: post, controller: this),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  // ── Like Comment ─────────────────────────────────────────────────
  void toggleCommentLike(CommunityPostModel post, String commentId, {String? replyId}) {
    if (replyId != null) {
      final comment = post.comments.firstWhereOrNull((c) => c.id == commentId);
      if (comment == null) return;
      final reply = comment.replies.firstWhereOrNull((r) => r.id == replyId);
      if (reply == null) return;
      reply.isLiked = !reply.isLiked;
      reply.likes += reply.isLiked ? 1 : -1;
    } else {
      final comment = post.comments.firstWhereOrNull((c) => c.id == commentId);
      if (comment == null) return;
      comment.isLiked = !comment.isLiked;
      comment.likes += comment.isLiked ? 1 : -1;
    }
    posts.refresh();
  }

  // ── Add Comment ──────────────────────────────────────────────────
  void addComment(CommunityPostModel post, String text, {String? replyToCommentId}) {
    final newComment = CommentModel(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'me',
      username: 'You',
      handle: '@me',
      avatarEmoji: '😊',
      text: text,
      createdAt: DateTime.now(),
    );

    if (replyToCommentId != null) {
      final comment = post.comments.firstWhereOrNull((c) => c.id == replyToCommentId);
      comment?.replies.add(newComment);
    } else {
      post.comments.add(newComment);
    }
    posts.refresh();

    // Call API in background
    ApiClient.post(
      ApiConstants.postComments(post.id),
      body: {'content': text},
      withAuth: true,
    );
  }

  // ── Navigation ───────────────────────────────────────────────────
  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;
    selectedNavIndex.value = index;
    if (index == 0 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.home);
    } else if (index == 1 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.discover);
    } else if (index == 2 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.myReferrals);
    } else if (index == 4 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.profile);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────
  String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  void onClose() {
    postController.dispose();
    super.onClose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Comments Bottom Sheet (stateful for local reply state)
// ─────────────────────────────────────────────────────────────────────────────
class _CommentsSheet extends StatefulWidget {
  final CommunityPostModel post;
  final FeedController controller;

  const _CommentsSheet({required this.post, required this.controller});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _inputController = TextEditingController();
  String? _replyToCommentId;
  String? _replyToName;
  final _focusNode = FocusNode();

  void _startReply(String commentId, String username) {
    setState(() {
      _replyToCommentId = commentId;
      _replyToName = username;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyToCommentId = null;
      _replyToName = null;
    });
    _inputController.clear();
  }

  void _submitComment() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    widget.controller.addComment(widget.post, text, replyToCommentId: _replyToCommentId);
    _inputController.clear();
    _cancelReply();
    setState(() {});
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF061C2E);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final _ = widget.controller.posts.length;
                      return Text(
                        '${widget.post.comments.fold(0, (s, c) => s + 1 + c.replies.length)} Comments',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, color: Colors.white54, size: 20),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF163652), height: 1),

              // Comments List
              Expanded(
                child: Obx(() {
                  final _ = widget.controller.posts.length;
                  final comments = widget.post.comments;
                  if (comments.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 40, color: Colors.white24),
                          SizedBox(height: 10),
                          Text(
                            'No comments yet.\nBe the first to comment!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white38, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    itemCount: comments.length,
                    itemBuilder: (context, i) {
                      final comment = comments[i];
                      return _CommentTile(
                        comment: comment,
                        post: widget.post,
                        feedController: widget.controller,
                        onReply: _startReply,
                        onToggleLike: (cid, rid) =>
                            widget.controller.toggleCommentLike(widget.post, cid, replyId: rid),
                      );
                    },
                  );
                }),
              ),

              // Input Bar
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF061C2E),
                    border: Border(
                      top: BorderSide(color: Color(0xFF163652), width: 0.8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Reply indicator
                      if (_replyToName != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F3250),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.reply, size: 14, color: Color(0xFF5365F5)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Replying to $_replyToName',
                                  style: const TextStyle(
                                    color: Color(0xFF8EA5BB),
                                    fontSize: 11.5,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _cancelReply,
                                child: const Icon(Icons.close, size: 14, color: Color(0xFF8EA5BB)),
                              ),
                            ],
                          ),
                        ),

                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5365F5).withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('😊', style: TextStyle(fontSize: 15)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Input
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F2F48),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF1E4D72),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _inputController,
                                      focusNode: _focusNode,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: _replyToName != null
                                            ? 'Reply to $_replyToName...'
                                            : 'Add a comment...',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF6E879E),
                                          fontSize: 13,
                                        ),
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _submitComment,
                                    child: const Icon(
                                      Icons.send_rounded,
                                      size: 18,
                                      color: Color(0xFF5365F5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single Comment Tile (with replies)
// ─────────────────────────────────────────────────────────────────────────────
class _CommentTile extends StatefulWidget {
  final CommentModel comment;
  final CommunityPostModel post;
  final FeedController feedController;
  final void Function(String commentId, String username) onReply;
  final void Function(String commentId, String? replyId) onToggleLike;

  const _CommentTile({
    required this.comment,
    required this.post,
    required this.feedController,
    required this.onReply,
    required this.onToggleLike,
  });

  @override
  State<_CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<_CommentTile> {
  bool _repliesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.comment;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Main Comment ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3D5C),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(c.avatarEmoji, style: const TextStyle(fontSize: 15))),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C2D46),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                c.handle,
                                style: const TextStyle(
                                  color: Color(0xFF6E879E),
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            c.text,
                            style: const TextStyle(
                              color: Color(0xFFD0DDEB),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Like / Reply / Time Row
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Row(
                        children: [
                          Text(
                            widget.feedController.timeAgo(c.createdAt),
                            style: const TextStyle(color: Color(0xFF6E879E), fontSize: 10.5),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              widget.onToggleLike(c.id, null);
                              setState(() {});
                            },
                            child: Text(
                              c.isLiked ? '❤️ ${c.likes}' : '🤍 ${c.likes}',
                              style: const TextStyle(color: Color(0xFF8EA5BB), fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => widget.onReply(c.id, c.username),
                            child: const Text(
                              'Reply',
                              style: TextStyle(
                                color: Color(0xFF5365F5),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Replies ──
          if (c.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_repliesExpanded)
                    GestureDetector(
                      onTap: () => setState(() => _repliesExpanded = true),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '↳  View ${c.replies.length} ${c.replies.length == 1 ? 'reply' : 'replies'}',
                          style: const TextStyle(
                            color: Color(0xFF5365F5),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (_repliesExpanded) ...[
                    GestureDetector(
                      onTap: () => setState(() => _repliesExpanded = false),
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          '↑  Hide replies',
                          style: TextStyle(
                            color: Color(0xFF5365F5),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    ...c.replies.map((reply) => _ReplyTile(
                          reply: reply,
                          commentId: c.id,
                          feedController: widget.feedController,
                          onToggleLike: widget.onToggleLike,
                          onReply: () => widget.onReply(c.id, reply.username),
                        )),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reply Tile
// ─────────────────────────────────────────────────────────────────────────────
class _ReplyTile extends StatefulWidget {
  final CommentModel reply;
  final String commentId;
  final FeedController feedController;
  final void Function(String commentId, String? replyId) onToggleLike;
  final VoidCallback onReply;

  const _ReplyTile({
    required this.reply,
    required this.commentId,
    required this.feedController,
    required this.onToggleLike,
    required this.onReply,
  });

  @override
  State<_ReplyTile> createState() => _ReplyTileState();
}

class _ReplyTileState extends State<_ReplyTile> {
  @override
  Widget build(BuildContext context) {
    final r = widget.reply;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF1A3D5C),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(r.avatarEmoji, style: const TextStyle(fontSize: 13))),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2540),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            r.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            r.handle,
                            style: const TextStyle(color: Color(0xFF6E879E), fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        r.text,
                        style: const TextStyle(
                          color: Color(0xFFD0DDEB),
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 4),
                  child: Row(
                    children: [
                      Text(
                        widget.feedController.timeAgo(r.createdAt),
                        style: const TextStyle(color: Color(0xFF6E879E), fontSize: 10),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          widget.onToggleLike(widget.commentId, r.id);
                          setState(() {});
                        },
                        child: Text(
                          r.isLiked ? '❤️ ${r.likes}' : '🤍 ${r.likes}',
                          style: const TextStyle(color: Color(0xFF8EA5BB), fontSize: 10.5),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onReply,
                        child: const Text(
                          'Reply',
                          style: TextStyle(
                            color: Color(0xFF5365F5),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
