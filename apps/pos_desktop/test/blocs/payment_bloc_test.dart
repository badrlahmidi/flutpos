import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pos_desktop/blocs/payment/payment_bloc.dart';
import 'package:pos_desktop/blocs/payment/payment_event.dart';
import 'package:pos_desktop/blocs/payment/payment_state.dart';

import 'test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}
class MockVoucherRepository extends Mock implements VoucherRepository {}

void main() {
  late MockOrderRepository repo;
  late MockVoucherRepository voucherRepo;
  setUp(() {
    repo = MockOrderRepository();
    voucherRepo = MockVoucherRepository();
  });

  group('PaymentBloc', () {
    blocTest<PaymentBloc, PaymentState>(
      'émet [Loading, Ready] sur PaymentStarted',
      build: () {
        when(() => repo.getCompleteOrder(any()))
            .thenAnswer((_) async => testCompleteOrder());
        return PaymentBloc(orderRepository: repo, voucherRepository: voucherRepo);
      },
      act: (b) => b.add(const PaymentStarted('order-1')),
      expect: () => [isA<PaymentLoading>(), isA<PaymentReady>()],
    );

    blocTest<PaymentBloc, PaymentState>(
      'émet Failure si commande introuvable',
      build: () {
        when(() => repo.getCompleteOrder(any()))
            .thenAnswer((_) async => null);
        return PaymentBloc(orderRepository: repo, voucherRepository: voucherRepo);
      },
      act: (b) => b.add(const PaymentStarted('x')),
      expect: () => [isA<PaymentLoading>(), isA<PaymentFailure>()],
    );

    blocTest<PaymentBloc, PaymentState>(
      'saisie digits construit le montant',
      build: () {
        when(() => repo.getCompleteOrder(any()))
            .thenAnswer((_) async => testCompleteOrder());
        return PaymentBloc(orderRepository: repo, voucherRepository: voucherRepo);
      },
      act: (b) async {
        b.add(const PaymentStarted('order-1'));
        await Future.delayed(const Duration(milliseconds: 50));
        b.add(const PaymentDigitEntered('2'));
        b.add(const PaymentDigitEntered('0'));
        b.add(const PaymentDigitEntered('0'));
      },
      wait: const Duration(milliseconds: 150),
      verify: (b) {
        expect(b.state, isA<PaymentReady>());
        expect((b.state as PaymentReady).entryAmount, '200');
      },
    );

    blocTest<PaymentBloc, PaymentState>(
      'PaymentSuccess quand commande déjà PAID',
      build: () {
        when(() => repo.getCompleteOrder(any())).thenAnswer(
          (_) async => testCompleteOrder(
            orderStatus: 'PAID',
            payments: [testPayment],
          ),
        );
        return PaymentBloc(orderRepository: repo, voucherRepository: voucherRepo);
      },
      act: (b) => b.add(const PaymentStarted('order-1')),
      expect: () => [isA<PaymentLoading>(), isA<PaymentSuccess>()],
    );
  });
}
