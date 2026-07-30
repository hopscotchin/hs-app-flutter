import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hs_app_flutter/core/error/exceptions.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/core/mixins/safe_api_call.dart';
import 'package:hs_app_flutter/core/network/connectivity/network_info.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class _TestRepository with SafeApiCall {}

void main() {
  late _TestRepository repository;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    repository = _TestRepository();
    mockNetworkInfo = MockNetworkInfo();
  });

  group('SafeApiCall', () {
    test('should return Right with data when connected and call succeeds',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final result = await repository.safeApiCall(
        mockNetworkInfo,
        () async => 'success',
      );

      expect(result, const Right('success'));
    });

    test(
        'should return Left(ServerFailure) when connected and ServerException thrown',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final result = await repository.safeApiCall<String>(
        mockNetworkInfo,
        () async => throw const ServerException(message: 'Server error', statusCode: 500),
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
          expect(failure.statusCode, 500);
        },
        (_) => fail('Expected Left'),
      );
    });

    test('should return Left(NetworkFailure) when not connected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.safeApiCall<String>(
        mockNetworkInfo,
        () async => 'should not reach',
      );

      expect(result, const Left(NetworkFailure()));
    });

    test('should not call apiCall when not connected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      var called = false;

      await repository.safeApiCall<String>(
        mockNetworkInfo,
        () async {
          called = true;
          return 'data';
        },
      );

      expect(called, false);
    });

    test('should return Left(UnknownFailure) for unexpected errors', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final result = await repository.safeApiCall<String>(
        mockNetworkInfo,
        () async => throw Exception('unexpected'),
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
