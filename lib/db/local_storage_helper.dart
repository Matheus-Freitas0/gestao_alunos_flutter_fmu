import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import '../models/aluno.dart';

class LocalStorageHelper {
  static final LocalStorageHelper instance = LocalStorageHelper._init();
  static const String _alunosKey = 'alunos_data';
  static const String _nextIdKey = 'next_id';

  LocalStorageHelper._init();

  Future<void> initDatabase() async {
    if (html.window.localStorage[_alunosKey] == null) {
      await _saveAlunos([]);
      await _saveNextId(1);
    }
  }

  Future<List<Aluno>> _getAlunos() async {
    final alunosJson = html.window.localStorage[_alunosKey];

    if (alunosJson == null) return [];

    final List<dynamic> alunosList = json.decode(alunosJson);
    return alunosList.map((json) => Aluno.fromMap(json)).toList();
  }

  Future<void> _saveAlunos(List<Aluno> alunos) async {
    final alunosJson = json.encode(
      alunos.map((aluno) => aluno.toMap()).toList(),
    );
    html.window.localStorage[_alunosKey] = alunosJson;
  }

  Future<int> _getNextId() async {
    final nextIdStr = html.window.localStorage[_nextIdKey];
    return nextIdStr != null ? int.parse(nextIdStr) : 1;
  }

  Future<void> _saveNextId(int id) async {
    html.window.localStorage[_nextIdKey] = id.toString();
  }

  Future<int> createAluno(Aluno aluno) async {
    final alunos = await _getAlunos();
    final nextId = await _getNextId();

    final newAluno = Aluno(
      id: nextId,
      nome: aluno.nome,
      idade: aluno.idade,
      curso: aluno.curso,
      email: aluno.email,
      telefone: aluno.telefone,
      dataCadastro: aluno.dataCadastro,
      status: aluno.status,
    );

    alunos.add(newAluno);
    await _saveAlunos(alunos);
    await _saveNextId(nextId + 1);

    return newAluno.id!;
  }

  Future<List<Aluno>> getAlunos() async {
    return await _getAlunos();
  }

  Future<int> updateAluno(Aluno aluno) async {
    final alunos = await _getAlunos();
    final index = alunos.indexWhere((a) => a.id == aluno.id);

    if (index != -1) {
      alunos[index] = aluno;
      await _saveAlunos(alunos);
      return 1;
    }
    return 0;
  }

  Future<int> deleteAluno(int id) async {
    final alunos = await _getAlunos();
    final initialLength = alunos.length;
    alunos.removeWhere((aluno) => aluno.id == id);
    final finalLength = alunos.length;

    if (initialLength > finalLength) {
      await _saveAlunos(alunos);
      return 1;
    } else {
      return 0;
    }
  }

  Future<List<Aluno>> searchAlunos(String query) async {
    final alunos = await _getAlunos();
    final lowercaseQuery = query.toLowerCase();

    return alunos.where((aluno) {
      return aluno.nome.toLowerCase().contains(lowercaseQuery) ||
          aluno.curso.toLowerCase().contains(lowercaseQuery) ||
          aluno.email.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<Aluno>> getAlunosByStatus(String status) async {
    final alunos = await _getAlunos();
    return alunos.where((aluno) => aluno.status == status).toList();
  }

  Future<int> getTotalAlunos() async {
    final alunos = await _getAlunos();
    return alunos.length;
  }

  Future<int> getAlunosAtivos() async {
    final alunos = await _getAlunos();
    return alunos.where((aluno) => aluno.status == 'ativo').length;
  }

  Future<void> clearAllData() async {
    html.window.localStorage.remove(_alunosKey);
    html.window.localStorage.remove(_nextIdKey);
    await _saveAlunos([]);
    await _saveNextId(1);
  }

  Future<String> exportData() async {
    final alunos = await _getAlunos();
    return json.encode(alunos.map((aluno) => aluno.toMap()).toList());
  }

  Future<bool> importData(String jsonData) async {
    try {
      final List<dynamic> alunosList = json.decode(jsonData);
      final alunos = alunosList.map((json) => Aluno.fromMap(json)).toList();

      int maxId = 0;
      for (final aluno in alunos) {
        if (aluno.id != null && aluno.id! > maxId) {
          maxId = aluno.id!;
        }
      }

      await _saveAlunos(alunos);
      await _saveNextId(maxId + 1);

      return true;
    } catch (e) {
      return false;
    }
  }
}
