import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO: adicionar os imports abaixo quando for implementar as permissões
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// =============================================================================
// AULA ENTRADA E PERMISSÕES — VIEW MODEL (MVVM) — VERSÃO EXERCÍCIO
// =============================================================================
// Guarda os controllers do formulário (entrada) e o status das permissões.
// Nesta versão, escondemos a lógica principal e marcamos pontos com // TODO
// para vocês implementarem em aula.
// =============================================================================

class AulaEntradaPermissoesViewModel extends ChangeNotifier {
  AulaEntradaPermissoesViewModel() {
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _telefoneController = TextEditingController();
  }

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;

  TextEditingController get nomeController => _nomeController;
  TextEditingController get emailController => _emailController;
  TextEditingController get telefoneController => _telefoneController;

  String _cameraStatus = 'Não verificado';
  String _locationStatus = 'Não verificado';
  bool _locationLoading = false;
  bool _cameraLoading = false;

  String get cameraStatus => _cameraStatus;
  String get locationStatus => _locationStatus;
  bool get locationLoading => _locationLoading;
  bool get cameraLoading => _cameraLoading;

  Future<void> requestCamera() async {
    // TODO: implementar fluxo de permissão de CÂMERA usando permission_handler.
    // Dica de passos:
    // 1. Marcar _cameraLoading como true e chamar notifyListeners().
    // 2. Usar Permission.camera.status pra ver o estado atual.
    // 3. Se ainda não estiver concedido, chamar Permission.camera.request().
    // 4. Atualizar _cameraStatus com base no resultado (Concedido/Negado/etc.).
    // 5. Marcar _cameraLoading como false e chamar notifyListeners().
    //
    // Por enquanto deixamos um texto fixo pra tela não quebrar.
    _cameraLoading = true;
    _cameraStatus = 'TODO: implementar requestCamera()';
    notifyListeners();

    _cameraLoading = false;
    notifyListeners();

    var status = await Permission.camera.request();

    if (status.isGranted) {
      _cameraStatus = 'Concedido';
    } else {
      _cameraStatus = 'Negado';
    }

    notifyListeners();
  }

  Future<void> requestLocation() async {
    // TODO: implementar fluxo de permissão de LOCALIZAÇÃO usando geolocator.
    // Dica de passos:
    // 1. Marcar _locationLoading como true e chamar notifyListeners().
    // 2. Verificar se o serviço de localização está ligado com
    //    Geolocator.isLocationServiceEnabled().
    // 3. Checar/perguntar permissão com Geolocator.checkPermission() e
    //    Geolocator.requestPermission().
    // 4. Se permitido, chamar Geolocator.getCurrentPosition() e montar uma
    //    string com latitude/longitude (use toStringAsFixed(4)).
    // 5. Atualizar _locationStatus com a mensagem adequada (ou erro).
    // 6. Marcar _locationLoading como false e chamar notifyListeners().
    //
    // Aqui também deixamos um texto fixo só pra app continuar rodando.
    _locationLoading = true;
    notifyListeners();
    
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationStatus = 'Localização desativada';
      _locationLoading = false;
      notifyListeners();
      return;
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
     permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _locationStatus = 'Permissão de localização negada';
        _locationLoading = false;
        notifyListeners();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _locationStatus = 'Permissão negada permanentemente';
      _locationLoading = false;
      notifyListeners();
      return;
    }
  
    
  Position position = await Geolocator.getCurrentPosition();
  
  String lat = position.latitude.toStringAsFixed(4);
  String lon = position.longitude.toStringAsFixed(4);

  _locationStatus = 'Lat: $lat  Lon: $lon';

  _locationLoading = false;
  notifyListeners();
}
  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }
}

