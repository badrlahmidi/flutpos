import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pos_desktop/blocs/cart/cart_bloc.dart';
import 'package:pos_desktop/blocs/cart/cart_event.dart';
import 'package:pos_desktop/blocs/cart/cart_state.dart';

import 'test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}
class MockCashSessionRepository extends Mock implements CashSessionRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(OrderType.dineIn);
    registerFallbackValue(OrderSource.manual);
    registerFallbackValue(PaymentMethod.cash);
    registerFallbackValue(DiscountType.percentage);
  });

  late MockOrderRepository orderRepo;
  late MockCashSessionRepository cashRepo;

  setUp(() {
    orderRepo = MockOrderRepository();
    cashRepo = MockCashSessionRepository();

    when(() => cashRepo.getOpenSessionForCashier(any()))
        .thenAnswer((_) async => testSession);
    when(() => orderRepo.createOrder(
          sessionId: any(named: 'sessionId'),
          waiterId: any(named: 'waiterId'),
          orderType: any(named: 'orderType'),
          tableId: any(named: 'tableId'),
          guestCount: any(named: 'guestCount'),
          source: any(named: 'source'),
          externalRef: any(named: 'externalRef'),
        )).thenAnswer((_) async => testOrder());
    when(() => orderRepo.getCompleteOrder(any()))
        .thenAnswer((_) async => testCompleteOrder());
  });

  group('CartBloc', () {
    blocTest<CartBloc, CartState>(
      'émet [CartLoading, CartReady] sur CartStarted',
      build: () => CartBloc(
        orderRepository: orderRepo,
        cashSessionRepository: cashRepo,
      ),
      act: (bloc) => bloc.add(CartStarted(testUser)),
      expect: () => [isA<CartLoading>(), isA<CartReady>()],
      verify: (_) {
        verify(() => cashRepo.getOpenSessionForCashier('user-1')).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'émet CartError quand aucune session ouverte',
      build: () {
        when(() => cashRepo.getOpenSessionForCashier(any()))
            .thenAnswer((_) async => null);
        return CartBloc(
          orderRepository: orderRepo,
          cashSessionRepository: cashRepo,
        );
      },
      act: (bloc) => bloc.add(CartStarted(testUser)),
      expect: () => [isA<CartLoading>(), isA<CartError>()],
    );

    blocTest<CartBloc, CartState>(
      'supprime un article — grâce 30s',
      build: () {
        when(() => orderRepo.removeOrderItem(any()))
            .thenAnswer((_) async => true);
        return CartBloc(
          orderRepository: orderRepo,
          cashSessionRepository: cashRepo,
        );
      },
      act: (bloc) async {
        bloc.add(CartStarted(testUser));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(const CartItemRemoved('item-1'));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        isA<CartLoading>(),
        isA<CartReady>(),
        isA<CartLoading>(),
        isA<CartReady>(),
      ],
    );

    blocTest<CartBloc, CartState>(
      'émet CartError sur suppression item fired (void required)',
      build: () {
        when(() => orderRepo.removeOrderItem(any()))
            .thenThrow(const OrderItemVoidRequired());
        return CartBloc(
          orderRepository: orderRepo,
          cashSessionRepository: cashRepo,
        );
      },
      act: (bloc) async {
        bloc.add(CartStarted(testUser));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(const CartItemRemoved('item-1'));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        isA<CartLoading>(),
        isA<CartReady>(),
        isA<CartLoading>(),
        isA<CartError>(),
      ],
    );

    blocTest<CartBloc, CartState>(
      'change la course d\'une ligne sur CartItemCourseChanged',
      build: () {
        when(
          () => orderRepo.updateOrderItemCourse(
            orderItemId: any(named: 'orderItemId'),
            courseNumber: any(named: 'courseNumber'),
          ),
        ).thenAnswer(
          (_) async => testOrderItem(courseNumber: 2),
        );
        return CartBloc(
          orderRepository: orderRepo,
          cashSessionRepository: cashRepo,
        );
      },
      act: (bloc) async {
        bloc.add(CartStarted(testUser));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(
          const CartItemCourseChanged(
            orderItemId: 'item-1',
            courseNumber: 2,
          ),
        );
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        isA<CartLoading>(),
        isA<CartReady>(),
        isA<CartLoading>(),
        isA<CartReady>(),
      ],
      verify: (_) {
        verify(
          () => orderRepo.updateOrderItemCourse(
            orderItemId: 'item-1',
            courseNumber: 2,
          ),
        ).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'réclame la suite sur CartCourseFireRequested',
      build: () {
        when(() => orderRepo.fireNextPendingCourse(any())).thenAnswer(
          (_) async => FireCourseResult(
            orderId: 'order-1',
            courseNumber: 2,
            firedItems: [testOrderItem(isFired: true, courseNumber: 2)],
          ),
        );
        return CartBloc(
          orderRepository: orderRepo,
          cashSessionRepository: cashRepo,
        );
      },
      act: (bloc) async {
        bloc.add(CartStarted(testUser));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(const CartCourseFireRequested());
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        isA<CartLoading>(),
        isA<CartReady>(),
        isA<CartLoading>(),
        isA<CartReady>(),
      ],
      verify: (_) {
        verify(() => orderRepo.fireNextPendingCourse('order-1')).called(1);
      },
    );
  });
}
