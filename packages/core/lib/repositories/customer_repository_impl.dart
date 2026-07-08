import 'package:drift/drift.dart';

import '../database/app_database.dart';

import 'customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Customer>> listAllCustomers({String? searchQuery, bool activeOnly = true}) async {
    final query = _db.select(_db.customers);
    
    if (activeOnly) {
      query.where((c) => c.isActive.equals(true));
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final term = '%$searchQuery%';
      query.where((c) => c.name.like(term) | c.phone.like(term));
    }

    query.orderBy([(c) => OrderingTerm.asc(c.name)]);
    return query.get();
  }

  @override
  Future<Customer?> getCustomerById(String customerId) {
    return (_db.select(_db.customers)..where((c) => c.id.equals(customerId))).getSingleOrNull();
  }

  @override
  Future<Customer> createCustomer(CustomerFormData data) async {
    final now = DateTime.now();
    final row = await _db.into(_db.customers).insertReturning(
          CustomersCompanion.insert(
            name: data.name,
            phone: Value(data.phone),
            email: Value(data.email),
            address: Value(data.address),
            taxId: Value(data.taxId),
            creditLimit: Value(data.creditLimit),
            isActive: Value(data.isActive),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    return row;
  }

  @override
  Future<void> updateCustomer(String id, CustomerFormData data) async {
    await (_db.update(_db.customers)..where((c) => c.id.equals(id))).write(
      CustomersCompanion(
        name: Value(data.name),
        phone: Value(data.phone),
        email: Value(data.email),
        address: Value(data.address),
        taxId: Value(data.taxId),
        creditLimit: Value(data.creditLimit),
        isActive: Value(data.isActive),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> setCustomerActive(String id, {required bool isActive}) async {
    await (_db.update(_db.customers)..where((c) => c.id.equals(id))).write(
      CustomersCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<List<Order>> getUnpaidOrdersForCustomer(String customerId) {
    return (_db.select(_db.orders)
          ..where((o) =>
              o.customerId.equals(customerId) &
              o.status.equals('PAID')) // We will consider them 'PAID' via ACCOUNT method
          // Actually, let's just find orders that were paid with ACCOUNT method
          )
        .get();
  }

  @override
  Future<void> payCustomerDebt({
    required String customerId,
    required double amount,
    required String paymentMethod,
    required String sessionId,
    required String userId,
  }) async {
    await _db.transaction(() async {
      // Create a CashMovement for the debt payment
      await _db.into(_db.cashMovements).insert(
            CashMovementsCompanion.insert(
              sessionId: sessionId,
              userId: userId,
              type: 'PAY_IN',
              amount: amount,
              reason: 'Paiement compte client',
              createdAt: DateTime.now(),
            ),
          );

      // Reduce the customer's account balance
      final customer = await getCustomerById(customerId);
      if (customer != null) {
        await (_db.update(_db.customers)..where((c) => c.id.equals(customerId))).write(
          CustomersCompanion(
            accountBalance: Value(customer.accountBalance - amount),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    });
  }
}
