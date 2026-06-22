import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controllers/workspace_controller.dart';
import '../models/workspace_model.dart';
import '../widgets/workspace_info_section.dart';
import '../widgets/workspace_status_badge.dart';

class WorkspaceDetailPage extends StatefulWidget {
  final String workspaceId;
  final bool isOwner;

  const WorkspaceDetailPage({
    super.key,
    required this.workspaceId,
    required this.isOwner,
  });

  @override
  State<WorkspaceDetailPage> createState() => _WorkspaceDetailPageState();
}

class _WorkspaceDetailPageState extends State<WorkspaceDetailPage> {
  final WorkspaceController _controller = WorkspaceController();
  final TextEditingController _resultUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWorkspace();
  }

  @override
  void dispose() {
    _controller.dispose();
    _resultUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspace() async {
    await _controller.loadWorkspaceDetail(widget.workspaceId);
  }

  Future<void> _submitResult(WorkspaceModel workspace) async {
    _resultUrlController.text = workspace.resultFileUrl ?? '';

    final resultUrl = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Kirim Hasil Kerja'),
          content: TextField(
            controller: _resultUrlController,
            decoration: const InputDecoration(
              labelText: 'Link hasil kerja',
              hintText: 'Contoh: https://drive.google.com/...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, _resultUrlController.text.trim());
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );

    if (resultUrl == null || resultUrl.isEmpty) {
      return;
    }

    final success = await _controller.submitWorkspace(
      workspaceId: workspace.id!,
      resultFileUrl: resultUrl,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Hasil kerja berhasil dikirim.'
              : _controller.errorMessage ?? 'Gagal mengirim hasil kerja.',
        ),
      ),
    );

    if (success) {
      await _loadWorkspace();
    }
  }

  Future<void> _completeWorkspace(WorkspaceModel workspace) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Selesaikan Project?'),
          content: const Text(
            'Project akan ditandai selesai. Pastikan hasil kerja sudah sesuai.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ya, Selesaikan'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    final success = await _controller.completeWorkspace(workspace.id!);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Project berhasil diselesaikan.'
              : _controller.errorMessage ?? 'Gagal menyelesaikan project.',
        ),
      ),
    );

    if (success) {
      await _loadWorkspace();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Detail Workspace'),
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.inkDeep,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading && _controller.selectedWorkspace == null) {
            return const Center(child: LoadingIndicator());
          }

          if (_controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  _controller.errorMessage!,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.critical,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final workspace = _controller.selectedWorkspace;

          if (workspace == null) {
            return const Center(child: Text('Workspace tidak ditemukan.'));
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      workspace.projectTitle,
                      style: AppTextStyles.headingLg,
                    ),
                  ),
                  WorkspaceStatusBadge(status: workspace.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(workspace.projectDescription, style: AppTextStyles.bodyMd),
              const SizedBox(height: AppSpacing.xl),
              WorkspaceInfoSection(workspace: workspace),
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Fitur chat akan dibuat pada tahap berikutnya.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Buka Chat'),
              ),
              const SizedBox(height: AppSpacing.md),
              if (!widget.isOwner && workspace.isActive)
                ElevatedButton.icon(
                  onPressed: _controller.isLoading
                      ? null
                      : () => _submitResult(workspace),
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Kirim Hasil Kerja'),
                ),
              if (widget.isOwner &&
                  (workspace.isActive || workspace.isSubmitted))
                ElevatedButton.icon(
                  onPressed: _controller.isLoading
                      ? null
                      : () => _completeWorkspace(workspace),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Selesaikan Project'),
                ),
            ],
          );
        },
      ),
    );
  }
}
