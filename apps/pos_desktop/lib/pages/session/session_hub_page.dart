import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../backoffice/treasury/treasury_page.dart';

/// Hub trésorerie — délègue à [TreasuryPage].
class SessionHubPage extends StatelessWidget {
  const SessionHubPage({
    super.key,
    required this.user,
    this.embeddedInShell = false,
  });

  final User user;
  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TreasuryPage(user: user, embeddedInShell: embeddedInShell),
    );
  }
}
