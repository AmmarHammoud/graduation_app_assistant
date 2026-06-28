import '../../data/datasources/assigned_projects_remote_data_source.dart';
import '../../data/models/work_item_update_details.dart';

class GetWorkItemUpdateDetails {
  final AssignedProjectsDataSource repository;

  GetWorkItemUpdateDetails(this.repository);

  Future<WorkItemUpdateDetailsModel> call(String itemId) async {
    return await repository.fetchWorkItemUpdateDetails(itemId);
  }
}