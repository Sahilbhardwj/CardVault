import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/utils/api_data.dart';
import '../models/card.dart';
import '../models/controls.dart';
import '../models/limits.dart';
import '../models/reveal_card.dart';

class CardRepository {
  CardRepository(this._client);

  final ApiClient _client;

  Future<List<CardModel>> getCards() async {
    final response = await _client.get(ApiEndpoints.cards);
    return ApiData.list(response)
        .whereType<Map>()
        .map((e) => CardModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<CardModel> getCard(String id) async {
    final response = await _client.get(ApiEndpoints.card(id));
    return CardModel.fromJson(ApiData.map(response));
  }

  Future<CardModel> blockCard(String id) async {
    final response = await _client.post(ApiEndpoints.blockCard(id));
    return CardModel.fromJson(ApiData.map(response));
  }

  Future<RevealedCardModel> revealCard(String id) async {
    final response = await _client.post(ApiEndpoints.revealCard(id));
    return RevealedCardModel.fromJson(ApiData.map(response));
  }

  Future<ControlsModel> getControls(String id) async {
    final response = await _client.get(ApiEndpoints.controls(id));
    return ControlsModel.fromJson(ApiData.map(response));
  }

  Future<ControlsModel> updateControls(
    String id,
    ControlsModel controls,
  ) async {
    final response = await _client.patch(
      ApiEndpoints.controls(id),
      data: controls.toJson(),
    );
    return ControlsModel.fromJson(ApiData.map(response));
  }

  Future<LimitsModel> getLimits(String id) async {
    final response = await _client.get(ApiEndpoints.limits(id));
    return LimitsModel.fromJson(ApiData.map(response));
  }

  Future<LimitsModel> updateLimits(
    String id,
    LimitsModel limits,
  ) async {
    final response = await _client.patch(
      ApiEndpoints.limits(id),
      data: limits.toJson(),
    );
    return LimitsModel.fromJson(ApiData.map(response));
  }
}
