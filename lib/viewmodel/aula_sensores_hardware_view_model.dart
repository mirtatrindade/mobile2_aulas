import 'dart:async';

import 'package:flutter/foundation.dart';
// TODO: ao implementar obterLocalizacaoAtual() com Geolocator, adicione:
// import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

// =============================================================================
// AULA 1.4 — SENSORES DE HARDWARE (MVVM) — VERSÃO EXERCÍCIO
// =============================================================================
// Esta aula compara sensores contínuos (acelerômetro/giroscópio) com GPS
// (leitura sob demanda). O esqueleto está pronto e as partes importantes
// ficaram marcadas com TODO para os alunos implementarem.
// =============================================================================

class AulaSensoresHardwareViewModel extends ChangeNotifier {
  // Leituras do acelerômetro (m/s²) e giroscópio (rad/s).
  double ax = 0;
  double ay = 0;
  double az = 0;
  double gx = 0;
  double gy = 0;
  double gz = 0;

  // GPS: latitude, longitude e precisão em metros.
  double? latitude;
  double? longitude;
  double? precisao;

  bool sensoresAtivos = false;
  bool gpsLoading = false;
  String? mensagemErro;

  StreamSubscription<UserAccelerometerEvent>? _accSub;
  StreamSubscription<GyroscopeEvent>? _gyrSub;

  Future<void> iniciarMonitoramentoSensores() async {
    // TODO: assinar userAccelerometerEventStream e gyroscopeEventStream.
    // Dicas:
    // 1) Guardar cada StreamSubscription em _accSub e _gyrSub.
    // 2) Atualizar ax/ay/az e gx/gy/gz dentro dos listeners.
    // 3) Chamar notifyListeners() quando atualizar leituras.
    // 4) Lidar com múltiplos cliques (evitar dupla assinatura).

    if (sensoresAtivos) return;

    sensoresAtivos = true;
    mensagemErro = null;

    _accSub = userAccelerometerEventStream().listen((event) {
      ax = event.x;
      ay = event.y;
      az = event.z;
      notifyListeners();
    });

    _gyrSub = gyroscopeEventStream().listen((event) {
      gx = event.x;
      gy = event.y;
      gz = event.z;
      notifyListeners();
    });
  }

  Future<void> pararMonitoramentoSensores() async {
    // TODO: cancelar _accSub e _gyrSub de forma segura.
    // Dicas:
    // 1) await _accSub?.cancel(); await _gyrSub?.cancel();
    // 2) Limpar referências das subscriptions (setar null).
    // 3) Atualizar sensoresAtivos e notifyListeners().

    await _accSub?.cancel();
    await _gyrSub?.cancel();

    _accSub = null;
    _gyrSub = null;

    sensoresAtivos = false;
    notifyListeners();
  }

  Future<void> obterLocalizacaoAtual() async {
    gpsLoading = true;
    mensagemErro = null;
    notifyListeners();

    // TODO: implementar fluxo completo de GPS usando Geolocator.
    // Dicas:
    // 1) Verificar serviço ativo: Geolocator.isLocationServiceEnabled().
    // 2) Verificar/solicitar permissão com checkPermission/requestPermission.
    // 3) Chamar Geolocator.getCurrentPosition() se permitido.
    // 4) Atualizar latitude/longitude/precisao e notifyListeners().
    // 5) Em erro, preencher mensagemErro.

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        mensagemErro = 'El GPS está desactivado';
        gpsLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          mensagemErro = 'Permiso de ubicación denegado';
          gpsLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        mensagemErro = 'Permiso denegado permanentemente';
        gpsLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      latitude = position.latitude;
      longitude = position.longitude;
      precisao = position.accuracy;

      notifyListeners();
    } catch (e) {
      mensagemErro = 'Error al obtener ubicación';
    }

    gpsLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: garantir limpeza de recursos chamando pararMonitoramentoSensores()
    // antes de super.dispose(). Como dispose() não é async, os alunos podem:
    // - cancelar sem await (chamada direta em cada sub), ou
    // - criar método sync auxiliar para cancelar.

    pararMonitoramentoSensores();
    super.dispose();
  }
}
