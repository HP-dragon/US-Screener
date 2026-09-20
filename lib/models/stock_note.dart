class StockNote {
  const StockNote({
    required this.id,
    required this.title,
    required this.ticker,
    required this.content,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String ticker;
  final String content;
  final DateTime updatedAt;

  StockNote copyWith({
    String? title,
    String? ticker,
    String? content,
    DateTime? updatedAt,
  }) {
    return StockNote(
      id: id,
      title: title ?? this.title,
      ticker: ticker ?? this.ticker,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
