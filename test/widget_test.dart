// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';

import 'package:video_player_exercise/main.dart';

void main() {

  testWidgets('Find label Jana Ally', (WidgetTester tester) async {

    await tester.pumpWidget(MyApp());

    expect(find.text('Jana Ally'), findsOneWidget);

    await Future.delayed(Duration(seconds: 2));

    expect(find.text('Jana Ally'), findsOneWidget);
  });
}
