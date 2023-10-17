import 'package:expense_tracker/components/investimento_item.dart';
import 'package:expense_tracker/models/investimento.dart';
import 'package:expense_tracker/pages/investimento_cadastro_page.dart';
import 'package:expense_tracker/repository/investimentos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvestimentosPage extends StatefulWidget {
  const InvestimentosPage({super.key});

  @override
  State<InvestimentosPage> createState() => _InvestimentosPageState();
}

class _InvestimentosPageState extends State<InvestimentosPage> {
  final investimentosRepo = InvestimentosRepository();
  late Future<List<Investimento>> futureInvestimentos;
  User? user;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;
    futureInvestimentos =
        investimentosRepo.listarInvestimentos(userId: user?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investimentos'),
      ),
      body: FutureBuilder<List<Investimento>>(
        future: futureInvestimentos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar as investimentos"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum investimento cadastrado"),
            );
          } else {
            final investimentos = snapshot.data!;
            return ListView.separated(
              itemCount: investimentos.length,
              itemBuilder: (context, index) {
                final investimento = investimentos[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvestimentoCadastroPage(),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              futureInvestimentos =
                                  investimentosRepo.listarInvestimentos(
                                userId: user?.id ?? '',
                              );
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) async {},
                      ),
                    ],
                  ),
                  child: InvestimentoItem(
                    investimento: investimento,
                    onTap: () {
                      Navigator.pushNamed(context, '/investimento-detalhe',
                          arguments: investimento);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "investimento-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/investimento-cadastro')
                  as bool?;

          if (result == true) {
            setState(() {
              futureInvestimentos = investimentosRepo.listarInvestimentos(
                userId: user?.id ?? '',
              );
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
