import 'package:flutter/material.dart';

import '../viewmodel/aula_entrada_permissoes_view_model.dart';

// =============================================================================
// AULA — GERENCIAMENTO DE ENTRADA E PERMISSÕES DO SO (1.1.2) — VERSÃO EXERCÍCIO
// =============================================================================
// Nesta versão escondemos a parte mais \"cabeluda\" (foco, validação, permissões)
// e deixamos marcado com // TODO o que vocês devem completar em aula.
// O layout geral, textos e estrutura já estão prontos.
// =============================================================================

class AulaEntradaPermissoesPage extends StatefulWidget {
  const AulaEntradaPermissoesPage({super.key});

  @override
  State<AulaEntradaPermissoesPage> createState() =>
      _AulaEntradaPermissoesPageState();
}

class _AulaEntradaPermissoesPageState extends State<AulaEntradaPermissoesPage> {
  final AulaEntradaPermissoesViewModel _viewModel =
      AulaEntradaPermissoesViewModel();
  final _formKey = GlobalKey<FormState>();

  FocusNode? _nomeFocus;
  FocusNode? _emailFocus;
  FocusNode? _telefoneFocus;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _nomeFocus = FocusNode();
    _emailFocus = FocusNode();
    _telefoneFocus = FocusNode();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nomeFocus?.dispose();
    _emailFocus?.dispose();
    _telefoneFocus?.dispose();
    super.dispose();
  }

  void _onViewModelChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: fazer o toque fora dos campos fechar o teclado.
      // Dica: use FocusScope.of(context).unfocus().
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entrada e permissões'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // -----------------------------------------------------------------
              // PARTE 1 — GERENCIAMENTO DE ENTRADA (EXERCÍCIO)
              // -----------------------------------------------------------------
              // TODO: completar a parte de foco, teclado e validação:
              // - Usar FocusNode pra saber qual campo tem foco.
              // - Usar textInputAction + onFieldSubmitted pra ir pro próximo.
              // - Implementar validator em cada campo.
              // - No botão, validar e mostrar um Snackbar com o nome.
              // -----------------------------------------------------------------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. Gerenciamento de entrada',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _viewModel.nomeController,
                          // TODO: ligar com um FocusNode específico (ex.: _nomeFocus)
                          focusNode: _nomeFocus,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                            hintText: 'Digite seu nome',
                          ),
                          // TODO: configurar textInputAction pra ir pro próximo campo
                          // TODO: implementar onFieldSubmitted pra mudar o foco pro e-mail
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            // TODO: mudar foco para o campo de e-mail
                            FocusScope.of(context).requestFocus(_emailFocus);
                          },
                          validator: (v) {
                            // TODO: validar o nome (não permitir vazio)
                            if (v == null || v.isEmpty) {
                              return 'Digite seu nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _viewModel.emailController,
                          // TODO: ligar com FocusNode do e-mail
                          focusNode: _emailFocus,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(),
                            hintText: 'email@exemplo.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          // TODO: configurar textInputAction + onFieldSubmitted
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            // TODO: mudar foco para o campo de telefone - TESTE
                            FocusScope.of(context).requestFocus(_telefoneFocus);
                          },
                          validator: (v) {
                            // TODO: validar o e-mail (não vazio + conter '@')
                            if (v == null || v.isEmpty) {
                              return 'Digite seu email';
                            }
                            if (!v.contains('@')) {
                              return 'E-mail inválido, deve conter @';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _viewModel.telefoneController,
                          focusNode: _telefoneFocus,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            border: OutlineInputBorder(),
                            hintText: '(00) 00000-0000',
                          ),
                          keyboardType: TextInputType.phone,
                          // TODO: configurar textInputAction.done e, ao enviar,
                          //       remover o foco pra fechar o teclado.
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            // TODO: remover o foco atual
                            FocusScope.of(context).unfocus();
                          },
                          validator: (v) {
                            // TODO: validar o telefone (não permitir vazio)
                            if (v == null || v.isEmpty) {
                              return 'Digite um telefone';
                            } 
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            // TODO: ao pressionar, validar o formulário,
                            //       fechar o teclado e mostrar um Snackbar
                            //       com o nome digitado.
                            onPressed: () {
                              // TODO: implementar lógica do botão Enviar
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                final nome = _viewModel.nomeController.text;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Olá $nome! Dados enviados.'),
                                  ),
                                );
                              }
                            },

                            child: const Text('Enviar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // -----------------------------------------------------------------
              // PARTE 2 — PERMISSÕES DO SO (EXERCÍCIO)
              // -----------------------------------------------------------------
              // Aqui a ideia é ligar os botões ao ViewModel, que por sua vez
              // usa permission_handler e geolocator. No Flutter Web, o
              // navegador mostra o diálogo de permissão.
              //
              // TODO: no ViewModel, implementar requestCamera() e requestLocation().
              // TODO: aqui na View, ligar os botões a esses métodos e usar
              //       as flags de loading pra desabilitar/mostrar spinner.
              // -----------------------------------------------------------------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2. Permissões do SO (no web: navegador)',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              // TODO: usar _viewModel.cameraLoading pra controlar habilitação
                              //       e chamar _viewModel.requestCamera() ao clicar.
                              onPressed: _viewModel.cameraLoading
                              ?null
                              : () {
                                _viewModel.requestCamera();
                                // TODO: implementar chamada de permissão de câmera
                              },
                              icon: _viewModel.cameraLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.camera_alt_outlined),
                              label: const Text('Câmera'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              // TODO: usar _viewModel.locationLoading e chamar
                              //       _viewModel.requestLocation() ao clicar.
                              onPressed: _viewModel.locationLoading
                              ?null
                              : () {
                                _viewModel.requestLocation();
                                // TODO: implementar chamada de permissão de localização
                              },
                              icon: _viewModel.locationLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.location_on_outlined),
                              label: const Text('Localização'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Câmera: ${_viewModel.cameraStatus}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Localização: ${_viewModel.locationStatus}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
