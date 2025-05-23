import 'package:flutter/material.dart';

/// Define the types of filters available
enum AccountFilter { active, inactive, positive, negative }

/// A reusable bottom sheet widget that shows four filter buttons.
class FilterBottomSheet extends StatelessWidget {
  /// Currently selected filter. Can be null for "no filter".
  final AccountFilter? selectedFilter;

  /// Callback when the user taps one of the filter buttons.
  final ValueChanged<AccountFilter?> onFilterSelected;

  const FilterBottomSheet({
    Key? key,
    required this.selectedFilter,
    required this.onFilterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.4;
    final double height = 48;

    ButtonStyle buttonStyle(Color color, bool active) =>
        ElevatedButton.styleFrom(
          minimumSize: Size(width, height),
          elevation: 0,
          // ignore: deprecated_member_use
          backgroundColor:
              active ? color.withOpacity(0.1) : const Color(0xffd1d5d6),
          foregroundColor: active ? color : const Color(0xff707271),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );

    // Helper to render each button
    Widget buildFilterButton(
      String label,
      AccountFilter filterType,
      Color color,
    ) {
      final bool isSelected = selectedFilter == filterType;
      return ElevatedButton(
        style: buttonStyle(color, isSelected),
        onPressed: () {
          // Toggle: deselect if already selected
          final newValue = isSelected ? null : filterType;
          onFilterSelected(newValue);
          Navigator.of(context).pop();
        },
        child: Text(label),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          buildFilterButton('Active', AccountFilter.active, Colors.blue),
          buildFilterButton('Inactive', AccountFilter.inactive, Colors.blue),
          buildFilterButton('Positive', AccountFilter.positive, Colors.green),
          buildFilterButton('Negative', AccountFilter.negative, Colors.red),
        ],
      ),
    );
  }
}

/// Helper to show the filter sheet from anywhere
void showAccountFilterSheet(
  BuildContext context, {
  required AccountFilter? current,
  required ValueChanged<AccountFilter?> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => FilterBottomSheet(
          selectedFilter: current,
          onFilterSelected: onSelected,
        ),
  );
}
