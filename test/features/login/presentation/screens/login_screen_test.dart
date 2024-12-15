import 'package:bloc_test/bloc_test.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/presentation/bloc/login_bloc.dart';
import 'package:demozeta/features/login/presentation/bloc/login_event.dart';
import 'package:demozeta/features/login/presentation/bloc/login_state.dart';
import 'package:demozeta/features/login/presentation/screens/home_screen.dart';
import 'package:demozeta/features/login/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
  });

  tearDown(() {
    mockLoginBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<LoginBloc>(
        create: (_) => mockLoginBloc,
        child: LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders email and password fields and login button',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginBloc.state).thenReturn(const LoginStateInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginBloc.state).thenReturn(const LoginStateInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      // Assert
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email format',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginBloc.state).thenReturn(const LoginStateInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(
          find.byKey(const Key('emailField')), 'invalid_email');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      // Assert
      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('disables login button when LoginStateLoading is active',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginBloc.state).thenReturn(const LoginStateLoading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      final button =
          tester.widget<ElevatedButton>(find.byKey(const Key('loginButton')));
      expect(button.onPressed, isNull);
    });

    testWidgets('triggers login event when form is valid',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginBloc.state).thenReturn(const LoginStateInitial());
      // when(() => mockLoginBloc.stream).thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      // Assert
      verify(() => mockLoginBloc.add(const GetLoginPressed(
            email: 'test@example.com',
            password: 'password123',
          ))).called(1);
    });

    //   testWidgets('navigates to home on successful login',
    //       (WidgetTester tester) async {
    //     // Arrange
    //     when(() => mockLoginBloc.state).thenReturn(const LoginStateInitial());
    //     whenListen(
    //       mockLoginBloc,
    //       Stream.fromIterable([
    //         const LoginStateLoading(),
    //         const LoginStateSuccess(LoginEntity(token: 'mockToken')),
    //       ]),
    //     );

    //     final goRouter = GoRouter(
    //       initialLocation: '/',
    //       routes: [
    //         GoRoute(
    //             name: "login",
    //             path: '/',
    //             builder: (BuildContext context, GoRouterState state) =>
    //                 BlocProvider<LoginBloc>(
    //                     create: (_) => mockLoginBloc, child: LoginScreen())),
    //         GoRoute(
    //           name: "home",
    //           path: '/home',
    //           builder: (BuildContext context, GoRouterState state) =>
    //               const HomeScreen(),
    //           routes: const <GoRoute>[],
    //         ),
    //       ],
    //     );

    //     // Act
    //     await tester.pumpWidget(MaterialApp.router(
    //       routerConfig: goRouter,
    //     ));
    //     await tester.enterText(
    //         find.byKey(const Key('emailField')), 'test@example.com');
    //     await tester.enterText(
    //         find.byKey(const Key('passwordField')), 'password123');
    //     await tester.tap(find.byKey(const Key('loginButton')));
    //     await tester.pumpAndSettle();

    //     // Assert
    //     expect(find.text('Home'), findsOneWidget);
    //   });

    //   testWidgets('shows error message on LoginStateError',
    //       (WidgetTester tester) async {
    //     // Arrange
    //     whenListen(
    //       mockLoginBloc,
    //       Stream<LoginState>.fromIterable([
    //         const LoginStateInitial(),
    //         const LoginStateError('Invalid credentials'),
    //       ]),
    //     );
    //     when(() => mockLoginBloc.state).thenReturn(const LoginStateInitial());

    //     await tester.pumpWidget(createWidgetUnderTest());

    //     // Act
    //     await tester.tap(find.byKey(const Key('loginButton')));
    //     await tester.pump();

    //     // Assert
    //     expect(find.text('Invalid credentials'), findsOneWidget);
    //   });
  });
}


//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:your_package/login_widget.dart';

// void main() {
//   group('LoginWidget Tests', () {
//     testWidgets('Should call onLogin with valid input', (WidgetTester tester) async {
//       // Arrange
//       String? capturedEmail;
//       String? capturedPassword;

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: LoginWidget(
//               onLogin: (email, password) {
//                 capturedEmail = email;
//                 capturedPassword = password;
//               },
//             ),
//           ),
//         ),
//       );

//       // Act
//       await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
//       await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
//       await tester.tap(find.byKey(const Key('loginButton')));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(capturedEmail, 'test@example.com');
//       expect(capturedPassword, 'password123');
//     });

//     testWidgets('Should show error messages for invalid input', (WidgetTester tester) async {
//       // Arrange
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: LoginWidget(),
//           ),
//         ),
//       );

//       // Act
//       await tester.tap(find.byKey(const Key('loginButton')));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('Email is required'), findsOneWidget);
//       expect(find.text('Password is required'), findsOneWidget);

//       // Act: Enter invalid email and short password
//       await tester.enterText(find.byKey(const Key('emailField')), 'invalid_email');
//       await tester.enterText(find.byKey(const Key('passwordField')), '123');
//       await tester.tap(find.byKey(const Key('loginButton')));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('Enter a valid email'), findsOneWidget);
//       expect(find.text('Password must be at least 6 characters'), findsOneWidget);
//     });

//     testWidgets('Should clear error messages after valid input', (WidgetTester tester) async {
//       // Arrange
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: LoginWidget(),
//           ),
//         ),
//       );

//       // Act
//       await tester.tap(find.byKey(const Key('loginButton')));
//       await tester.pumpAndSettle();

//       // Assert: Errors are shown
//       expect(find.text('Email is required'), findsOneWidget);
//       expect(find.text('Password is required'), findsOneWidget);

//       // Act: Enter valid email and password
//       await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
//       await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
//       await tester.tap(find.byKey(const Key('loginButton')));
//       await tester.pumpAndSettle();

//       // Assert: Errors are cleared
//       expect(find.text('Email is required'), findsNothing);
//       expect(find.text('Password is required'), findsNothing);
//     });

//     testWidgets('Should not call onLogin with invalid input', (WidgetTester tester) async {
//       // Arrange
//       bool wasCalled = false;

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: LoginWidget(
//               onLogin: (_, __) {
//                 wasCalled = true;
//               },
//             ),
//           ),
//         ),
//       );

//       // Act
//       await tester.enterText(find.byKey(const Key('emailField')), 'invalid_email');
//       await tester.enterText(find.byKey(const Key('passwordField')), '123');
//       await tester.tap(find.byKey(const Key('loginButton')));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(wasCalled, isFalse);
//     });
//   });
// }

