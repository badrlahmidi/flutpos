import '../database/app_database.dart';

class CustomerFormData {
  const CustomerFormData({
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.taxId,
    this.creditLimit = 5000.0,
    this.isActive = true,
  });

  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxId;
  final double creditLimit;
  final bool isActive;
}

abstract class CustomerRepository {
  Future<List<Customer>> listAllCustomers({String? searchQuery, bool activeOnly = true});
  Future<Customer?> getCustomerById(String customerId);
  Future<Customer> createCustomer(CustomerFormData data);
  Future<void> updateCustomer(String id, CustomerFormData data);
  Future<void> setCustomerActive(String id, {required bool isActive});
  
  /// Get all unpaid orders (ON_ACCOUNT) for a specific customer
  Future<List<Order>> getUnpaidOrdersForCustomer(String customerId);

  /// Apply a payment to a customer's account (pays off their debt)
  Future<void> payCustomerDebt({
    required String customerId,
    required double amount,
    required String paymentMethod,
    required String sessionId,
    required String userId,
  });
}
