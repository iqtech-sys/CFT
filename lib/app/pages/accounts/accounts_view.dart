import 'package:cftracker_app/app/widgets/account/account_type_card.dart';
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

class _AccountsViewState extends CleanViewState<AccountsView, AccountsController> {
  _AccountsViewState() : super(AccountsController());

  @override
  Widget get view {
    return Scaffold(
      appBar: const AppTopBar(),
      key: globalKey,
      body: ControlledWidgetBuilder<AccountsController>(
        builder: (context, controller) {
          return Column(
            children: [
              const SearchBox(),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.types.length,
                  itemBuilder: (ctx, index) {
                    final type = controller.types[index];
                    return AccountTypeCard(type: type);     // 👈 بطاقة لكل نوع
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
