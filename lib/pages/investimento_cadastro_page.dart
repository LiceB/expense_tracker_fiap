import 'package:expense_tracker/components/conta_select.dart';
import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/models/investimento.dart';
import 'package:expense_tracker/pages/contas_select_page.dart';
import 'package:expense_tracker/repository/investimentos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvestimentoCadastroPage extends StatefulWidget {
  final Investimento? investimentoParaEdicao;
  const InvestimentoCadastroPage({super.key, this.investimentoParaEdicao});

  @override
  State<InvestimentoCadastroPage> createState() =>
      _InvestimentoCadastroPageState();
}

class _InvestimentoCadastroPageState extends State<InvestimentoCadastroPage> {
  User? user;
  final investimentosRepo = InvestimentosRepository();

  final nomeController = TextEditingController();

  final valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final rendimentoController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: '%');

  final _formKey = GlobalKey<FormState>();

  Conta? contaSelecionada;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final investimento = widget.investimentoParaEdicao;

    if (investimento != null) {
      contaSelecionada = investimento.conta;

      nomeController.text = investimento.nome;
      valorController.text = NumberFormat.simpleCurrency(locale: 'pt_BR')
          .format(investimento.valor);
      rendimentoController.text = NumberFormat.simpleCurrency(locale: 'pt_BR')
          .format(investimento.valor);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Investimento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNome(),
                const SizedBox(height: 30),
                _buildValor(),
                const SizedBox(height: 30),
                _buildContaSelect(),
                const SizedBox(height: 30),
                _buildRendimento(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildNome() {
    return TextFormField(
      controller: nomeController,
      decoration: const InputDecoration(
        hintText: 'Informe o investimento',
        labelText: 'Nome',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um nome';
        }
        if (value.length < 3 || value.length > 30) {
          return 'O nome deve entre 3 e 30 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildValor() {
    return TextFormField(
      controller: valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  TextFormField _buildRendimento() {
    return TextFormField(
      controller: rendimentoController,
      decoration: const InputDecoration(
        hintText: 'Informe o rendimento',
        labelText: 'Rendimento',
        prefixIcon: Icon(Icons.numbers_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um rendimento';
        }
        if (value.length < 3 || value.length > 30) {
          return 'O rendimento deve entre 3 e 30 caracteres';
        }
        return null;
      },
    );
  }

  ContaSelect _buildContaSelect() {
    return ContaSelect(
      conta: contaSelecionada,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ContasSelectPage(),
          ),
        ) as Conta?;

        if (result != null) {
          setState(() {
            contaSelecionada = result;
          });
        }
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            var systemLocale = Localizations.localeOf(context);
            // Nome
            final nome = nomeController.text;

            // Valor
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorController.text.replaceAll('R\$', ''));

            // Rendimento
            final rendimento = NumberFormat.decimalPercentPattern(
              locale: systemLocale.languageCode,
              decimalDigits: 2,
            ).parse(rendimentoController.text.replaceAll('%', ''));

            final userId = user?.id ?? '';

            final investimento = Investimento(
              id: 0,
              userId: userId,
              nome: nome,
              valor: valor.toDouble(),
              rendimento: rendimento.toDouble(),
              conta: contaSelecionada!,
            );

            if (widget.investimentoParaEdicao == null) {
              await _cadastrarInvestimento(investimento);
            } else {
              investimento.id = widget.investimentoParaEdicao!.id;
              await _alterarInvestimento(investimento);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  Future<void> _cadastrarInvestimento(Investimento investimento) async {
    final scaffold = ScaffoldMessenger.of(context);
    await investimentosRepo.cadastrarInvestimento(investimento).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao cadastrar',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarInvestimento(Investimento investimento) async {
    final scaffold = ScaffoldMessenger.of(context);
    await investimentosRepo.alterarInvestimento(investimento).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Alterada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
