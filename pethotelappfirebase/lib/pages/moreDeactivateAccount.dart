import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ensure to import Flutter Riverpod
import 'package:pethotelappfirebase/providers/user_provider.dart'; // Import your user provider
import 'signin.dart';

class DeactivateAccountPage extends ConsumerStatefulWidget {
  final LocalUser currentUser;

  const DeactivateAccountPage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _DeactivateAccountPageState createState() => _DeactivateAccountPageState();
}

class _DeactivateAccountPageState extends ConsumerState<DeactivateAccountPage> {
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('註銷帳號'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.warning, size: 80, color: Colors.red),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '注意：註銷帳號後，所有的紀錄將會清空。\n如有其他問題，請聯繫官方客服。\n手機號碼: ${widget.currentUser.user.phone}',
              textAlign: TextAlign.start,
            ),
          ),
          CheckboxListTile(
            title: const Text('我已經了解上面所有說明'),
            value: _isConfirmed,
            onChanged: (bool? value) {
              setState(() {
                _isConfirmed = value!;
              });
            },
          ),
          ElevatedButton(
            onPressed: _isConfirmed
                ? () async {
                    bool shouldDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('確認註銷'),
                            content: const Text('您確定要註銷您的帳戶嗎？'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(false), // Return false
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(true), // Return true
                                child: const Text('確認'),
                              ),
                            ],
                          ),
                        ) ??
                        false; // Handle null (i.e., if dialog is dismissed)

                    if (shouldDelete) {
                      try {
                        // Attempt to delete user using Riverpod's ref correctly
                        await ref.read(userProvider.notifier).deleteUser();
                        // Navigate to a safe route after deletion
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignIn()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Failed to delete account: $e")));
                      }
                    }
                  }
                : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return _isConfirmed ? Colors.red : Colors.grey;
                },
              ),
            ), // Disable button if not confirmed

            child: const Text(
              '確定註銷帳號',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
