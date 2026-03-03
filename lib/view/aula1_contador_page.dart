import 'package:flutter/material.dart';

import '../viewmodel/aula1_contador_view_model.dart';

// =============================================================================
// AULA 1 — CONTADOR (View em MVVM)
// =============================================================================
// Esta tela é a View do contador: ela só exibe o valor e repassa os toques
// pro ViewModel. O estado (counter) e a lógica (increment, decrement, etc.)
// estão no Aula1ContadorViewModel. A View escuta o ViewModel e reconstrói
// quando ele chama notifyListeners().
// =============================================================================

class Aula1ContadorPage extends StatefulWidget {
  const Aula1ContadorPage({super.key});

  @override
  State<Aula1ContadorPage> createState() => _Aula1ContadorPageState();
}

class _Aula1ContadorPageState extends State<Aula1ContadorPage> {
  final Aula1ContadorViewModel _viewModel = Aula1ContadorViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final counter = _viewModel.counter;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Aula 1 — Contador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Você pressionou o botão este número de vezes:'),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: counter < 0 ? Colors.red : Colors.blue,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'increment',
                onPressed: _viewModel.increment,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'decrement',
                onPressed: _viewModel.decrement,
                tooltip: 'Decrement',
                backgroundColor: Colors.red[100],
                child: const Icon(Icons.remove, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'multiply',
                onPressed: _viewModel.multiply,
                tooltip: 'Multiply',
                backgroundColor: Colors.green[100],
                child: const Icon(
                  Icons.dynamic_feed_sharp,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'divide',
                onPressed: _viewModel.divide,
                tooltip: 'Divide',
                backgroundColor: Colors.yellow[100],
                child: const Icon(
                  Icons.do_disturb_off_outlined,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
