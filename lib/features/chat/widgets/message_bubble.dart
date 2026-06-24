import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;

  const MessageBubble({super.key, required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isMine ? AppColors.primary : AppColors.canvas;
    final textColor = isMine ? AppColors.canvas : AppColors.ink;
    final timeColor = isMine
        ? AppColors.canvas.withValues(alpha: 0.72)
        : AppColors.stone;

    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(
          left: isMine ? 56 : 0,
          right: isMine ? 0 : 56,
          bottom: AppSpacing.sm,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          AppSpacing.sm,
          AppSpacing.base,
          AppSpacing.xs,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: AppRadius.circular(AppRadius.xxl),
            topRight: AppRadius.circular(AppRadius.xxl),
            bottomLeft: AppRadius.circular(isMine ? AppRadius.xxl : AppRadius.sm),
            bottomRight: AppRadius.circular(isMine ? AppRadius.sm : AppRadius.xxl),
          ),
          border: isMine ? null : Border.all(color: AppColors.hairlineSoft),
          boxShadow: [
            BoxShadow(
              color: isMine
                  ? AppColors.primary.withValues(alpha: 0.22)
                  : AppColors.inkDeep.withValues(alpha: 0.06),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: AppTextStyles.bodySm.copyWith(
                color: textColor,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: AppTextStyles.caption.copyWith(color: timeColor),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 14,
                    color: timeColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }
}
