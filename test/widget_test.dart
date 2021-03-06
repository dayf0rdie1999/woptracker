// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/ui/auth_ui/signin_ui/signin.dart';

class MockAuthService extends Mock implements AuthService {}


void main() {

  Widget makeTestableWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  };


  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final _mockAuthService = MockAuthService();
    
  });
}
