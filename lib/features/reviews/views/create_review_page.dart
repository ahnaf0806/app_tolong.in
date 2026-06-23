import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../workspaces/models/workspace_model.dart';
import '../controllers/review_controller.dart';
import '../widgets/rating_selector.dart';

class CreateReviewPage extends StatefulWidget {
  final WorkspaceModel workspace;

  const CreateReviewPage({super.key, required this.workspace});

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final ReviewController _controller = ReviewController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final success = await _controller.submitReview(
      workspaceId: widget.workspace.id ?? '',
      freelancerId: widget.workspace.freelancerId,
      workspaceStatus: widget.workspace.status,
      comment: _commentController.text,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Review dan rating berhasil dikirim.'
              : _controller.errorMessage ?? 'Gagal mengirim review.',
        ),
      ),
    );

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Beri Review'),
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.inkDeep,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text('Review Freelancer', style: AppTextStyles.headingLg),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Berikan penilaian untuk hasil kerja freelancer pada project ini.',
                style: AppTextStyles.bodyMd,
              ),
              const SizedBox(height: AppSpacing.xl),
              _ProjectSummaryCard(workspace: widget.workspace),
              const SizedBox(height: AppSpacing.xl),
              Text('Rating', style: AppTextStyles.bodyMdBold),
              const SizedBox(height: AppSpacing.xs),
              RatingSelector(
                rating: _controller.selectedRating,
                onChanged: _controller.setRating,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Komentar Review',
                  hintText:
                      'Contoh: Hasil kerja bagus, komunikasi lancar, dan selesai tepat waktu.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _controller.isLoading ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _controller.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Kirim Review'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectSummaryCard extends StatelessWidget {
  final WorkspaceModel workspace;

  const _ProjectSummaryCard({required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceSoft,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workspace.projectTitle, style: AppTextStyles.bodyMdBold),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Freelancer: ${workspace.freelancerName}',
              style: AppTextStyles.bodySm,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('Status: ${workspace.status}', style: AppTextStyles.bodySm),
          ],
        ),
      ),
    );
  }
}
