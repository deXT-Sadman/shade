import '../../../../core/network/api_client.dart';
import '../models/chat_thread_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatThreadModel>> fetchUserChats();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;
  ChatRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ChatThreadModel>> fetchUserChats() async {
    final response = await apiClient.safeRequest(
      () => apiClient.dio.get('/chats'),
    );
    final data = response.data;
    final List<dynamic> list =
        data is Map ? (data['chats'] ?? []) : (data as List<dynamic>);
    return list
        .map((e) => ChatThreadModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
