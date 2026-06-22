# Dokumentasi Pengerjaan Fitur Buat Proposal MVC

## 1. Nama Fitur

Buat Proposal Freelancer

## 2. Deskripsi Fitur

Fitur Buat Proposal Freelancer merupakan fitur yang digunakan oleh pengguna dengan role `freelancer` untuk mengajukan penawaran pada project yang tersedia. Proposal dibuat setelah freelancer membuka halaman detail project dan menekan tombol **Ajukan Proposal**.

Proposal berisi pesan penawaran, harga yang diajukan, estimasi waktu pengerjaan, dan metode kerja. Data proposal kemudian disimpan ke tabel `proposals` di Supabase dan nantinya dapat dilihat oleh `project_owner`.

Fitur ini menjadi penghubung antara fitur **Cari Project untuk Freelancer** dan fitur **Workspace Project**.

## 3. Role Pengguna

Fitur ini hanya digunakan oleh pengguna dengan role: `freelancer`

Role freelancer dapat:
1. Melihat detail project.
2. Mengajukan proposal pada project yang masih berstatus open.
3. Mengisi pesan penawaran.
4. Mengisi harga penawaran.
5. Mengisi estimasi waktu pengerjaan.
6. Mengisi metode kerja.

## 4. Struktur Folder MVC

Struktur folder fitur Proposal berada di dalam:
`lib/features/proposals/`

Struktur lengkap:
```text
lib/features/proposals/
├── models/
│   └── proposal_model.dart
├── services/
│   └── proposal_service.dart
├── controllers/
│   └── proposal_controller.dart
├── views/
│   └── create_proposal_page.dart
├── widgets/
│   └── proposal_form_info_card.dart
└── docs/
    └── proposal_widget_tree.md
```

## 5. Widget Tree Halaman Buat Proposal

Widget tree halaman `CreateProposalPage`:

```text
CreateProposalPage
└── Scaffold
    ├── AppBar
    │   └── Text("Ajukan Proposal")
    └── AnimatedBuilder
        └── ListView
            ├── Text("Ajukan Proposal")
            ├── Text("Tawarkan kemampuan terbaikmu untuk project ini.")
            ├── ProposalFormInfoCard
            │   ├── Text(project.title)
            │   ├── Text(project.projectField)
            │   ├── Text(project.budget)
            │   └── Text(project.deadline)
            ├── TextField(message)
            ├── TextField(price)
            ├── TextField(estimatedTime)
            ├── TextField(workMethod)
            └── ElevatedButton("Kirim Proposal")
```

## 6. Alur Navigasi

Fitur Proposal diakses dari halaman `ProjectDetailPage`.
Alur navigasi:
`ProjectListPage` → `ProjectDetailPage` → `CreateProposalPage`
