import 'package:flutter/material.dart';

/// Filter types
enum HomeFilterButton { active, inactive, positive, negative }

/// External Bottom Sheet widget
class HomeFilterBottomSheet extends StatelessWidget {
  final HomeFilterButton? selected;
  final ValueChanged<HomeFilterButton?> onSelected;

  const HomeFilterBottomSheet({
    Key? key,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double btnWidth = MediaQuery.of(context).size.width * 0.42;
    const double btnHeight = 50;
    
    ButtonStyle style(Color color, bool active) => ElevatedButton.styleFrom(
          minimumSize: Size(btnWidth, btnHeight),
          elevation: 0,
          // ignore: deprecated_member_use
          backgroundColor: active ? color.withOpacity(0.1) : const Color(0xffd1d5d6),
          foregroundColor: active ? color : const Color(0xff707271),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );

    Widget btn(String text, HomeFilterButton f, Color c) {
      final bool active = selected == f;
      return ElevatedButton(
        style: style(c, active),
        onPressed: () {
          onSelected(active ? null : f);
          Navigator.pop(context);
        },
        child: Text(text),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),  // أقل ارتفاع
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            btn('Active', HomeFilterButton.active, Colors.blue),
            btn('Inactive', HomeFilterButton.inactive, Colors.blue),
          ],
        ),
      ),
    );
  }
}
/// Call this method to show the sheet
void showHomeFilterBottomSheet(
  BuildContext context, {
  required HomeFilterButton? current,
  required ValueChanged<HomeFilterButton?> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => HomeFilterBottomSheet(
      selected: current,
      onSelected: onSelected,
    ),
  );
}

