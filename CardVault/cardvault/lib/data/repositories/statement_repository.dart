import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/utils/api_data.dart';
import '../models/statement.dart';

class StatementRepository {
  StatementRepository(this._client);

  final ApiClient _client;

  Future<List<StatementModel>> getStatements() async {
    final response = await _client.get(ApiEndpoints.statements);
    return ApiData.list(response)
        .whereType<Map>()
        .map((e) => StatementModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<StatementModel> getStatement(String id) async {
    final response = await _client.get(ApiEndpoints.statement(id));
    return StatementModel.fromJson(ApiData.map(response));
  }
}
