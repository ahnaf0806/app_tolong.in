import 'package:flutter/material.dart';

import '../../projects/models/project_model.dart';
import '../controllers/proposal_controller.dart';
import '../widgets/proposal_form_info_card.dart';

class CreateProposalPage extends StatefulWidget {
  final ProjectModel project;

  const CreateProposalPage({super.key, required this.project});

  @override
  State<CreateProposalPage> createState() => _CreateProposalPageState();
}

class _CreateProposalPageState extends State<CreateProposalPage> {
  final ProposalController _controller = ProposalController();

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _estimatedTimeController =
      TextEditingController();
  final TextEditingController _workMethodController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    _priceController.dispose();
    _estimatedTimeController.dispose();
    _workMethodController.dispose();
    super.dispose();
  }

  Future<void> _submitProposal() async {
    final success = await _controller.createProposal(
      projectId: widget.project.id ?? '',
      projectStatus: widget.project.status,
      message: _messageController.text,
      priceText: _priceController.text,
      estimatedTime: _estimatedTimeController.text,
      workMethod: _workMethodController.text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proposal berhasil dikirim.')),
      );

      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_controller.errorMessage ?? 'Proposal gagal dikirim.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Proposal')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Ajukan Proposal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Tawarkan kemampuan terbaikmu untuk project ini.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              ProposalFormInfoCard(project: widget.project),
              const SizedBox(height: 20),
              TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Pesan Proposal',
                  hintText:
                      'Jelaskan kemampuanmu, pengalaman, dan cara kamu menyelesaikan project ini.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Penawaran',
                  hintText: 'Contoh: 150000',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _estimatedTimeController,
                decoration: const InputDecoration(
                  labelText: 'Estimasi Waktu',
                  hintText: 'Contoh: 3 hari',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _workMethodController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Metode Kerja',
                  hintText:
                      'Contoh: Saya akan membuat draft awal, revisi, lalu finalisasi.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _controller.isLoading ? null : _submitProposal,
                  child: _controller.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kirim Proposal'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
