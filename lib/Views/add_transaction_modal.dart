import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/transaction_providers.dart';
import '../providers/settings_providers.dart';

class CategoryModel {
  final String id;
  final String emoji;
  final String label;
  final Color color;

  CategoryModel({required this.id, required this.emoji, required this.label, required this.color});
}

class AddTransactionModal extends ConsumerStatefulWidget {
  const AddTransactionModal({super.key});

  @override
  ConsumerState<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends ConsumerState<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  final Color _bg = const Color(0xFFFFFDF5);
  final Color _black = const Color(0xFF111111);
  final Color _lime = const Color(0xFFD4FF5E);
  final Color _red = const Color(0xFFEF4444);
  final Color _white = const Color(0xFFFFFFFF);

  String _type = 'expense';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late CategoryModel _selectedCategory;


  final List<CategoryModel> _expenseCategories = [
    CategoryModel(id: 'food', emoji: '🍔', label: 'Food', color: const Color(0xFFFFCC80)),
    CategoryModel(id: 'transport', emoji: '🚕', label: 'Travel', color: const Color(0xFF90CAF9)),
    CategoryModel(id: 'shopping', emoji: '🛍️', label: 'Shop', color: const Color(0xFFF48FB1)),
    CategoryModel(id: 'entertainment', emoji: '🍿', label: 'Fun', color: const Color(0xFFCE93D8)),
    CategoryModel(id: 'bills', emoji: '⚡', label: 'Bills', color: const Color(0xFFFFAB91)),
  ];

  final List<CategoryModel> _incomeCategories = [
    CategoryModel(id: 'salary', emoji: '💸', label: 'Salary', color: const Color(0xFFA5D6A7)),
    CategoryModel(id: 'freelance', emoji: '💻', label: 'Freelance', color: const Color(0xFF80CBC4)),
    CategoryModel(id: 'invest', emoji: '📈', label: 'Invest', color: const Color(0xFFFFF59D)),
    CategoryModel(id: 'gift', emoji: '🎁', label: 'Gift', color: const Color(0xFFFFCC80)),
  ];

  List<CategoryModel> get _currentList => _type == 'expense' ? _expenseCategories : _incomeCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _expenseCategories.first;
  }

  void _switchType(String newType) {
    setState(() {
      _type = newType;
      _selectedCategory = newType == 'expense' ? _expenseCategories.first : _incomeCategories.first;
    });
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: _black, width: 3),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 50, height: 5, color: _black)),
            const SizedBox(height: 20),
            Text("SELECT CATEGORY", style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _currentList.length + 1,
                itemBuilder: (context, index) {
                  if (index == _currentList.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showCreateCategoryDialog();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _black,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _black, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.plus, color: Colors.white, size: 28),
                            const SizedBox(height: 8),
                            Text("Create", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    );
                  }

                  final cat = _currentList[index];
                  final isSelected = cat.id == _selectedCategory.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _black, width: isSelected ? 4 : 2),
                        boxShadow: [BoxShadow(color: _black, offset: const Offset(4, 4))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(cat.label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCategoryDialog() {
    final nameController = TextEditingController();
    final emojiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _black, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("NEW CATEGORY", style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: _NeoInput(controller: emojiController, hint: "😀", icon: null, textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _NeoInput(controller: nameController, hint: "Name", icon: null)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _black,
                    foregroundColor: _lime,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty && emojiController.text.isNotEmpty) {
                      final newCat = CategoryModel(
                        id: nameController.text.toLowerCase(),
                        emoji: emojiController.text,
                        label: nameController.text,
                        color: Colors.grey,
                      );
                      setState(() {
                        if (_type == 'expense') {
                          _expenseCategories.add(newCat);
                        } else {
                          _incomeCategories.add(newCat);
                        }
                        _selectedCategory = newCat;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("CREATE", style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: _black, onPrimary: _white, surface: _lime),
          dialogBackgroundColor: _white,
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: _black, onPrimary: _white, surface: _lime),
          timePickerTheme: TimePickerThemeData(backgroundColor: _white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final currencyAsync = ref.watch(currencyProvider);
    final currencySymbol = currencyAsync.value ?? '₹';
    final isExpense = _type == 'expense';

    final height = MediaQuery.of(context).size.height * 0.92;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: _black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(0, -5))],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(child: Container(width: 60, height: 6, color: _black)),
          const SizedBox(height: 24),


          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _black, width: 2),
            ),
            child: Row(
              children: [
                Expanded(child: _NeoTab(label: "EXPENSE", isSelected: isExpense, activeColor: _red, onTap: () => _switchType('expense'))),
                const SizedBox(width: 4),
                Expanded(child: _NeoTab(label: "INCOME", isSelected: !isExpense, activeColor: _lime, onTap: () => _switchType('income'))),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("ENTER AMOUNT", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  IntrinsicWidth(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: GoogleFonts.syne(fontSize: 48, fontWeight: FontWeight.w800, color: _black),
                      textAlign: TextAlign.center,
                      cursorColor: _black,
                      decoration: InputDecoration(
                        hintText: "0",
                        prefixText: "$currencySymbol ",
                        prefixStyle: GoogleFonts.syne(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.grey[400]),
                        border: InputBorder.none,
                      ),
                      autofocus: true,
                    ),
                  ),
                  Container(height: 4, width: 100, color: _black),

                  const SizedBox(height: 32),

                  GestureDetector(
                    onTap: _showCategoryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _black, width: 2),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(_selectedCategory.emoji, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("CATEGORY", style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                                  Text(_selectedCategory.label, style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold, color: _black)),
                                ],
                              ),
                            ],
                          ),
                          const Icon(LucideIcons.chevronDown, color: Colors.black),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _NeoInput(controller: _titleController, hint: "What is this for?", icon: LucideIcons.tag),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: GestureDetector(onTap: _pickDate, child: _NeoInfoCard(icon: LucideIcons.calendar, text: DateFormat('MMM dd').format(_selectedDate)))),
                      const SizedBox(width: 12),
                      Expanded(child: GestureDetector(onTap: _pickTime, child: _NeoInfoCard(icon: LucideIcons.clock, text: _selectedTime.format(context)))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _NeoInput(controller: _noteController, hint: "Extra notes...", icon: LucideIcons.fileText, maxLines: 2),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

      SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _black,
                foregroundColor: _lime,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _black, width: 2)),
                elevation: 0,
              ),
              onPressed: _saveTransaction,
              child: Text("SAVE TRANSACTION", style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _saveTransaction() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final finalDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    final noteText = _titleController.text.isEmpty ? "Untitled" : _titleController.text;


    await ref.read(transactionRepositoryProvider).addTransaction(
      amount: amount,
      note: noteText,
      date: finalDateTime,
      type: _type,
      categoryId: _selectedCategory.id,
    );

    if (mounted) context.pop();
  }
}


class _NeoTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _NeoTab({required this.label, required this.isSelected, required this.activeColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black, offset: Offset(2, 2))] : [],
        ),
        alignment: Alignment.center,
        child: Text(label, style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 13)),
      ),
    );
  }
}

class _NeoInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final int maxLines;
  final TextAlign textAlign;

  const _NeoInput({required this.controller, required this.hint, required this.icon, this.maxLines = 1, this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textAlign: textAlign,
        style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontWeight: FontWeight.w600),
          prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.black) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}

class _NeoInfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _NeoInfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 10),
          Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}