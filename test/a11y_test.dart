// =============================================================================
// TESTES DE ACESSIBILIDADE (a11y)
// =============================================================================
// O Flutter tem uma API de guidelines: meetsGuideline() verifica se a tela
// segue regras de contraste (WCAG), tamanho mínimo de toque (48x48 Android,
// 44x44 iOS) e se alvos clicáveis têm label. ensureSemantics() ativa a
// árvore de semântica no teste (igual ao opt-in no web).
// Ver: https://docs.flutter.dev/ui/accessibility/accessibility-testing
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile2_aulas/view/aula_acessibilidade_page.dart';
import 'package:mobile2_aulas/viewmodel/aula_acessibilidade_view_model.dart';

void main() {
  testWidgets('Tela de Acessibilidade segue guidelines de a11y', (WidgetTester tester) async {
    // ensureSemantics() ativa a árvore de semântica no ambiente de teste
    // (necessário pra as guidelines verificarem nós semânticos).
    final SemanticsHandle handle = tester.ensureSemantics();

    // Monta a tela de acessibilidade com um ViewModel fake (Raio-X off).
    await tester.pumpWidget(
      MaterialApp(
        home: AulaAcessibilidadePage(
          viewModel: AulaAcessibilidadeViewModel(
            mostrarRaioX: false,
            aoAlternarRaioX: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Guidelines disponíveis no flutter_test:
    // - androidTapTargetGuideline: alvos de toque >= 48x48 (Android)
    // - iOSTapTargetGuideline: alvos >= 44x44 (iOS)
    // - labeledTapTargetGuideline: alvos clicáveis têm label (leitor de tela)
    // - textContrastGuideline: contraste de texto (WCAG 3:1 texto grande)
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    handle.dispose();
  });
}
