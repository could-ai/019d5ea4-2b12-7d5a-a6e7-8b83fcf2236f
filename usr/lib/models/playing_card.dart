enum Suit { hearts, diamonds, clubs, spades }

enum Rank { two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace }

class PlayingCard {
  final Suit suit;
  final Rank rank;

  const PlayingCard({required this.suit, required this.rank});

  @override
  String toString() => '${rank.name} of ${suit.name}';

  String get shortName {
    String r;
    switch (rank) {
      case Rank.two: r = '2'; break;
      case Rank.three: r = '3'; break;
      case Rank.four: r = '4'; break;
      case Rank.five: r = '5'; break;
      case Rank.six: r = '6'; break;
      case Rank.seven: r = '7'; break;
      case Rank.eight: r = '8'; break;
      case Rank.nine: r = '9'; break;
      case Rank.ten: r = '10'; break;
      case Rank.jack: r = 'J'; break;
      case Rank.queen: r = 'Q'; break;
      case Rank.king: r = 'K'; break;
      case Rank.ace: r = 'A'; break;
    }
    String s;
    switch (suit) {
      case Suit.hearts: s = '♥'; break;
      case Suit.diamonds: s = '♦'; break;
      case Suit.clubs: s = '♣'; break;
      case Suit.spades: s = '♠'; break;
    }
    return '$r$s';
  }
}
