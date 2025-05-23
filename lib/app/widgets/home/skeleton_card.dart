import 'package:cftracker_app/app/widgets/account/Shimmer.dart';
import 'package:flutter/material.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 120, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 60, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(width: 12),
            for (int i = 0; i < 3; i++) ...[
              Container(width: 36, height: 36, color: Colors.grey),
              if (i < 2) const SizedBox(width: 8),
            ],
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}



/// A skeleton placeholder for the search box
class SkeletonSearchBar extends StatelessWidget {
  const SkeletonSearchBar();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
