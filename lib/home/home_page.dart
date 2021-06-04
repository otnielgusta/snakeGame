import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List startPositions = [50, 70, 90, 110, 130];
  List snakePositions = startPositions;
  static int tamanho = 520;
  static var number = Random();
  int food = number.nextInt(tamanho);
  String state = 'game';
  String direction = 'down';

  int pontuacao = 0;

  void geraAleatorio() {
    food = number.nextInt(tamanho);
  }

  void verificaFood(onde) {
    if (snakePositions.last == food) {
      pontuacao += 1;
      geraAleatorio();
      snakePositions.add(snakePositions.last + onde);
      print(snakePositions);
    }
  }

  void verificaImpacto() {
    var valor = 0;
    for (var item in snakePositions) {
      if (snakePositions.last == item) {
        valor += 1;
      }
      if (valor == 2) {
        state = 'gameover';
        break;
      }
    }
  }

  updatePosition() {
    //down
    if (direction == 'down') {
      if (snakePositions.last > tamanho) {
        state = 'gameover';
      } else {
        snakePositions.add(snakePositions.last + 20);
        snakePositions.removeAt(0);
        verificaFood(20);
      }
    }
    //up
    if (direction == 'up') {
      if (snakePositions.last < 1) {
        state = 'gameover';
      } else {
        snakePositions.add(snakePositions.last - 20);
        snakePositions.removeAt(0);
        verificaFood(-20);
      }
    }

    //right
    if (direction == 'right') {
      if ((snakePositions.last + 1) % 20 == 1) {
        state = 'gameover';
      } else {
        snakePositions.add(snakePositions.last + 1);
        snakePositions.removeAt(0);
        verificaFood(1);
      }
    }

    //left
    if (direction == 'left') {
      if (snakePositions.last % 20 == 0) {
        state = 'gameover';
      } else {
        snakePositions.add(snakePositions.last - 1);
        snakePositions.removeAt(0);
        verificaFood(-1);
      }
    }

    verificaImpacto();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        reset(context);
        setState(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Game Over"),
      content: Text("Pontuação: $pontuacao"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  game(BuildContext context) {
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      if (state == 'gameover') {
        showAlertDialog(context);
        timer.cancel();
      }
      setState(() {
        updatePosition();
      });
    });
  }

  reset(BuildContext context) {
    snakePositions = [];
    print(snakePositions);
    snakePositions = [50, 70, 90, 110, 130];
    print(snakePositions);
    state = 'game';
    direction = 'down';
    print(state);
    setState(() {
      print(state);
    });
    geraAleatorio();

    game(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (direction != 'up' && details.delta.dy > 0) {
            direction = 'down';
          } else if (direction != 'down' && details.delta.dy < 0) {
            direction = 'up';
          }
        },
        onHorizontalDragUpdate: (details) {
          if (direction != 'left' && details.delta.dx > 0) {
            direction = 'right';
          } else if (direction != 'right' && details.delta.dx < 0) {
            direction = 'left';
          }
        },
        child: Container(
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: GridView.builder(
                        itemCount: tamanho,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 20,
                        ),
                        itemBuilder: (BuildContext build, int index) {
                          if (snakePositions.contains(index)) {
                            if (index == snakePositions.last) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                ),
                              );
                            }
                          } else if (index == food) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                              ),
                            );
                          }
                        }),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          game(context);
                        },
                        child: Text("Start"),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
