import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

import 'models/loc_model.dart';

class MapaSelecaoDialog extends StatefulWidget {
  const MapaSelecaoDialog({super.key});

  @override
  State<MapaSelecaoDialog> createState() => _MapaSelecaoDialogState();
}

class _MapaSelecaoDialogState extends State<MapaSelecaoDialog> {
  lat_lng.LatLng? _selecionado;

  final lat_lng.LatLng _initialCenter = lat_lng.LatLng(
    -29.68992715185767,
    -52.45519309973022,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 900,
          height: 560,
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              // MAPA
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: _initialCenter,
                          initialZoom: 13,
                          onTap: (tapPos, latlng) {
                            setState(() {
                              _selecionado = latlng;
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'dashboard_entregasdev',
                          ),
                          if (_selecionado != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _selecionado!,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 40,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cinza,
                            foregroundColor: AppColors.branco,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: () {
                            if (_selecionado == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Toque no mapa para selecionar uma posição',
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.of(context).pop(
                              PosicaoSelecionada(
                                _selecionado!.latitude,
                                _selecionado!.longitude,
                              ),
                            );
                          },
                          child: const Text('Salvar'),
                        ),
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
