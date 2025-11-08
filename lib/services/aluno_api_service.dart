import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/aluno.dart';

class AlunoApiService {
  AlunoApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUri = Uri.parse(
        '${(baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '')}/students/',
      );

  final http.Client _client;
  final Uri _baseUri;

  Future<List<Aluno>> fetchAlunos({String? search, String? status}) async {
    final uri = _baseUri.replace(
      queryParameters: <String, String?>{
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty && status != 'todos')
          'status': status,
      }..removeWhere((_, value) => value == null),
    );

    final response = await _client.get(uri);
    _ensureSuccess(response);

    final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
    return body
        .map((json) => Aluno.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  Future<Aluno> fetchAluno(int id) async {
    final uri = _baseUri.resolve('$id');
    final response = await _client.get(uri);
    _ensureSuccess(response);
    return Aluno.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Aluno> createAluno(Aluno aluno) async {
    final response = await _client.post(
      _baseUri,
      headers: _jsonHeaders,
      body: jsonEncode(_toRequestBody(aluno, includeId: false)),
    );
    _ensureSuccess(response, expectedStatus: 201);
    return Aluno.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Aluno> updateAluno(Aluno aluno) async {
    if (aluno.id == null) {
      throw ArgumentError('Aluno precisa possuir id para atualização');
    }

    final uri = _baseUri.resolve('${aluno.id}');
    final response = await _client.put(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode(_toRequestBody(aluno, includeId: false)),
    );
    _ensureSuccess(response);
    return Aluno.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteAluno(int id) async {
    final uri = _baseUri.resolve('$id');
    final response = await _client.delete(uri);
    _ensureSuccess(response, expectedStatus: 204);
  }

  Future<void> deleteAll() async {
    final response = await _client.delete(_baseUri);
    _ensureSuccess(response, expectedStatus: 204);
  }

  Future<int> importAlunos(List<Aluno> alunos) async {
    final response = await _client.post(
      _baseUri.resolve('import'),
      headers: _jsonHeaders,
      body: jsonEncode(
        alunos.map((aluno) => _toRequestBody(aluno, includeId: false)).toList(),
      ),
    );
    _ensureSuccess(response, expectedStatus: 201);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return (decoded['imported'] as num?)?.toInt() ?? 0;
  }

  Future<String> exportAsJson() async {
    final alunos = await fetchAlunos();
    return jsonEncode(alunos.map((aluno) => aluno.toMap()).toList());
  }

  void dispose() {
    _client.close();
  }

  Map<String, dynamic> _toRequestBody(Aluno aluno, {required bool includeId}) {
    final map = aluno.toMap();
    if (!includeId) {
      map.remove('id');
    }
    return map;
  }

  void _ensureSuccess(http.Response response, {int expectedStatus = 200}) {
    if (response.statusCode != expectedStatus) {
      throw Exception('Erro na API (${response.statusCode}): ${response.body}');
    }
  }

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };
}
