import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:woptracker/ui/auth_ui/signin_ui/signin.dart';
import 'package:mockito/mockito.dart';
import 'package:woptracker/ui/auth_ui/signup_ui/signup.dart';
import 'package:woptracker/ui/woppingtracker_ui/google_map_ui/googlemapui.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main() {

  testWidgets("Input Email Text Normallly", (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(home: SignInUI()));

    final emailTextFormField = find.byKey(Key("EmailTextFormField"));

    expect(emailTextFormField,findsOneWidget);

    await tester.enterText(emailTextFormField, "paulduonganh@gmail.com");

    expect(find.text("paulduonganh@gmail.com"),findsOneWidget);
  });

  testWidgets("Check The Sign In Button", (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(home: SignInUI(),navigatorObservers: [mockObserver],));

    final button = find.byKey(Key("signIn"));

    expect(button,findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    expect(find.byType(GoogleMapUI),findsNothing);
  });

  testWidgets("Check The Sign Up Button", (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(home: SignInUI(),navigatorObservers: [mockObserver],));

    final button = find.byKey(Key("NavigateSignUpUI"));

    expect(button,findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();


    /// Verify that a push event happened
    expect(find.byType(GoogleMapUI),findsOneWidget);
  });



}