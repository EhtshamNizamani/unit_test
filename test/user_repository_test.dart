import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:unit_test_flutter/user_model.dart';
import 'package:unit_test_flutter/user_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    mockHTTPClient = MockHTTPClient();
    userRepository = UserRepository(mockHTTPClient);
  });
  group('repository -', () {
    group('user repository -', () {
      test(
        'given UserRepository class when getUser function is called  status code is 200 ',
        () async {
          when(
            () => mockHTTPClient.get(
              Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
            ),
          ).thenAnswer((invocation) async {
            return Response(
                '''  {"id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz"}''',
                200);
          });
          final user = await userRepository.getUser();
          expect(user, isA<User>());
        },
      );
      test(
        'given UserRepository class when getUser function is called and status code is not 200 then an exception should be thrown',
        () async {
          // arrange
          when(
            () => mockHTTPClient.get(
              Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
            ),
          ).thenAnswer((invocation) async => Response('{}', 500));
          // act
          final user = userRepository.getUser();
          // assert
          expect(user, throwsException);
        },
      );
    });
  });
}
