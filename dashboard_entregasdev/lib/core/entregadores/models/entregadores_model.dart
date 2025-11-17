class EntregadoresModel {
  final String nome;
  final String localizacao;
  final String status;

  EntregadoresModel({
    required this.nome,
    required this.localizacao,
    required this.status,
  });

  factory EntregadoresModel.fromMap(Map<String, dynamic> data) {
    return EntregadoresModel(
      nome: data['nome'] ?? 'Nome não encontrado',
      localizacao: data['localizacao'] ?? 'Localização não encontrada',
      status: data['status'] ?? 'Status não encontrado',
    );
  }
}