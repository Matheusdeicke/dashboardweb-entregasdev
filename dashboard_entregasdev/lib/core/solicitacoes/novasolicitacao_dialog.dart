import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'loc_model.dart';
import 'map.dart';

class NovaSolicitacaoDialog extends StatefulWidget {
  const NovaSolicitacaoDialog({super.key});

  @override
  State<NovaSolicitacaoDialog> createState() => _NovaSolicitacaoDialogState();
}

class _NovaSolicitacaoDialogState extends State<NovaSolicitacaoDialog> {
  final TextEditingController _localizacaoController = TextEditingController();
  double? _lat;
  double? _lon;
  bool _salvando = false;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nova solicitação',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColors.cinza),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Localização (lat, lon)',
                  style: TextStyle(
                    color: AppColors.cinza,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _localizacaoController,
                readOnly: true,
                onTap: _abrirMapa,
                decoration: InputDecoration(
                  hintText: 'Clique para escolher no mapa',
                  hintStyle: TextStyle(color: AppColors.cinza),
                  filled: true,
                  fillColor: AppColors.bgColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide(color: AppColors.cinza),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide(color: AppColors.branco),
                  ),
                  suffixIcon: TextButton(
                    onPressed: _abrirMapa,
                    child: const Text(
                      'Usar mapa',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _salvando ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.cinza),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.branco,
                      foregroundColor: AppColors.preto,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: (!_salvando && _lat != null && _lon != null)
                        ? _salvar
                        : null,
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
        _localizacaoController.text =
            '${result.lat.toStringAsFixed(6)}, ${result.lon.toStringAsFixed(6)}';
      });
    }
  }

  Future<void> _salvar() async {
    if (_lat == null || _lon == null) return;

    setState(() => _salvando = true);

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
