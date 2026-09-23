import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/utils/api_data.dart';
import '../models/bill.dart';

class BillPaymentRepository {
  BillPaymentRepository(this._client);

  final ApiClient _client;

  Future<List<BillModel>> getBills() async {
    final response = await _client.get(ApiEndpoints.bills);
    return ApiData.list(response)
        .whereType<Map>()
        .map((e) => BillModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<BillModel> getBill(String id) async {
    final response = await _client.get(ApiEndpoints.bill(id));
    return BillModel.fromJson(ApiData.map(response));
  }

  Future<BillModel> payBill({
    required String id,
    required num amount,
    required String idempotencyKey,
  }) async {
    final response = await _client.post(
      ApiEndpoints.bill(id),
      data: {
        'amount': amount,
        'idempotency_key': idempotencyKey,
      },
    );
    return BillModel.fromJson(ApiData.map(response));
  }
}
