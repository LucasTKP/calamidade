import 'dart:convert';

import 'package:core_module/core_module.dart';
import 'package:dashboard/app/features/home/new_requests/data/adapters/new_rquest_adapter.dart';
import 'package:dashboard/app/features/home/new_requests/data/i_new_request_repository.dart';
import 'package:dashboard/app/features/home/new_requests/entities/new_request_entity.dart';

class NewRequestRepositoryImpl implements INewRequestRepository {
  final IRestClient _restClient;

  const NewRequestRepositoryImpl({
    required IRestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<Output<List<NewRequestEntity>>> getNewRequest() async {
    try {
      final response = await _restClient.get(RestClientRequest(path: 'url'));
      if (response.data == null) {
        return const Left(DefaultException(message: 'Requisição inválida'));
      } else {
        final data =
            List<Map<String, dynamic>>.from(jsonDecode(response.data)['data']);
        final newRequestEntities =
            data.map((e) => NewRequestAdapter.fromJson(e)).toList();
        return Right(newRequestEntities);
      }
    } on BaseException catch (err) {
      return Left(DefaultException(message: err.message));
    } catch (e) {
      return Left(DefaultException(message: 'Erro desconhecido:$e'));
    }
  }
}