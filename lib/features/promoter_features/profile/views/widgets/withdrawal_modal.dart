import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';

class WithdrawalModal extends StatefulWidget {
  final double availableBalance;
  final VoidCallback onSuccess;

  const WithdrawalModal({
    super.key,
    required this.availableBalance,
    required this.onSuccess,
  });

  static Future<void> show({
    required BuildContext context,
    required double availableBalance,
    required VoidCallback onSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WithdrawalModal(
        availableBalance: availableBalance,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  State<WithdrawalModal> createState() => _WithdrawalModalState();
}

class _WithdrawalModalState extends State<WithdrawalModal> {
  final _amountController = TextEditingController(text: '50');
  
  // Payment Method selection: 'BANK_TRANSFER' | 'STRIPE' | 'PAYPAL'
  String _selectedMethod = 'BANK_TRANSFER';

  // Bank fields
  final _bankNameController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();

  // Stripe / PayPal fields
  final _emailAccountController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    _emailAccountController.dispose();
    super.dispose();
  }

  void _setQuickAmount(double amount) {
    final validAmount = amount > widget.availableBalance ? widget.availableBalance : amount;
    _amountController.text = validAmount.toStringAsFixed(0);
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _submitWithdrawal() async {
    setState(() {
      _errorMessage = null;
    });

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount < 50) {
      setState(() {
        _errorMessage = 'Minimum withdrawal amount is \$50.00';
      });
      return;
    }

    if (amount > widget.availableBalance) {
      setState(() {
        _errorMessage = 'Requested amount exceeds your available balance of \$${widget.availableBalance.toStringAsFixed(2)}';
      });
      return;
    }

    Map<String, dynamic> paymentDetails = {};
    if (_selectedMethod == 'BANK_TRANSFER') {
      final bankName = _bankNameController.text.trim();
      final holder = _accountHolderController.text.trim();
      final accNum = _accountNumberController.text.trim();
      final routing = _routingNumberController.text.trim();

      if (bankName.isEmpty || holder.isEmpty || accNum.isEmpty) {
        setState(() {
          _errorMessage = 'Please fill in all required bank account details.';
        });
        return;
      }

      paymentDetails = {
        'bankName': bankName,
        'accountHolder': holder,
        'accountNumber': accNum,
        'routingNumber': routing.isNotEmpty ? routing : 'N/A',
      };
    } else if (_selectedMethod == 'STRIPE') {
      final email = _emailAccountController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        setState(() {
          _errorMessage = 'Please enter a valid Stripe registered email.';
        });
        return;
      }
      paymentDetails = {
        'stripeEmail': email,
      };
    } else if (_selectedMethod == 'PAYPAL') {
      final email = _emailAccountController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        setState(() {
          _errorMessage = 'Please enter a valid PayPal email address.';
        });
        return;
      }
      paymentDetails = {
        'paypalEmail': email,
      };
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiClient.post(
        ApiConstants.cashouts,
        body: {
          'amount': amount,
          'paymentMethod': _selectedMethod,
          'paymentDetails': paymentDetails,
        },
        withAuth: true,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.success) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        widget.onSuccess();

        if (Get.context != null) {
          Get.dialog(
            Dialog(
              backgroundColor: const Color(0xFF072138),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF163E24),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF52E385),
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Request Submitted!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your withdrawal of \$${amount.toStringAsFixed(2)} via ${_getMethodLabel(_selectedMethod)} is now under review by platform admins.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C5FF5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Got It',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  String _getMethodLabel(String method) {
    switch (method) {
      case 'BANK_TRANSFER':
        return 'Bank Transfer';
      case 'STRIPE':
        return 'Stripe';
      case 'PAYPAL':
        return 'PayPal';
      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFF061B2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Modal Title & Balance badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Withdraw Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3657),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1F5480), width: 0.8),
                  ),
                  child: Text(
                    'Available: \$${widget.availableBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF7E9EFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Amount Input Label
            const Text(
              'Withdrawal Amount (USD)',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Amount TextField
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF092942),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1B4968)),
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: TextStyle(
                    color: Color(0xFF7E9EFF),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: '50.00',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Quick Chips
            Row(
              children: [
                _buildQuickChip('\$50', 50),
                const SizedBox(width: 8),
                _buildQuickChip('\$100', 100),
                const SizedBox(width: 8),
                _buildQuickChip('\$250', 250),
                const SizedBox(width: 8),
                _buildQuickChip('All (\$${widget.availableBalance.toStringAsFixed(0)})', widget.availableBalance),
              ],
            ),
            const SizedBox(height: 20),

            // Payout Method Title
            const Text(
              'Select Payout Method',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // Method Selector Row
            Row(
              children: [
                _buildMethodCard(
                  id: 'BANK_TRANSFER',
                  icon: Icons.account_balance_outlined,
                  title: 'Bank',
                ),
                const SizedBox(width: 8),
                _buildMethodCard(
                  id: 'STRIPE',
                  icon: Icons.credit_card_rounded,
                  title: 'Stripe',
                ),
                const SizedBox(width: 8),
                _buildMethodCard(
                  id: 'PAYPAL',
                  icon: Icons.payment_rounded,
                  title: 'PayPal',
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Dynamic Form Fields based on method
            if (_selectedMethod == 'BANK_TRANSFER') ...[
              _buildTextField('Bank Name', _bankNameController, 'e.g. Chase, Bank of America'),
              const SizedBox(height: 10),
              _buildTextField('Account Holder Name', _accountHolderController, 'Full legal name'),
              const SizedBox(height: 10),
              _buildTextField('Account / IBAN Number', _accountNumberController, 'Account number', isNumeric: true),
              const SizedBox(height: 10),
              _buildTextField('Routing / SWIFT Code', _routingNumberController, 'e.g. 021000021 (optional)'),
            ] else ...[
              _buildTextField(
                _selectedMethod == 'STRIPE' ? 'Stripe Account Email' : 'PayPal Email',
                _emailAccountController,
                'yourname@example.com',
                isEmail: true,
              ),
            ],

            // Error notice
            if (_errorMessage != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B151E),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF8A2435)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Color(0xFFFF6B81), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Color(0xFFFF8B9C), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitWithdrawal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C5FF5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                      )
                    : const Text(
                        'Request Withdrawal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, double amount) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _setQuickAmount(amount),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF0F314D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1B4968)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required String id,
    required IconData icon,
    required String title,
  }) {
    final isSelected = _selectedMethod == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = id;
            _errorMessage = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B3D6B) : const Color(0xFF0A2238),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF5B78FF) : const Color(0xFF173D5E),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF7E9EFF) : Colors.white60,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
    bool isEmail = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF092942),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF1B4968)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumeric
                ? TextInputType.number
                : (isEmail ? TextInputType.emailAddress : TextInputType.text),
            style: const TextStyle(color: Colors.white, fontSize: 13.5),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
