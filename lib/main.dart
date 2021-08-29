import 'dart:math';
import 'dart:io';
import 'package:expenses/components/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'components/transaction_form.dart';
import 'models/transaction.dart';
import 'components/transaction_list.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //para nao deixar o app ir a modo paisagem
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        //para dar a cor generica do app
        //accentColor: Colors.amber,
        //cor de realce
        //colorScheme, eh o substituto para essa entrada de primarySwatch e accentColor
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.amber,
        ),
        fontFamily: 'Quicksand',
        //esse textTheme fora do AppBar eh o que pode ser pegado como referencia
        //no transaction_list quando busca referencia de fonte para o "titulo"
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                //headline6 eh o title do appbar
                headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    //where vai agir como filtro
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
      //se a data for depois da data subtraida (7 dias atras no caso) vai ser
      //falsa e nao vai fazer parte da lista parametro para exibir
    }).toList();
  }

  _addTransaction(String name, double value, DateTime date) {
    //*1
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      name: name,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    //fechar o modal, .pop eh pra tirar o primeiro da pilha
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  //abaixo, vai abrir o modal para que o usuario tenha acesso aos textfields
  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
          //nao pode ser null entre (), dai colocando a funcao dentro dele
          //que no caso eh chamar as caracteristicas da transacao *1
        });
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(onPressed: fn, icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    //armazenar o resultado de MediaQuery.of(context) em uma constante
    final mediaQuery = MediaQuery.of(context);
    //para setar apenas qnd estiver em Landscape (paisagem)
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final iconChart =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          //exibir o icone pra essa funcao de forma condicional
          _showChart ? iconList : iconChart,
          () {
            //setState para alternar o valor da variavel showChart
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            //style: TextStyle(fontSize: 20 * MediaQuery.of(context).textScaleFactor),
            //.textScaleFactor eh para considerar se caso o usuario escolha usar
            //uma fonte maior no celular (permitir que os textos crescam de
            //acordo com a selecao do usuario)
            actions: actions,
          ) as PreferredSizeWidget;
    //por causa de uma atualizacao do Dar/Flutter foi preciso colocar
    //um parse de "as PreferredSizeWidget", para resolver o erro

    //para que considere os tamanhos da appbar junto no contexto de tamanho
    //fazendo com que o chart nao se movimente, soh a lista
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //if (isLandscape)
            //if em modo Landscape (paisagem) pra aparecer o botao on/off
            //aparecer fora do appBar
            //  Row(
            //    mainAxisAlignment: MainAxisAlignment.center,
            //    children: <Widget>[
            //      Text('Show Graph'),
            //      Switch.adaptative(
            //.adaptative eh um construtor nomeado que faz o switch se adaptar de acordo com a plataforma
            //        activeColor: mediaQuery.accentColor,
            //        value: _showChart,
            //        onChanged: (value) {
            //          setState(() {
            //            _showChart = value;
            //          });
            //        },
            //      ),
            //    ],
            //  ),
            //poderia usar uma operacao ternaria do _showChart pra mostrar
            //ou um ou outro (_showChart ? Container(chart) : Container(TransactionList))
            if (_showChart || !isLandscape)
              //colocando o "ou" (not)! in landscape / fazendo com que modo retrato apareca
              Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              //colocando o "ou" (not)! in landscape / fazendo com que modo retrato apareca
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            //por causa de uma atualizacao do Dar/Flutter foi preciso colocar
            //um parse de "as ObstructingPreferredSizeWidget", para resolver
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                //operacao ternarias usando o Platform.isIOS pra esconder o botao
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
