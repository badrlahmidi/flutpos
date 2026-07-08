import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';
import '../../../widgets/atoms/pos_button.dart';

import '../../../navigation/app_session.dart';

class CustomersAdminPage extends StatefulWidget {
  const CustomersAdminPage({super.key});

  @override
  State<CustomersAdminPage> createState() => _CustomersAdminPageState();
}

class _CustomersAdminPageState extends State<CustomersAdminPage> {
  final _repo = sl<CustomerRepository>();
  List<Customer> _customers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final customers = await _repo.listAllCustomers(activeOnly: false);
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

  Future<void> _createCustomer() async {
    final form = await _showCustomerForm();
    if (form != null) {
      await _repo.createCustomer(form);
      _loadData();
    }
  }

  Future<void> _editCustomer(Customer c) async {
    final form = await _showCustomerForm(existing: c);
    if (form != null) {
      await _repo.updateCustomer(c.id, form);
      _loadData();
    }
  }

  Future<void> _payDebt(Customer c) async {
    if (c.accountBalance <= 0) return;
    
    final amountController = TextEditingController(text: c.accountBalance.toStringAsFixed(2));
    
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Encaisser dette : ${c.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Solde débiteur actuel : ${c.accountBalance.toStringAsFixed(2)} DH'),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Montant à encaisser (DH)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(amountController.text);
              if (val != null && val > 0 && val <= c.accountBalance) {
                Navigator.pop(context, val);
              }
            },
            child: const Text('Encaisser'),
          ),
        ],
      ),
    );

    if (amount != null && amount > 0) {
      final sessionRepo = sl<CashSessionRepository>();
      final session = await sessionRepo.getAnyOpenSession();
      if (session == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur: Aucune session de caisse ouverte pour enregistrer le paiement.')),
          );
        }
        return;
      }
      
      final user = AppSession.instance.user;
      await _repo.payCustomerDebt(
        customerId: c.id,
        amount: amount,
        paymentMethod: 'CASH', // Defaults to CASH for debt payoff, could be enhanced to choose method
        sessionId: session.id,
        userId: user?.id ?? '',
      );
      _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paiement de ${amount.toStringAsFixed(2)} DH enregistré.')),
        );
      }
    }
  }

  Future<CustomerFormData?> _showCustomerForm({Customer? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name);
    final phoneCtrl = TextEditingController(text: existing?.phone);
    final emailCtrl = TextEditingController(text: existing?.email);
    final taxIdCtrl = TextEditingController(text: existing?.taxId);

    return showDialog<CustomerFormData>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Nouveau Client' : 'Modifier Client'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom du client *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: taxIdCtrl,
                decoration: const InputDecoration(labelText: 'ICE (Optionnel)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(
                context,
                CustomerFormData(
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
                  email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                  taxId: taxIdCtrl.text.trim().isEmpty ? null : taxIdCtrl.text.trim(),
                  isActive: existing?.isActive ?? true,
                  creditLimit: existing?.creditLimit ?? 5000.0,
                ),
              );
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BackofficePageHeader(
          title: 'Gestion des Clients',
          subtitle: 'Gérer les comptes clients et le crédit (Ardoise).',
          actions: [
            PosButton(
              label: 'Nouveau client',
              icon: Icons.person_add_outlined,
              onPressed: _createCustomer,
            ),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Card(
                  margin: const EdgeInsets.all(AppSpacing.l),
                  child: ListView.separated(
                    itemCount: _customers.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final c = _customers[index];
                      final hasDebt = c.accountBalance > 0;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: hasDebt ? Colors.red.shade100 : Colors.green.shade100,
                          child: Icon(
                            Icons.person,
                            color: hasDebt ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(c.phone ?? 'Aucun contact'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Solde', style: TextStyle(fontSize: 12)),
                                Text(
                                  '${c.accountBalance.toStringAsFixed(2)} DH',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: hasDebt ? Colors.red : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppSpacing.l),
                            if (hasDebt)
                              PosButton(
                                label: 'Encaisser',
                                icon: Icons.payments_outlined,
                                variant: PosButtonVariant.outlined,
                                onPressed: () => _payDebt(c),
                              ),
                            const SizedBox(width: AppSpacing.s),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _editCustomer(c),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
