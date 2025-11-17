import 'package:dashboard_entregasdev/core/entregadores/models/entregadores_model.dart';
import 'package:dashboard_entregasdev/core/entregadores/services/entregadores_service.dart';

class EntregadoresController {
  final EntregadoresService _service;

  EntregadoresController(this._service);

  Stream<List<EntregadoresModel>> get entregadoresStream => 
  _service.getEntregadoresStream();
  
}