import 'package:expense_tracker/models/investimento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestimentoItem extends StatelessWidget {
  final Investimento investimento;
  final void Function()? onTap;
  const InvestimentoItem(
      {super.key, required this.investimento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          investimento.nome,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      title: Text(investimento.nome),
      subtitle: Text(
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(investimento.valor),
      ),
      onTap: onTap,
    );
  }
}
