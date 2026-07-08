import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../di/service_locator.dart';


Future<Customer?> showCustomerSelectionDialog(BuildContext context) {
  return showDialog<Customer>(
    context: context,
    builder: (context) => const _CustomerSelectionDialog(),
  );
}

class _CustomerSelectionDialog extends StatefulWidget {
  const _CustomerSelectionDialog();

  @override
  State<_CustomerSelectionDialog> createState() => _CustomerSelectionDialogState();
}

class _CustomerSelectionDialogState extends State<_CustomerSelectionDialog> {
  final _repo = sl<CustomerRepository>();
  List<Customer> _customers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _repo.listAllCustomers(activeOnly: true);
      if (mounted) {
        setState(() {
          _customers = customers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sélectionner un Client (En Compte)'),
      content: SizedBox(
        width: 500,
        height: 400,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _customers.isEmpty
                ? const Center(child: Text('Aucun client enregistré.'))
                : ListView.separated(
                    itemCount: _customers.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final c = _customers[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(c.phone ?? 'Pas de téléphone'),
                        trailing: Text(
                          'Solde: ${c.accountBalance.toStringAsFixed(2)} DH',
                          style: TextStyle(
                            color: c.accountBalance > 0 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(c),
                      );
                    },
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
