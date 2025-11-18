import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

import 'loc_model.dart';

class MapaSelecaoDialog extends StatefulWidget {
  const MapaSelecaoDialog({super.key});

  @override
  State<MapaSelecaoDialog> createState() => _MapaSelecaoDialogState();
}

class _MapaSelecaoDialogState extends State<MapaSelecaoDialog> {
  lat_lng.LatLng? _selecionado;

  final lat_lng.LatLng _initialCenter = lat_lng.LatLng(-29.68992715185767, -52.45519309973022);

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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Indique a posição do cliente',
                      style: TextStyle(
                        color: AppColors.branco,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: AppColors.cinza),
                    ),
                  ],
                ),
              ),

              // MAPA
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: FlutterMap(
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
                        userAgentPackageName: 'com.example.app',
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
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_selecionado != null)
                      Text(
                        'Lat: ${_selecionado!.latitude.toStringAsFixed(6)}   '
                        'Lon: ${_selecionado!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          color: AppColors.cinza,
                          fontSize: 12,
                        ),
                      )
                    else
                      Text(
                        'Clique no mapa para selecionar a posição',
                        style: TextStyle(
                          color: AppColors.cinza,
                          fontSize: 12,
                        ),
                      ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: _selecionado == null
                              ? null
                              : () {
                                  Navigator.of(context).pop(
                                    PosicaoSelecionada(  
                                      _selecionado!.latitude,
                                      _selecionado!.longitude,
                                    ),
                                  );
                                },
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
