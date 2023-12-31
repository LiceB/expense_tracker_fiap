import 'package:expense_tracker/models/investimento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class InvestimentoItem extends StatelessWidget {
  final Investimento investimento;
  final void Function()? onTap;
  const InvestimentoItem(
      {super.key, required this.investimento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Ionicons.bar_chart_outline)),
      title: Text(investimento.nome),
      subtitle: Text(
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(investimento.valor),
      ),
      onTap: onTap,
    );
  }
}
