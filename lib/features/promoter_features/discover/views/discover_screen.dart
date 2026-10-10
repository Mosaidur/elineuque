import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../../home/views/widgets/promoter_bottom_nav.dart';
import '../controllers/discover_controller.dart';
import 'widgets/business_discover_card.dart';
import 'widgets/category_filter_chips.dart';
import 'widgets/discover_map_banner.dart';
import 'widgets/discover_search_bar.dart';

class DiscoverScreen extends GetView<DiscoverController> {
  const DiscoverScreen({super.key});

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
        child: RefreshIndicator(
          onRefresh: controller.fetchDiscoverBusinesses,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // 1. TOP HEADER (TITLE & FILTER ICON)
              // ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onFilterTap,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border,
                          width: 0.8,
                        ),
                      ),
                      child: const Icon(
                        Icons.tune_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // 2. SEARCH BAR
              // ─────────────────────────────
              DiscoverSearchBar(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // 3. MAP BANNER
              // ─────────────────────────────
              DiscoverMapBanner(
                onMapView: controller.onMapViewTap,
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 4. CATEGORY FILTER CHIPS
              // ─────────────────────────────
              Obx(
                () => CategoryFilterChips(
                  categories: controller.categories,
                  selectedCategory: controller.selectedCategory.value,
                  onSelectCategory: controller.onSelectCategory,
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 5. BUSINESS LIST CARDS
              // ─────────────────────────────
              Obx(() {
                final list = controller.filteredBusinesses;
                if (list.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      children: const [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No businesses found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Try searching for another keyword or category',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: list.map((business) {
                    return BusinessDiscoverCard(
                      business: business,
                      onTap: () => controller.onBusinessTap(business),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
}
