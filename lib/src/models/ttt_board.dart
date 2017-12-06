class TTTBoard {
  static const List<List<int>> WIN_PATTERNS = const [
    const [0, 1, 2], // row 1
    const [3, 4, 5], // row 2
    const [6, 7, 8], // row 3
    const [0, 3, 6], // col 1
    const [1, 4, 7], // col 2
    const [2, 5, 8], // col 3
    const [0, 4, 8], // diag 1
    const [2, 4, 6]  // diag 2
  ];

  final List<String> board = new List<String>.filled(9, null);

  int _moveCount = 0;

  String getWinner() {
    for (List<int> winPattern in WIN_PATTERNS) {
      String cell1 = board[winPattern[0]];
      String cell2 = board[winPattern[1]];
      String cell3 = board[winPattern[2]];

      // if all three cells match and aren't empty, there's a win
      if (cell1 != null &&
          cell1 == cell2 &&
          cell2 == cell3) {
        return cell1;
      }
    }

    // if we get here, there is no win
    return null;
  }

  String move(int cell, String player) {
    board[cell] = player;
    _moveCount++;
    return getWinner();
  }

  bool isCellEmpty(int index) => board[index] == null;

  bool get isFull => _moveCount >= 9;
  bool get isNotFull => !isFull;

  int get moveCount => _moveCount;

  List<int> get emptyCells {
    List<int> empties = [];

    for (int i = 0; i < board.length; i++) {
      if (board[i] == null) {
        empties.add(i);
      }
    }

    return empties;
  }

  String operator [](int cell) => board[cell];

  @override String toString() {
    String prettify(int cell) => board[cell] ?? " ";

    return """
${prettify(0)} | ${prettify(1)} | ${prettify(2)}
${prettify(3)} | ${prettify(4)} | ${prettify(5)}
${prettify(6)} | ${prettify(7)} | ${prettify(8)}
    """;
  }
}