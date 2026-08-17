import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../../home/views/widgets/promoter_bottom_nav.dart';
import '../controllers/feed_controller.dart';
import '../models/community_post_model.dart';

class CommunityFeedScreen extends GetView<FeedController> {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Obx(
        () => PromoterBottomNav(
          selectedIndex: controller.selectedNavIndex.value,
          onItemSelected: controller.onNavTap,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ──────────────────────────────────────────
            // TOP APP BAR
            // ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Community',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // + Create Post Button
                  Obx(() => GestureDetector(
                        onTap: controller.isComposerOpen.value
                            ? controller.closeComposer
                            : controller.openComposer,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: controller.isComposerOpen.value
                                ? const Color(0xFF3B4BCC)
                                : const Color(0xFFC8FF5A),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: controller.isComposerOpen.value
                                    ? const Color(0xFF5365F5).withValues(alpha: 0.4)
                                    : const Color(0xFFC8FF5A).withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            controller.isComposerOpen.value ? Icons.close : Icons.add,
                            color: controller.isComposerOpen.value
                                ? Colors.white
                                : Colors.black,
                            size: 20,
                          ),
                        ),
                      )),
                ],
              ),
            ),

            // ──────────────────────────────────────────
            // INLINE COMPOSER (animated slide-in)
            // ──────────────────────────────────────────
            Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => SizeTransition(
                    sizeFactor: anim,
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                  child: controller.isComposerOpen.value
                      ? _ComposerCard(controller: controller)
                      : const SizedBox.shrink(),
                )),

            // ──────────────────────────────────────────
            // POSTS LIST
            // ──────────────────────────────────────────
            Expanded(
              child: Obx(() {
                final posts = controller.posts;
                if (posts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No posts yet.\nTap + to share your experience!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  itemCount: posts.length,
                  itemBuilder: (_, i) => _PostCard(
                    post: posts[i],
                    controller: controller,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Composer Card
// ─────────────────────────────────────────────────────────────────────────────
class _ComposerCard extends StatelessWidget {
  final FeedController controller;
  const _ComposerCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2A42),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E4D72), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: const Text(
              'Share your experience',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              controller: controller.postController,
              maxLines: 4,
              minLines: 2,
              autofocus: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
              cursorColor: AppColors.businessPrimary,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Tell the community about a referral or experience...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13.5,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const Divider(color: Color(0xFF1B4060), height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.closeComposer,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 13)),
                ),
                const SizedBox(width: 8),
                Obx(() => ElevatedButton(
                      onPressed: controller.isPosting.value ? null : controller.submitPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5365F5),
                        disabledBackgroundColor: const Color(0xFF3040A0),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: controller.isPosting.value
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Post Card
// ─────────────────────────────────────────────────────────────────────────────
class _PostCard extends StatelessWidget {
  final CommunityPostModel post;
  final FeedController controller;

  const _PostCard({required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF082234),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF14385A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3D5C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(post.avatarEmoji, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${post.handle} · ',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          controller.timeAgo(post.createdAt),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 20),
            ],
          ),

          // ── Business Tag ──
          if (post.businessTag != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 12,
                  color: post.businessTagColor ?? AppColors.businessPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  post.businessTag!,
                  style: TextStyle(
                    color: post.businessTagColor ?? AppColors.businessPrimary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),

          // ── Content ──
          Text(
            post.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 12),

          const Divider(color: Color(0xFF133650), height: 1),

          const SizedBox(height: 8),

          // ── Actions Row ──
          Row(
            children: [
              // Like Button
              GestureDetector(
                onTap: () => controller.togglePostLike(post.id),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                      child: Text(
                        post.isLiked
                            ? (post.isFireReaction ? '🔥' : '❤️')
                            : (post.isFireReaction ? '🔥' : '🤍'),
                        key: ValueKey(post.isLiked),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${post.likes}',
                      style: TextStyle(
                        color: post.isLiked ? Colors.redAccent : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Comment Button
              GestureDetector(
                onTap: () => controller.openComments(post),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${post.commentCount}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Share Button
              const Icon(
                Icons.share_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
