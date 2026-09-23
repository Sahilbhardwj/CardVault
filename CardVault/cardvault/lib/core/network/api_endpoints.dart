class ApiEndpoints {
  static const health = '/health';

  static const cards = '/api/v1/cards';

  static String card(String id) => '$cards/$id';
  static String blockCard(String id) => '${card(id)}/block';
  static String revealCard(String id) => '${card(id)}/reveal';
  static String controls(String id) => '${card(id)}/controls';
  static String limits(String id) => '${card(id)}/limits';

  static const statements = '/api/v1/statements';
  static String statement(String id) => '$statements/$id';

  static const creditSummary = '/api/v1/credit/summary';

  static const bills = '/api/v1/payments/bills';
  static String bill(String id) => '$bills/$id';
}
