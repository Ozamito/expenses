import 'package:expenses/components/transaction_item.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            //LayoutBuilder pra ter acesso as dimensoes de onde vai ser exibido
            return Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'No Transactions Registered',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                Container(
                  //precisa do LayoutBuilder pra usar o constraints
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            //se a lista tiver um/dois mil elementos (seja qnts forem) ele vai
            //percorrer cada um dos elementos apartir do map de transactions abaixo
            //e vai converter cada uma das transacoes em um card, gerando toda essa
            //estrutura mesmo que os elementos nao estejam visualmente na tela
            //mesmo que vc soh consiga visualizar digamos 4 por vez os outros
            //elementos ja estaram la embaixo todos renderizados e eventualmente
            //vai ocupa muita memoria do celular, por isso se usa o .builder
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              //com os item ele vai chamando e renderizando conforme tem o espaco
              //na tela, os elementos fora da tela nao serao exibidos
              final tr = transactions[index];
              //para personalizar cada elemento da lista eh o ListTile que
              //vai ser usado
              return TransactionItem(
                key: GlobalObjectKey(tr),
                //tem q ser usada a GlobalObjectKey, pq nao funciona a local no .builder
                tr: tr,
                onRemove: onRemove,
              );
            },
          );
  }
}

//ListView(
//  children: transactions.map((tr) {
//    return TransactionItem(
//      key: ValueKey(tr.id),
//      //neste caso de soh ListView, funciona a chamada local ValueKey, 
//      //a preferencia sempre eh de usar a chave local
//      tr: tr,
//      onRemove: onRemove,
//      );
//  }).toList(),
//);