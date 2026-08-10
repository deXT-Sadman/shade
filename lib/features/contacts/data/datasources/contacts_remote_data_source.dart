import '../../../../core/network/api_client.dart';
import '../models/contact_model.dart';

abstract class ContactsRemoteDataSource {
  Future<List<ContactModel>> searchContacts(String query);
}

class ContactsRemoteDataSourceImpl implements ContactsRemoteDataSource {
  final ApiClient apiClient;
  ContactsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ContactModel>> searchContacts(String query) async {
    final response = await apiClient.safeRequest(
      () => apiClient.dio
          .get('/contacts/search', queryParameters: {'query': query}),
    );
    final data = response.data;
    final List<dynamic> list =
        data is Map ? (data['users'] ?? []) : (data as List<dynamic>);
    return list
        .map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
