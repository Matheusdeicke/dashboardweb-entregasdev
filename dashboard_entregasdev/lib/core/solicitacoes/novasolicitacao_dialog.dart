import 'package:dashboard_entregasdev/core/solicitacoes/services/location_service.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'models/loc_model.dart';
import 'map.dart';

class NovaSolicitacaoDialog extends StatefulWidget {
  const NovaSolicitacaoDialog({super.key});

  @override
  State<NovaSolicitacaoDialog> createState() => _NovaSolicitacaoDialogState();
}

class _NovaSolicitacaoDialogState extends State<NovaSolicitacaoDialog> {
  final TextEditingController _localizacaoController = TextEditingController();
  
  final LocationService _locationService = LocationService();

  double? _lat;
  double? _lon;
  bool _salvando = false;
  bool _buscandoEndereco = false;
  String? _erro;

  @override
  void dispose() {
    _localizacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                blurRadius: 24,
                color: Colors.black54,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Localização',
                  style: TextStyle(color: AppColors.cinza, fontSize: 13),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _localizacaoController,
                readOnly: true,
                onTap: _abrirMapa,
                style: TextStyle(color: AppColors.branco),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.bgColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  suffixIcon: _buscandoEndereco
                      ? Transform.scale(scale: 0.5, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cinza))
                      : Icon(Icons.map, color: AppColors.cinza),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide(color: AppColors.cinza),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide(color: AppColors.branco),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (_erro != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _erro!,
                    style: TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _salvando
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.cinza),
                    ),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cinza,
                      foregroundColor: AppColors.branco,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: _salvar,
                    child: _salvando
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _abrirMapa() async {
    final result = await showDialog<PosicaoSelecionada>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MapaSelecaoDialog(),
    );

    if (result != null) {
      setState(() {
        _lat = result.lat;
        _lon = result.lon;
        _buscandoEndereco = true;
        _localizacaoController.text =
            'Buscando endereço...';
      });

      print('Coordenadas selecionadas: Lat ${result.lat}, Lon ${result.lon}');

      String endereco = await _locationService.transformarCoordenadasEmEndereco(
        result.lat,
        result.lon,
      );

      if (mounted) {
        setState(() {
          _buscandoEndereco = false;
          _localizacaoController.text = endereco;
        });
      }
    }
  }

  Future<void> _salvar() async {
    if (_lat == null || _lon == null) {
      setState(() {
        _erro = 'Por favor, selecione uma localização.';
      });
      return;
    }

    setState(() {
      _salvando = true;
      _erro = null;
    });

    try {
      await _locationService.salvarSolicitacao(
        lat: _lat!,
        lon: _lon!,
        enderecoCompleto: _localizacaoController.text,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _erro = 'Erro ao salvar solicitação. Tente novamente.';
          _salvando = false;
        });
      }
    }
  }
}
