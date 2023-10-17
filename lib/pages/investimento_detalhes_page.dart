import 'package:expense_tracker/components/conta_item.dart';
import 'package:expense_tracker/models/investimento.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestimentoDetalhesPage extends StatefulWidget {
  const InvestimentoDetalhesPage({super.key});

  @override
  State<InvestimentoDetalhesPage> createState() =>
      _InvestimentoDetalhesPageState();
}

class _InvestimentoDetalhesPageState extends State<InvestimentoDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final investimento =
        ModalRoute.of(context)!.settings.arguments as Investimento;

    return Scaffold(
      appBar: AppBar(
        title: Text(investimento.nome),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContaItem(conta: investimento.conta),
            ListTile(
              title: const Text('Investimento'),
              subtitle: Text(investimento.nome),
            ),
            ListTile(
              title: const Text('Valor'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(investimento.valor)),
            ),
            ListTile(
              title: const Text('Rendimento'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(investimento.rendimento)),
            ),
            LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3),
                      FlSpot(1, 1),
                      FlSpot(2, 4),
                      FlSpot(3, 2),
                      FlSpot(4, 3),
                      FlSpot(5, 5),
                      FlSpot(6, 4),
                    ],
                    isCurved: false,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
