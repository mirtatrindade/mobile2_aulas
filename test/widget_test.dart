// =============================================================================
// WIDGET TEST — testa uma tela (widget) isolada
// =============================================================================
// O Flutter tem três níveis: unit test (função/classe), widget test (uma tela),
// integration test (app inteiro). Aqui é widget test: bom pra ver se a UI
// monta e reage a toques. Usamos WidgetTester (tap, pump, find).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile2_aulas/view/app_view.dart';

void main() {
  testWidgets('Menu de Aulas abre e mostra os itens', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // A primeira tela é o menu
    expect(find.text('Menu de Aulas'), findsOneWidget);
    expect(find.text('Aula 1 — Contador'), findsOneWidget);
    expect(find.text('Aula — Acessibilidade'), findsOneWidget);
  });

  testWidgets('Abrir Aula 1 e incrementar contador', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Toca no item da Aula 1
    await tester.tap(find.text('Aula 1 — Contador'));
    await tester.pumpAndSettle();

    // Agora estamos na tela do contador; começa em 0
    expect(find.text('0'), findsOneWidget);

    // Toca no botão +
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
