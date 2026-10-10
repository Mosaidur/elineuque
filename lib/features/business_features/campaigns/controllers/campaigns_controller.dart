import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/business_campaign_item_model.dart';

class CampaignsController extends ChangeNotifier {
  int _selectedNavIndex = 3;
  bool _isLoading = false;

  int get selectedNavIndex => _selectedNavIndex;
  bool get isLoading => _isLoading;

  List<BusinessCampaignItemModel> campaigns = [];

  // Form controllers for create/edit modal
  final titleController = TextEditingController();
  final rewardController = TextEditingController();
  final offerController = TextEditingController();
  final minimumSpendController = TextEditingController();
  final endDateController = TextEditingController();
  String? editingCampaignId;

  Future<void> fetchCampaigns() async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiClient.get(ApiConstants.myCampaigns, withAuth: true);

    _isLoading = false;

    if (response.success && response.data is List) {
      final list = response.data as List;
      campaigns = list.map((item) {
        final c = item as Map<String, dynamic>;
        final id = c['_id']?.toString() ?? c['id']?.toString() ?? '';
        final title = c['title']?.toString() ?? 'Campaign';
        final rawReward = c['reward']?.toString() ?? '40';
        final rewardVal = int.tryParse(rawReward.replaceAll(RegExp(r'[^0-9]'), '')) ?? 40;
        final offer = c['offer']?.toString();
        final minSpend = (c['minimumSpend'] as num?)?.toInt() ?? 0;
        final rawEndDate = c['endDate']?.toString();
        String? formattedEnd;
        if (rawEndDate != null && rawEndDate.isNotEmpty) {
          try {
            final dt = DateTime.parse(rawEndDate).toLocal();
            formattedEnd = 'Ends ${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
          } catch (_) {
            formattedEnd = 'Ends $rawEndDate';
          }
        }

        final statusStr = c['status']?.toString() ?? 'ACTIVE';
        final status = statusStr == 'ACTIVE'
            ? BusinessCampaignStatus.active
            : BusinessCampaignStatus.paused;

        return BusinessCampaignItemModel(
          id: id,
          title: title,
          rewardPerPurchase: rewardVal,
          customerOffer: offer,
          minimumSpend: minSpend,
          endDate: formattedEnd,
          referralLink: 'eliv.app/b/c/$id',
          sharedCount: (c['sharedCount'] as num?)?.toInt() ?? 0,
          purchasedCount: (c['purchasedCount'] as num?)?.toInt() ?? 0,
          conversionRate: (c['conversionRate'] as num?)?.toInt() ?? 0,
          status: status,
        );
      }).toList();
    }

    notifyListeners();
  }

  void clearForm() {
    titleController.clear();
    rewardController.clear();
    offerController.clear();
    minimumSpendController.clear();
    endDateController.clear();
    editingCampaignId = null;
  }

  void populateFormForEdit(BusinessCampaignItemModel item) {
    editingCampaignId = item.id;
    titleController.text = item.title;
    rewardController.text = '${item.rewardPerPurchase}';
    offerController.text = item.customerOffer ?? '';
    minimumSpendController.text = item.minimumSpend > 0 ? '${item.minimumSpend}' : '';
    endDateController.text = item.endDate?.replaceAll('Ends ', '') ?? '';
    notifyListeners();
  }

  Future<void> saveCampaign(BuildContext context) async {
    final title = titleController.text.trim();
    final rewardText = rewardController.text.trim();
    final offer = offerController.text.trim();
    final endDateText = endDateController.text.trim();

    if (title.isEmpty) {
      _showSnackbar(context, 'Campaign title cannot be empty.', isError: true);
      return;
    }

    final reward = int.tryParse(rewardText) ?? 40;
    final minSpend = int.tryParse(minimumSpendController.text.trim()) ?? 0;
    final now = DateTime.now();
    DateTime endDt = now.add(const Duration(days: 30));
    if (endDateText.isNotEmpty) {
      try {
        final parsed = DateTime.parse(endDateText);
        endDt = DateTime(parsed.year, parsed.month, parsed.day, 23, 59, 59);
      } catch (_) {}
    }

    _isLoading = true;
    notifyListeners();

    if (editingCampaignId != null) {
      // Update existing campaign
      final res = await ApiClient.put(
        '${ApiConstants.campaigns}/$editingCampaignId',
        body: {
          'title': title,
          'reward': '\$$reward',
          'offer': offer.isNotEmpty ? offer : 'Special Referral Reward',
          'minimumSpend': minSpend,
          'endDate': endDt.toIso8601String(),
        },
        withAuth: true,
      );

      _isLoading = false;
      notifyListeners();

      if (!context.mounted) return;

      if (res.success) {
        _showSnackbar(context, '$title has been updated successfully.', isError: false);
        clearForm();
        Navigator.pop(context);
        await fetchCampaigns();
      } else {
        _showSnackbar(context, res.message, isError: true);
      }
    } else {
      // Create new campaign
      final res = await ApiClient.post(
        ApiConstants.campaigns,
        body: {
          'title': title,
          'reward': '\$$reward',
          'offer': offer.isNotEmpty ? offer : 'Special Referral Reward',
          'startDate': now.toIso8601String(),
          'endDate': endDt.toIso8601String(),
          'minimumSpend': minSpend,
          'totalBudget': 0,
        },
        withAuth: true,
      );

      _isLoading = false;
      notifyListeners();

      if (!context.mounted) return;

      if (res.success) {
        _showSnackbar(context, '$title created and active!', isError: false);
        clearForm();
        Navigator.pop(context);
        await fetchCampaigns();
      } else {
        _showSnackbar(context, res.message, isError: true);
      }
    }
  }

  Future<void> togglePauseResume(String id, [BuildContext? context]) async {
    final index = campaigns.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final current = campaigns[index];
    final isCurrentlyActive = current.status == BusinessCampaignStatus.active;

    // Toggle local state optimistically
    campaigns[index] = current.copyWith(
      status: isCurrentlyActive ? BusinessCampaignStatus.paused : BusinessCampaignStatus.active,
    );
    notifyListeners();

    if (context != null && context.mounted) {
      _showSnackbar(
        context,
        '${current.title} is now ${isCurrentlyActive ? 'paused' : 'active'}.',
        isError: false,
      );
    }
  }

  void deleteCampaign(String id) {
    campaigns.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void copyReferralLink(String link, [BuildContext? context]) {
    Clipboard.setData(ClipboardData(text: 'https://$link'));
    if (context != null && context.mounted) {
      _showSnackbar(context, '$link copied to clipboard.', isError: false);
    }
  }

  void onNavTap(BuildContext context, int index) {
    if (index == _selectedNavIndex) return;
    _selectedNavIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.businessDashboard);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.businessReferrals);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.businessScan);
        break;
      case 3:
        // Already on campaigns
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.businessProfile);
        break;
    }
  }

  void _showSnackbar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade900 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    rewardController.dispose();
    offerController.dispose();
    minimumSpendController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
