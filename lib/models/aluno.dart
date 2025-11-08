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
    final dataCadastroRaw =
        map['dataCadastro'] ??
        map['data_cadastro'] ??
        DateTime.now().toIso8601String();
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
      curso: map['curso'],
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      dataCadastro: dataCadastroRaw is DateTime
          ? dataCadastroRaw
          : DateTime.parse(dataCadastroRaw as String),
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
      'dataCadastro': dataCadastro.toIso8601String(),
      'status': status,
    };
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get isValidPhone {
    final digitsOnly = telefone.replaceAll(RegExp(r'[^\d]'), '');
    return RegExp(r'^[1-9]{2}[0-9]{8,9}$').hasMatch(digitsOnly);
  }

  bool get isValidAge {
    return idade >= 16 && idade <= 100;
  }

  bool get isValidName {
    return nome.trim().length >= 2;
  }

  String get formattedPhone {
    final digitsOnly = telefone.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length == 11) {
      return '(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 7)}-${digitsOnly.substring(7)}';
    } else if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 6)}-${digitsOnly.substring(6)}';
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
