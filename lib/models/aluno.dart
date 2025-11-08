import 'package:flutter/material.dart';

class Aluno {
  int? id;
  String nome;
  int idade;
  String curso;
  String email;
  String telefone;
  DateTime dataCadastro;
  String status;

  Aluno({
    this.id,
    required this.nome,
    required this.idade,
    required this.curso,
    required this.email,
    required this.telefone,
    required this.dataCadastro,
    this.status = 'ativo',
  });

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
      curso: map['curso'],
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      dataCadastro: DateTime.parse(
        map['data_cadastro'] ?? DateTime.now().toIso8601String(),
      ),
      status: map['status'] ?? 'ativo',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'curso': curso,
      'email': email,
      'telefone': telefone,
      'data_cadastro': dataCadastro.toIso8601String(),
      'status': status,
    };
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get isValidPhone {
    return RegExp(r'^\(?[1-9]{2}\)? ?[0-9]{4,5}-?[0-9]{4}$').hasMatch(telefone);
  }

  bool get isValidAge {
    return idade >= 16 && idade <= 100;
  }

  bool get isValidName {
    return nome.trim().length >= 2;
  }

  String get formattedPhone {
    if (telefone.length == 11) {
      return '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7)}';
    } else if (telefone.length == 10) {
      return '(${telefone.substring(0, 2)}) ${telefone.substring(2, 6)}-${telefone.substring(6)}';
    }
    return telefone;
  }

  String get formattedDate {
    return '${dataCadastro.day.toString().padLeft(2, '0')}/${dataCadastro.month.toString().padLeft(2, '0')}/${dataCadastro.year}';
  }

  Color get statusColor {
    switch (status) {
      case 'ativo':
        return Colors.green;
      case 'inativo':
        return Colors.orange;
      case 'trancado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
