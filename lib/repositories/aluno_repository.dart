import 'dart:convert';

import '../models/aluno.dart';
import '../services/aluno_api_service.dart';

class AlunoRepository {
  AlunoRepository({AlunoApiService? service})
      : _service = service ?? _sharedService;

  static final AlunoApiService _sharedService = AlunoApiService();
  final AlunoApiService _service;

  Future<List<Aluno>> listar({
    String? busca,
    String? status,
  }) {
    return _service.fetchAlunos(search: busca, status: status);
  }

  Future<Aluno> obter(int id) {
    return _service.fetchAluno(id);
  }

  Future<Aluno> salvar(Aluno aluno) {
    if (aluno.id != null) {
      return _service.updateAluno(aluno);
    }
    return _service.createAluno(aluno);
  }

  Future<void> remover(int id) {
    return _service.deleteAluno(id);
  }

  Future<void> removerTodos() {
    return _service.deleteAll();
  }

  Future<int> importar(String jsonData) async {
    final List<dynamic> dados = jsonDecode(jsonData) as List<dynamic>;
    final alunos = dados
        .map((item) => Aluno.fromMap(item as Map<String, dynamic>))
        .toList(growable: false);
    return _service.importAlunos(alunos);
  }

  Future<String> exportar() {
    return _service.exportAsJson();
  }

  Future<Map<String, int>> obterEstatisticas() async {
    final alunos = await listar();

    final total = alunos.length;
    final ativos = alunos.where((aluno) => aluno.status == 'ativo').length;
    final inativos = alunos.where((aluno) => aluno.status == 'inativo').length;
    final trancados = alunos.where((aluno) => aluno.status == 'trancado').length;

    return <String, int>{
      'total': total,
      'ativos': ativos,
      'inativos': inativos,
      'trancados': trancados,
    };
  }
}

