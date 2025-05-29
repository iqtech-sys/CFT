import 'package:cftracker_app/app/pages/add_account/add_account_view.dart';
import 'package:cftracker_app/app/widgets/account/Shimmer.dart';
import 'package:cftracker_app/app/widgets/account/account_type_card.dart';
import 'package:cftracker_app/app/widgets/account/filter_bottom_sheet.dart';
import 'package:cftracker_app/app/widgets/search_textbox.dart';
import 'package:cftracker_app/app/widgets/top_bar/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'accounts_controller.dart';

class AccountsView extends CleanView {
  const AccountsView({Key? key}) : super(key: key);

  @override
  _AccountsViewState createState() => _AccountsViewState();
}

class _AccountsViewState
    extends CleanViewState<AccountsView, AccountsController> {
  late AccountsController controller;

  _AccountsViewState() : super(AccountsController());

  @override
  Widget get view {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddAccountView()),
          );
          if (added == true) {
            controller.initListeners(); // تحديث القائمة
          }
        },
      ),

      appBar: const AppTopBar(),
      key: globalKey,
      body: ControlledWidgetBuilder<AccountsController>(
        builder: (context, con) {
          controller = con;
          if (con.isLoading) {
            return Column(
              children: [
                SizedBox(
                  height: 3,
                  child: const LinearProgressIndicator(minHeight: 3),
                ),
                const SkeletonSearchBar(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (_, __) => const SkeletonAccountTypeCard(),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              SizedBox(
                height: 3,
                child:
                    con.isLoading
                        ? const LinearProgressIndicator(minHeight: 3)
                        : const SizedBox.shrink(),
              ),
              SearchBox(
                hasFilter: con.selectedFilter != null,
                onFilterTap: () {
                  showAccountFilterSheet(
                    context,
                    current: con.selectedFilter,
                    onSelected: (newFilter) {
                      con.setFilter(newFilter);
                    },
                  );
                },
                onChanged: con.setSearch,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: con.types.length,
                  itemBuilder: (ctx, index) {
                    final type = con.types[index];
                    final accountsOfType =
                        con.filteredAccounts
                            .where((acc) => acc.typeId == type.id)
                            .toList();
                    if (accountsOfType.isEmpty) return const SizedBox.shrink();
                    final incomeOnly =
                        con.filteredAccounts
                            .where(
                              (acc) => acc.typeId == 'INC',
                            ) // كل حسابات Income مرة واحدة
                            .toList();
                    return AccountTypeCard(
                      accounts: accountsOfType,
                      type: type,
                      searchTerm: con.searchTerm,
                      filter: con.selectedFilter,
                      incomeAccounts: incomeOnly, // ★ جديد
                      onTopUp: (receiveAcc, incomeAcc, amount) {
                        con.topUp(
                          receiveId: receiveAcc.id,
                          incomeId: incomeAcc.id,
                          amount: amount,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
