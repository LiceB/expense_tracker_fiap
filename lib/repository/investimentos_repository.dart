import 'package:expense_tracker/models/investimento.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvestimentosRepository {
  Future<List<Investimento>> listarInvestimentos(
      {required String userId}) async {
    final supabase = Supabase.instance.client;

    var query = supabase.from('investimentos').select('''
          *,
          contas (
            *
          )
          ''').eq('user_id', userId);

    var data = await query;

    final list = data.map((map) {
      return Investimento.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarInvestimento(Investimento investimento) async {
    final supabase = Supabase.instance.client;

    await supabase.from('investimentos').insert({
      'user_id': investimento.userId,
      'nome': investimento.nome,
      'valor': investimento.valor,
      'rendimento': investimento.rendimento,
      'conta_id': investimento.conta.id,
    });
  }

  Future alterarInvestimento(Investimento investimento) async {
    final supabase = Supabase.instance.client;

    await supabase.from('investimentos').insert({
      'user_id': investimento.userId,
      'nome': investimento.nome,
      'valor': investimento.valor,
      'rendimento': investimento.rendimento,
      'conta_id': investimento.conta.id,
    });
  }
}
