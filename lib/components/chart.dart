import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      //soma dos valores que foi passado em cima do this.recentTransaction
      double totalSum = 0.0;

      //por causa dessa logica abaixo ele soh pega dos ultimos 7 dias
      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
          //vai ser acrescentado ao totalSum
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
      //vai formatar da maneira q vai pegar o dia da semana
      //o [0] eh para pegar a primeira letra
    }).reversed.toList();
    //.reversed (tem q usar o .toList, pq tem q retornar uma lista)
    //vai reverter a ordem impressa
  }

  //get pra calcular o total da semana
  double get _weekTotalValue {
    //fold funciona como metodo reduce de outras linguagens, ele vai ter um
    //acumulador e o elemento atual, vc vai fazendo a operacao que o resultado
    //vai ser usado na proxima operacao
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
    //vai retornar a soma de todos os valores do groupedTransactions e no final
    //vai ter o valor total da semana
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //dividir o espacamento igualmente em torno de todo o conteudo
          children: groupedTransactions.map((tr) {
            return Flexible(
              //o Expanded ja vem como FlexFit.tight como padrao
              fit: FlexFit.tight,
              //nao pode ser const o ChartBar pq eu nao conheco os valores do
              //tr day/value, pq eles sao pegos no runtime
              child: ChartBar(
                label: tr['day'].toString(),
                //nao pode colocar Object em String, entao .toString() pra transformar
                value: (tr['value'] as double),
                //nao pode colocar Object em double, entao envolver a operacao
                //(tr['value'] as double) pra transformar
                percentage: _weekTotalValue == 0
                    ? 0
                    : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
