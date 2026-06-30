import '../../../../core/services/database_service.dart';
import '../models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments({required int workItemId});
  Future<CommentModel> addComment({required int workItemId, required String comment});
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final DatabaseService _databaseService;

  CommentRemoteDataSourceImpl(this._databaseService);

  @override
  Future<List<CommentModel>> getComments({required int workItemId}) async {
    final response = await _databaseService.getData(
      endpoint: 'work-items/$workItemId/comments',
    );

    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? {};
    final commentsList = data['comments'] as List<dynamic>? ?? [];

    return commentsList.map((item) {
      return CommentModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  @override
  Future<CommentModel> addComment({required int workItemId, required String comment}) async {
    final response = await _databaseService.addData(
      endpoint: 'work-items/$workItemId/comments',
      data: {
        'comment': comment,
      },
    );

    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? {};
    final commentMap = data['comment'] as Map<String, dynamic>? ?? {};

    return CommentModel.fromJson(commentMap);
  }
}
