import 'package:flutter/material.dart';

/// الشيمر نفسه كما قبل
class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  const Shimmer({super.key, required this.child, this.period = const Duration(milliseconds: 1200)});
  @override _ShimmerState createState() => _ShimmerState();
}
class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period)..repeat();
  }
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final w = bounds.width;
            final dx = (2 * _ctrl.value - 1) * w;
            return LinearGradient(
              begin: Alignment(-1 - dx/w, 0),
              end: Alignment(1 - dx/w, 0),
              colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
              stops: const [0, 0.5, 1],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton لحقل البحث
class SkeletonSearchBar extends StatelessWidget {
  const SkeletonSearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation:0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide.none,  // هنا أيضاً
        ),
        child: Shimmer(
          child: Container(
            height: 40,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

/// Skeleton لبطاقة النوع مغلقة
class SkeletonAccountTypeCard extends StatelessWidget {
  const SkeletonAccountTypeCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide.none,  
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Shimmer(
          child: Row(
            children: [
              // دائرة رمادية
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // عنوان وهمي
              Expanded(
                child: Container(
                  height: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              // سهم وهمي
              Container(
                width: 18,
                height: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton لعرض محتوى الكارد بعد الفتح
class SkeletonAccountContent extends StatelessWidget {
  final int itemCount;
  const SkeletonAccountContent({super.key, this.itemCount = 3});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SkeletonPaymentAccountCard(),
        );
      }),
    );
  }
}

/// Skeleton لبطاقة الحساب داخل القائمة المفتوحة
class SkeletonPaymentAccountCard extends StatelessWidget {
  const SkeletonPaymentAccountCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Shimmer(
          child: Row(
            children: [
              // دائرة
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // نصين وهميين
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, width: 120, color: Colors.grey),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 60, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // ثلاثة أيقونات وهمية
              for (int i = 0; i < 3; i++) ...[
                Container(width: 36, height: 36, color: Colors.grey),
                if (i < 2) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
