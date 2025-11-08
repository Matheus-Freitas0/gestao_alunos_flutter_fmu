import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/aluno.dart';
import '../repositories/aluno_repository.dart';

class CadastroPage extends StatefulWidget {
  final Aluno? aluno;

  const CadastroPage({super.key, this.aluno});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _cursoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  String _selectedStatus = 'ativo';
  bool _isLoading = false;
  final AlunoRepository _repository = AlunoRepository();

  final List<String> _statusOptions = ['ativo', 'inativo', 'trancado'];

  @override
  void initState() {
    super.initState();
    if (widget.aluno != null) {
      _nomeController.text = widget.aluno!.nome;
      _idadeController.text = widget.aluno!.idade.toString();
      _cursoController.text = widget.aluno!.curso;
      _emailController.text = widget.aluno!.email;
      _telefoneController.text = widget.aluno!.telefone;
      _selectedStatus = widget.aluno!.status;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Idade é obrigatória';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Idade deve ser um número válido';
    }
    if (age < 16 || age > 100) {
      return 'Idade deve estar entre 16 e 100 anos';
    }
    return null;
  }

  String? _validateCourse(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Curso é obrigatório';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }
    final phoneRegex = RegExp(r'^\(?[1-9]{2}\)? ?[0-9]{4,5}-?[0-9]{4}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Telefone inválido';
    }
    return null;
  }

  void _formatPhone(String value) {
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    String formatted = '';

    if (digits.length >= 2) {
      formatted = '(${digits.substring(0, 2)})';
      if (digits.length > 2) {
        formatted +=
            ' ${digits.substring(2, digits.length > 6 ? 7 : digits.length)}';
        if (digits.length > 7) {
          formatted += '-${digits.substring(7)}';
        }
      }
    } else {
      formatted = digits;
    }

    _telefoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _saveAluno() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final telefoneDigits = _telefoneController.text.replaceAll(RegExp(r'[^\d]'), '');

      final aluno = Aluno(
        id: widget.aluno?.id,
        nome: _nomeController.text.trim(),
        idade: int.parse(_idadeController.text),
        curso: _cursoController.text.trim(),
        email: _emailController.text.trim(),
        telefone: telefoneDigits,
        dataCadastro: widget.aluno?.dataCadastro ?? DateTime.now(),
        status: _selectedStatus,
      );

      await _repository.salvar(aluno);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.aluno != null
                  ? 'Aluno atualizado com sucesso!'
                  : 'Aluno cadastrado com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.aluno != null;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        isEditing ? 'Editar Aluno' : 'Cadastrar Aluno',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          _buildSectionTitle('Informações Pessoais'),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              labelText: 'Nome Completo',
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Digite o nome completo',
                            ),
                            validator: _validateName,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _idadeController,
                            decoration: const InputDecoration(
                              labelText: 'Idade',
                              prefixIcon: Icon(Icons.cake),
                              hintText: 'Digite a idade',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: _validateAge,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Digite o email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _telefoneController,
                            decoration: const InputDecoration(
                              labelText: 'Telefone',
                              prefixIcon: Icon(Icons.phone),
                              hintText: '(11) 99999-9999',
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: _formatPhone,
                            validator: _validatePhone,
                          ),
                          const SizedBox(height: 24),

                          
                          _buildSectionTitle('Informações Acadêmicas'),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _cursoController,
                            decoration: const InputDecoration(
                              labelText: 'Curso',
                              prefixIcon: Icon(Icons.school),
                              hintText: 'Digite o curso',
                            ),
                            validator: _validateCourse,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              prefixIcon: Icon(Icons.info),
                            ),
                            items: _statusOptions.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(status.toUpperCase()),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 32),

                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveAluno,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      isEditing
                                          ? 'Salvar Alterações'
                                          : 'Cadastrar Aluno',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Color _getStatusColor(String status) {
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
