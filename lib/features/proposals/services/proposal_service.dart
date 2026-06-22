import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/owner_proposal_item.dart';
import '../models/proposal_model.dart';

class ProposalService {
  SupabaseClient get _client => SupabaseService.client;

  String getCurrentUserId() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  Future<bool> hasExistingProposal({
    required String projectId,
    required String freelancerId,
  }) async {
    final response = await _client
        .from('proposals')
        .select('id')
        .eq('project_id', projectId)
        .eq('freelancer_id', freelancerId)
        .maybeSingle();

    return response != null;
  }

  Future<void> createProposal(ProposalModel proposal) async {
    await _client.from('proposals').insert(proposal.toCreateJson());
  }

  Future<List<OwnerProposalItem>> getOwnerProposals() async {
    final ownerId = getCurrentUserId();

    final projectRows = await _client
        .from('projects')
        .select('id, title')
        .eq('owner_id', ownerId);

    final projects = projectRows as List;

    if (projects.isEmpty) {
      return [];
    }

    final projectIds = projects.map((item) => item['id'] as String).toList();

    final projectTitleMap = {
      for (final project in projects)
        project['id'] as String: project['title'] as String,
    };

    final proposalRows = await _client
        .from('proposals')
        .select(
          'id, project_id, freelancer_id, message, price, estimated_time, work_method, status, created_at',
        )
        .inFilter('project_id', projectIds)
        .order('created_at', ascending: false);

    final proposals = proposalRows as List;

    if (proposals.isEmpty) {
      return [];
    }

    final freelancerIds = proposals
        .map((item) => item['freelancer_id'] as String)
        .toSet()
        .toList();

    final profileRows = await _client
        .from('profiles')
        .select('id, name')
        .inFilter('id', freelancerIds);

    final profiles = profileRows as List;

    final freelancerNameMap = {
      for (final profile in profiles)
        profile['id'] as String: profile['name'] as String,
    };

    return proposals.map((proposal) {
      final proposalMap = proposal as Map<String, dynamic>;
      final projectId = proposalMap['project_id'] as String;
      final freelancerId = proposalMap['freelancer_id'] as String;

      return OwnerProposalItem.fromMaps(
        proposal: proposalMap,
        projectTitle: projectTitleMap[projectId] ?? 'Project',
        freelancerName: freelancerNameMap[freelancerId] ?? 'Freelancer',
      );
    }).toList();
  }

  Future<void> acceptOwnerProposal(OwnerProposalItem proposal) async {
    await acceptProposal(
      proposalId: proposal.id,
      projectId: proposal.projectId,
      freelancerId: proposal.freelancerId,
      ownerId: getCurrentUserId(),
    );
  }

  Future<void> acceptProposal({
    required String proposalId,
    required String projectId,
    required String freelancerId,
    required String ownerId,
  }) async {
    final existingWorkspace = await _client
        .from('project_workspaces')
        .select('id')
        .eq('proposal_id', proposalId)
        .maybeSingle();

    await _client
        .from('proposals')
        .update({'status': 'accepted'})
        .eq('id', proposalId);

    await _client
        .from('proposals')
        .update({'status': 'rejected'})
        .eq('project_id', projectId)
        .neq('id', proposalId)
        .eq('status', 'pending');

    await _client
        .from('projects')
        .update({'status': 'in_progress'})
        .eq('id', projectId);

    if (existingWorkspace == null) {
      await _client.from('project_workspaces').insert({
        'project_id': projectId,
        'owner_id': ownerId,
        'freelancer_id': freelancerId,
        'proposal_id': proposalId,
        'status': 'active',
        'started_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> rejectProposal(String proposalId) async {
    await _client
        .from('proposals')
        .update({'status': 'rejected'})
        .eq('id', proposalId);
  }

  Future<List<ProposalModel>> getProposalsByProject(String projectId) async {
    final response = await _client
        .from('proposals')
        .select(
          'id, project_id, freelancer_id, message, price, estimated_time, work_method, status, created_at',
        )
        .eq('project_id', projectId)
        .order('created_at', ascending: false);

    final proposals = response as List;

    if (proposals.isEmpty) {
      return [];
    }

    final freelancerIds = proposals
        .map((item) => item['freelancer_id'] as String)
        .toSet()
        .toList();

    final profileRows = await _client
        .from('profiles')
        .select('id, name')
        .inFilter('id', freelancerIds);

    final profiles = profileRows as List;

    final freelancerNameMap = {
      for (final profile in profiles)
        profile['id'] as String: profile['name'] as String,
    };

    return proposals.map((item) {
      final map = item as Map<String, dynamic>;
      final freelancerId = map['freelancer_id'] as String;

      return ProposalModel.fromJson({
        ...map,
        'freelancer_name': freelancerNameMap[freelancerId] ?? 'Freelancer',
      });
    }).toList();
  }
}
