/// Suppression impossible — article envoyé en cuisine (utiliser [voidOrderItem]).
class OrderItemVoidRequired implements Exception {
  const OrderItemVoidRequired([
    this.message =
        'Article envoyé en cuisine — annulation via VOID obligatoire',
  ]);

  final String message;

  @override
  String toString() => message;
}
