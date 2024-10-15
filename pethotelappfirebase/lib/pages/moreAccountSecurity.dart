import 'package:flutter/material.dart';
import 'package:pethotelappfirebase/providers/user_provider.dart';

import 'moreDeactivateAccount.dart';

class AccountSecurityPage extends StatelessWidget {
  final LocalUser currentUser;

  const AccountSecurityPage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帳號安全'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('手機號碼'),
            subtitle: Text(currentUser.user.phone),
          ),
          ListTile(
            title: const Text('註銷帳號'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DeactivateAccountPage(currentUser: currentUser)),
              );
            },
          ),
        ],
      ),
    );
  }
}
