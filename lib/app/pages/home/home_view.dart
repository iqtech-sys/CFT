import 'package:cftracker_app/app/widgets/home/skeleton_card.dart';
import 'package:cftracker_app/app/widgets/home/home_filter_bottom_sheet.dart';
import 'package:cftracker_app/app/widgets/home/payment_account_card.dart';
import 'package:cftracker_app/app/widgets/search_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../widgets/top_bar/app_top_bar.dart';
import '../../widgets/home/totals_section.dart';
import 'home_controller.dart';

class HomeView extends CleanView {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends CleanViewState<HomeView, HomeController> {
  _HomeViewState() : super(HomeController());

  @override
  Widget get view {
    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      appBar: const AppTopBar(),
      body: ControlledWidgetBuilder<HomeController>(
        builder: (context, controller) {
          return Column(
            children: [
              // 1) Loader bar
              SizedBox(
                height: 3,
                child:
                    controller.isLoading
                        ? const LinearProgressIndicator(minHeight: 3)
                        : const SizedBox.shrink(),
              ),

              // 2) SearchBox أو سكيليتون مكانها
              controller.isLoading
                  ? SkeletonSearchBar()
                  : SearchBox(
                    hasFilter: controller.isFilterActive != null,
                    onFilterTap: () {
                      // هنا نستدعي دالة إظهار الشيت
                      showHomeFilterBottomSheet(
                        context,
                        current:
                            controller.isFilterActive == true
                                ? HomeFilterButton.active
                                : controller.isFilterActive == false
                                ? HomeFilterButton.inactive
                                : null,
                        onSelected: (filter) {
                          // نحول HomeFilterButton? إلى bool?
                          final bool? newValue =
                              (filter == HomeFilterButton.active)
                                  ? true
                                  : (filter == HomeFilterButton.inactive)
                                  ? false
                                  : null;
                          controller.setFilter(newValue);
                        },
                      );
                    },
                    onChanged: controller.setSearch,
                  ),

              const SizedBox(height: 4),

              // 3) محتوى البطاقات: سكيليتون أو بيانات أو رسالة “لا توجد بيانات”
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: () {
                    if (controller.isLoading) {
                      // اظهر 4 سكيليتون كارد
                      return ListView.separated(
                        // physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: 6,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, __) => const SkeletonCard(),
                      );
                    } else if (controller.accounts.isEmpty) {
                      // انتهاء التحميل ولكن لا توجد بيانات
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('No payment accounts available'),
                        ),
                      );
                    } else {
                      final incomeOnly =
                          controller.accounts
                              .where((a) => a.typeId == 'INC')
                              .toList();
                      // انتهاء التحميل ووجود بيانات
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.filteredAccounts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final recvAcc =controller.filteredAccounts[i];

                          return PaymentAccountCard(
                            incomeAccounts: incomeOnly,
                            account: controller.filteredAccounts[i],
                            onTopUp: (incomeAcc, amount) {
                              controller.topUp(
                                receiveId: recvAcc.id,
                                incomeId: incomeAcc.id,
                                amount: amount,
                              );
                            },
                          );
                        },
                      );
                    }
                  }(),
                ),
              ),

              // 4) TotalsSection نعرضها فقط بعد انتهاء التحميل ووجود بيانات
              if (!controller.isLoading && controller.accounts.isNotEmpty)
                TotalsSection(accounts: controller.accounts),

              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}
