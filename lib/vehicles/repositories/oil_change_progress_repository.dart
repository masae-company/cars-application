import '../models/oil_change_progress_model.dart';
import '../../core/config/supabase_config.dart';

class OilChangeProgressRepository {
  final _client = SupabaseConfig.client;

  /// Get oil change progress for a specific car
  Future<OilChangeProgressModel?> getByCarId(String carId) async {
    try {
      final response = await _client
          .from('oil_change_progress')
          .select()
          .eq('car_id', carId)
          .maybeSingle();

      if (response == null) return null;

      return OilChangeProgressModel.fromJson(response);
    } catch (e) {
      print('Error fetching oil change progress: $e');
      return null;
    }
  }

  /// Get oil change progress for multiple cars (batch)
  Future<Map<String, OilChangeProgressModel>> getBatchByCarIds(List<String> carIds) async {
    if (carIds.isEmpty) return {};

    try {
      final response = await _client
          .from('oil_change_progress')
          .select()
          .inFilter('car_id', carIds);

      final Map<String, OilChangeProgressModel> progressMap = {};
      
      for (final json in response as List) {
        final progress = OilChangeProgressModel.fromJson(json as Map<String, dynamic>);
        progressMap[progress.carId] = progress;
      }

      return progressMap;
    } catch (e) {
      print('Error fetching batch oil change progress: $e');
      return {};
    }
  }

  /// Create or update oil change progress
  Future<OilChangeProgressModel?> upsert(OilChangeProgressModel progress) async {
    try {
      final data = progress.toJson();
      data.remove('id');
      data.remove('created_at');
      data['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('oil_change_progress')
          .upsert(data)
          .select()
          .single();

      return OilChangeProgressModel.fromJson(response);
    } catch (e) {
      print('Error upserting oil change progress: $e');
      return null;
    }
  }

  /// Update current kilometers for a car
  Future<bool> updateCurrentKilometers(String carId, int kilometers) async {
    try {
      await _client
          .from('oil_change_progress')
          .update({
            'current_kilometers': kilometers,
            'last_updated': DateTime.now().toIso8601String(),
          })
          .eq('car_id', carId);

      return true;
    } catch (e) {
      print('Error updating current kilometers: $e');
      return false;
    }
  }

  /// Record a new oil change
  Future<bool> recordOilChange(
    String carId,
    int currentKilometers,
    int nextOilChangeInterval,
  ) async {
    try {
      await _client
          .from('oil_change_progress')
          .upsert({
            'car_id': carId,
            'current_kilometers': currentKilometers,
            'last_oil_change_kilometers': currentKilometers,
            'next_oil_change_kilometers': currentKilometers + nextOilChangeInterval,
            'last_updated': DateTime.now().toIso8601String(),
          });

      return true;
    } catch (e) {
      print('Error recording oil change: $e');
      return false;
    }
  }
}
