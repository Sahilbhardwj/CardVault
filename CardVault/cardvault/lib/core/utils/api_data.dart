class ApiData {
  /// Supports both `{ "data": ... }` and a direct JSON payload.
  static dynamic unwrap(dynamic response) {
    if (response is Map && response.containsKey('data')) {
      return response['data'];
    }
    return response;
  }

  static List<dynamic> list(dynamic response) {
    final data = unwrap(response);
    if (data is List) return data;
    if (data is Map) {
      final candidates = [
        data['items'],
        data['cards'],
        data['statements'],
        data['bills'],
      ];
      for (final value in candidates) {
        if (value is List) return value;
      }
    }
    return const [];
  }

  static Map<String, dynamic> map(dynamic response) {
    final data = unwrap(response);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return const {};
  }
}
