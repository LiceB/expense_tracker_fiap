import 'package:expense_tracker/models/conta.dart';

class Investimento {
  int id;
  String userId;
  String nome;
  double valor;
  double rendimento;
  Conta conta;

  Investimento({
    required this.id,
    required this.userId,
    required this.nome,
    required this.valor,
    required this.rendimento,
    required this.conta,
  });

  factory Investimento.fromMap(Map<String, dynamic> map) {
    return Investimento(
      id: map['id'],
      userId: map['user_id'],
      nome: map['nome'],
      valor: map['valor'],
      rendimento: map['rendimento'],
      conta: Conta.fromMap(map['contas']),
    );
  }
}
