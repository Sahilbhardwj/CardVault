import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/utils/api_data.dart';
import '../models/credit_summary.dart';

class CreditRepository {
  CreditRepository(this._client);

  final ApiClient _client;

  Future<CreditSummaryModel> getSummary() async {
    final response = await _client.get(ApiEndpoints.creditSummary);
    return CreditSummaryModel.fromJson(ApiData.map(response));
  }
}
