import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {
  final String? label;
  final double? value;
  final double? percentage;
  //precisou do ? pq nao pode ser null, a nao ser q tenha required na frente

  //para definir um construtor como const, todos os elementos dele precisam
  //ser final (como acima)
  const ChartBar({
    this.label,
    this.value,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    //para ajustar o grafico pra ele tb considerar, nao soh o dispositivo,
    //o componente de q ele esta envolvido (LayoutBuilder)
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            //vai fazer com que o texto, por maior q seja, caiba dentro da coluna
            //tambem mantendo os valores restantes alinhados
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                //nao pode esquecer do ? depois da variavel (value?)
                child: Text('${value?.toStringAsFixed(2)}'),
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(5),
                      //para deixar a parte de cima e de baixo redondinha
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label.toString()),
              ),
            ),
            //precisou colocar o .toString() no label pra chamar a variavel
          ],
        );
      },
    );
  }
}
