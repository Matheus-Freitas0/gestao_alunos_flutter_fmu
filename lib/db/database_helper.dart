import '../models/aluno.dart';
import 'local_storage_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<void> initDatabase() async {
    await LocalStorageHelper.instance.initDatabase();
  }

  Future<int> createAluno(Aluno aluno) async {
    return await LocalStorageHelper.instance.createAluno(aluno);
  }

  Future<List<Aluno>> getAlunos() async {
    return await LocalStorageHelper.instance.getAlunos();
  }

  Future<int> updateAluno(Aluno aluno) async {
    return await LocalStorageHelper.instance.updateAluno(aluno);
  }

  Future<int> deleteAluno(int id) async {
    return await LocalStorageHelper.instance.deleteAluno(id);
  }

  Future<List<Aluno>> searchAlunos(String query) async {
    return await LocalStorageHelper.instance.searchAlunos(query);
  }

  Future<List<Aluno>> getAlunosByStatus(String status) async {
    return await LocalStorageHelper.instance.getAlunosByStatus(status);
  }

  Future<int> getTotalAlunos() async {
    return await LocalStorageHelper.instance.getTotalAlunos();
  }

  Future<int> getAlunosAtivos() async {
    return await LocalStorageHelper.instance.getAlunosAtivos();
  }

  Future<void> clearAllData() async {
    await LocalStorageHelper.instance.clearAllData();
  }

  Future<String> exportData() async {
    return await LocalStorageHelper.instance.exportData();
  }

  Future<bool> importData(String jsonData) async {
    return await LocalStorageHelper.instance.importData(jsonData);
  }
}
