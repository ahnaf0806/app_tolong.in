# Dokumentasi Pengerjaan Fitur Workspace MVC

## 1. Nama Fitur

Workspace Project MVC

## 2. Deskripsi Fitur

Fitur Workspace Project merupakan fitur yang digunakan sebagai ruang kerja antara `project_owner` dan `freelancer` setelah sebuah proposal diterima. Workspace dibuat secara otomatis ketika project owner menerima proposal dari freelancer.

Fitur ini digunakan untuk menampilkan daftar workspace yang sedang aktif, detail project yang sedang dikerjakan, status pengerjaan, informasi owner, informasi freelancer, serta ruang awal untuk pengembangan fitur chat, upload hasil kerja, penyelesaian project, dan review.

Workspace menjadi tahap lanjutan setelah alur proposal selesai.

Alur utama:

```text
Project Owner membuat project
→ Freelancer mengajukan proposal
→ Project Owner menerima proposal
→ Workspace otomatis dibuat
→ Owner dan Freelancer masuk ke Workspace
```

## 3. Role Pengguna

Fitur Workspace digunakan oleh dua role utama:

```text
project_owner
freelancer
```

### 3.1 Project Owner

Project owner dapat:

1. Melihat workspace dari project miliknya.
2. Melihat freelancer yang mengerjakan project.
3. Melihat status workspace.
4. Melihat detail project.
5. Mengakses ruang kerja project.
6. Menandai project selesai pada tahap pengembangan berikutnya.

### 3.2 Freelancer

Freelancer dapat:

1. Melihat workspace dari project yang diterima.
2. Melihat informasi project yang sedang dikerjakan.
3. Melihat project owner.
4. Melihat status workspace.
5. Mengakses ruang kerja project.
6. Mengirim hasil kerja pada tahap pengembangan berikutnya.

## 4. Tujuan Fitur

Tujuan fitur Workspace MVC adalah:

1. Menampilkan daftar project yang sudah masuk tahap pengerjaan.
2. Menjadi ruang kerja antara project owner dan freelancer.
3. Menampilkan status pengerjaan project.
4. Menjadi penghubung menuju fitur chat, upload file hasil kerja, penyelesaian project, dan review.
5. Membuat alur aplikasi lebih lengkap setelah proposal diterima.

## 5. Tabel Database yang Digunakan

Tabel utama:

```text
project_workspaces
```

Tabel pendukung:

```text
projects
profiles
proposals
messages
reviews
```

Relasi data:

```text
project_workspaces.project_id → projects.id
project_workspaces.owner_id → profiles.id
project_workspaces.freelancer_id → profiles.id
project_workspaces.proposal_id → proposals.id
messages.workspace_id → project_workspaces.id
reviews.workspace_id → project_workspaces.id
```

## 6. Field Workspace

Field utama pada tabel `project_workspaces`:

```text
id
project_id
owner_id
freelancer_id
proposal_id
status
result_file_url
started_at
completed_at
created_at
```

Status workspace yang digunakan:

```text
active
submitted
completed
cancelled
```

Penjelasan status:

```text
active:
Workspace sudah dibuat dan project sedang dikerjakan.

submitted:
Freelancer sudah mengirim hasil pekerjaan.

completed:
Project owner sudah menyetujui hasil pekerjaan dan project selesai.

cancelled:
Workspace dibatalkan.
```

## 7. Struktur Folder MVC

Struktur folder fitur Workspace berada di dalam:

```text
lib/features/workspaces/
```

Struktur lengkap:

```text
lib/features/workspaces/
├── models/
│   └── workspace_model.dart
├── services/
│   └── workspace_service.dart
├── controllers/
│   └── workspace_controller.dart
├── views/
│   ├── workspace_list_page.dart
│   └── workspace_detail_page.dart
├── widgets/
│   ├── workspace_card.dart
│   ├── workspace_status_badge.dart
│   └── workspace_info_section.dart
└── docs/
    └── workspace_widget_tree.md
```

## 8. Pola MVC yang Digunakan

Fitur ini menggunakan pola MVC dengan alur:

```text
View → Controller → Service → Supabase
```

Penjelasan:

```text
Model:
Membentuk struktur data workspace agar mudah digunakan di Flutter.

View:
Menampilkan daftar workspace dan detail workspace.

Controller:
Mengatur loading, error message, data workspace, dan aksi pada workspace.

Service:
Mengambil dan memperbarui data workspace dari Supabase.

Supabase:
Menyimpan data workspace, project, owner, freelancer, proposal, pesan, dan review.
```

## 9. File yang Dibuat

### 9.1 workspace_model.dart

File `workspace_model.dart` digunakan sebagai model data workspace.

Isi utama model:

```text
WorkspaceModel
├── id
├── projectId
├── ownerId
├── freelancerId
├── proposalId
├── projectTitle
├── projectDescription
├── ownerName
├── freelancerName
├── status
├── resultFileUrl
├── startedAt
├── completedAt
└── createdAt
```

Fungsi utama:

1. Menyimpan data workspace.
2. Mengubah data dari Supabase menjadi object Dart.
3. Memudahkan tampilan data pada halaman list dan detail workspace.
4. Mengecek status workspace, seperti `active`, `submitted`, dan `completed`.

### 9.2 workspace_service.dart

File `workspace_service.dart` digunakan sebagai penghubung antara Flutter dan Supabase.

Method utama:

```text
getCurrentUserId()
getMyWorkspaces()
getWorkspaceDetail()
markWorkspaceSubmitted()
markWorkspaceCompleted()
```

Fungsi setiap method:

```text
getCurrentUserId:
Mengambil ID user yang sedang login.

getMyWorkspaces:
Mengambil daftar workspace milik user yang sedang login, baik sebagai project owner maupun freelancer.

getWorkspaceDetail:
Mengambil detail workspace berdasarkan ID.

markWorkspaceSubmitted:
Mengubah status workspace menjadi submitted setelah freelancer mengirim hasil kerja.

markWorkspaceCompleted:
Mengubah status workspace menjadi completed setelah project owner menyelesaikan project.
```

### 9.3 workspace_controller.dart

File `workspace_controller.dart` digunakan untuk mengatur logika workspace.

Tugas utama:

1. Mengatur loading state.
2. Menyimpan error message.
3. Menyimpan daftar workspace.
4. Mengambil daftar workspace dari Supabase.
5. Mengambil detail workspace.
6. Mengubah status workspace.
7. Refresh data setelah aksi dilakukan.

### 9.4 workspace_list_page.dart

File `workspace_list_page.dart` merupakan halaman daftar workspace.

Isi halaman:

1. Judul halaman "Workspace".
2. Deskripsi singkat.
3. Loading indicator saat data sedang dimuat.
4. Empty state jika belum ada workspace.
5. Daftar workspace menggunakan `WorkspaceCard`.
6. Refresh indicator untuk memuat ulang data.

### 9.5 workspace_detail_page.dart

File `workspace_detail_page.dart` merupakan halaman detail workspace.

Isi halaman:

1. Judul project.
2. Status workspace.
3. Informasi project.
4. Nama project owner.
5. Nama freelancer.
6. Tanggal mulai project.
7. Tanggal selesai jika sudah selesai.
8. Tombol menuju chat.
9. Tombol upload hasil kerja untuk freelancer.
10. Tombol selesaikan project untuk project owner.

### 9.6 workspace_card.dart

File `workspace_card.dart` merupakan widget untuk menampilkan satu workspace pada halaman list.

Isi card:

1. Judul project.
2. Nama lawan kerja.
3. Status workspace.
4. Tanggal mulai.
5. Ringkasan deskripsi.
6. Tombol buka detail.

### 9.7 workspace_status_badge.dart

File `workspace_status_badge.dart` digunakan untuk menampilkan badge status workspace.

Status yang ditampilkan:

```text
active → Aktif
submitted → Menunggu Review
completed → Selesai
cancelled → Dibatalkan
```

### 9.8 workspace_info_section.dart

File `workspace_info_section.dart` digunakan untuk menampilkan bagian informasi detail workspace.

Isi informasi:

1. Project owner.
2. Freelancer.
3. Tanggal mulai.
4. Tanggal selesai.
5. Status project.
6. Link file hasil kerja jika sudah ada.

## 10. Widget Tree Halaman Daftar Workspace

Widget tree halaman `WorkspaceListPage`:

```text
WorkspaceListPage
└── AnimatedBuilder
    └── RefreshIndicator
        └── ListView
            ├── Text("Workspace")
            ├── Text("Pantau project yang sedang dikerjakan.")
            ├── CircularProgressIndicator / Empty State
            └── WorkspaceCard
                ├── Text(workspace.projectTitle)
                ├── WorkspaceStatusBadge(workspace.status)
                ├── Text(workspace.partnerName)
                ├── Text(workspace.projectDescription)
                ├── Text(workspace.startedAt)
                └── ElevatedButton("Buka Workspace")
```

## 11. Widget Tree Halaman Detail Workspace

Widget tree halaman `WorkspaceDetailPage`:

```text
WorkspaceDetailPage
└── Scaffold
    ├── AppBar
    │   └── Text("Detail Workspace")
    └── AnimatedBuilder
        └── ListView
            ├── Text(workspace.projectTitle)
            ├── WorkspaceStatusBadge(workspace.status)
            ├── Text(workspace.projectDescription)
            ├── WorkspaceInfoSection
            │   ├── Text(workspace.ownerName)
            │   ├── Text(workspace.freelancerName)
            │   ├── Text(workspace.startedAt)
            │   └── Text(workspace.completedAt)
            ├── OutlinedButton("Buka Chat")
            ├── ElevatedButton("Kirim Hasil Kerja")
            └── ElevatedButton("Selesaikan Project")
```

## 12. Alur Navigasi

### 12.1 Alur Project Owner

```text
MainShell
→ Aktivitas
→ WorkspaceListPage
→ WorkspaceDetailPage
```

Penjelasan:

1. Project owner login ke aplikasi.
2. Project owner membuka menu Aktivitas.
3. Sistem menampilkan daftar workspace dari project miliknya.
4. Project owner memilih salah satu workspace.
5. Sistem membuka detail workspace.
6. Project owner dapat melihat status pengerjaan.
7. Project owner dapat menyelesaikan project setelah hasil dikirim freelancer.

### 12.2 Alur Freelancer

```text
MainShell
→ Aktivitas
→ WorkspaceListPage
→ WorkspaceDetailPage
```

Penjelasan:

1. Freelancer login ke aplikasi.
2. Freelancer membuka menu Aktivitas.
3. Sistem menampilkan daftar workspace dari project yang diterima.
4. Freelancer memilih salah satu workspace.
5. Sistem membuka detail workspace.
6. Freelancer dapat melihat informasi project.
7. Freelancer dapat mengirim hasil kerja pada tahap pengembangan berikutnya.

## 13. Alur Kerja Fitur

Alur kerja fitur Workspace:

```text
1. Project owner menerima proposal freelancer.
2. Sistem membuat data baru di tabel project_workspaces.
3. Workspace memiliki status awal active.
4. User membuka menu Aktivitas.
5. Sistem mengambil workspace berdasarkan user yang sedang login.
6. Jika user adalah owner, sistem menampilkan workspace dengan owner_id = auth.uid().
7. Jika user adalah freelancer, sistem menampilkan workspace dengan freelancer_id = auth.uid().
8. User memilih workspace.
9. Sistem membuka halaman detail workspace.
10. User melihat informasi project, partner, status, dan tanggal mulai.
11. Freelancer dapat mengirim hasil kerja.
12. Project owner dapat menyelesaikan project.
```

## 14. Validasi

Validasi pada fitur Workspace:

1. User harus login.
2. User hanya dapat melihat workspace yang melibatkan dirinya.
3. Project owner hanya dapat menyelesaikan workspace miliknya.
4. Freelancer hanya dapat mengirim hasil kerja pada workspace miliknya.
5. Workspace yang sudah selesai tidak dapat diubah sembarangan.
6. Workspace yang dibatalkan tidak dapat diproses sebagai project aktif.

## 15. RLS Supabase

Agar fitur aman, tabel `project_workspaces` harus menggunakan Row Level Security.

Aturan utama:

```text
1. User hanya dapat melihat workspace jika dia adalah owner atau freelancer pada workspace tersebut.
2. Project owner dapat membuat workspace ketika menerima proposal.
3. Freelancer dapat memperbarui result_file_url dan status menjadi submitted.
4. Project owner dapat memperbarui status menjadi completed.
5. User lain yang tidak terlibat tidak dapat membaca atau mengubah workspace.
```

Konsep policy select:

```text
SELECT project_workspaces:
owner_id = auth.uid()
OR freelancer_id = auth.uid()
```

Konsep policy update freelancer:

```text
UPDATE project_workspaces:
freelancer_id = auth.uid()
AND status = active
```

Konsep policy update owner:

```text
UPDATE project_workspaces:
owner_id = auth.uid()
AND status IN (active, submitted)
```

## 16. Output yang Diharapkan

Setelah fitur Workspace MVC selesai, output yang diharapkan adalah:

1. Workspace otomatis tampil setelah proposal diterima.
2. Project owner dapat melihat workspace miliknya.
3. Freelancer dapat melihat workspace miliknya.
4. Daftar workspace tampil di menu Aktivitas.
5. Detail workspace dapat dibuka.
6. Status workspace tampil dengan jelas.
7. Workspace dapat menjadi dasar untuk fitur chat, upload hasil kerja, penyelesaian project, dan review.
8. Struktur kode sudah mengikuti MVC.
9. Setiap file tetap rapi dan tidak terlalu panjang.

## 17. Hubungan dengan Fitur Lain

Fitur Workspace terhubung dengan beberapa fitur lain:

```text
Proposal:
Workspace dibuat setelah proposal diterima.

Project:
Workspace menyimpan project yang sedang dikerjakan.

Chat:
Chat menggunakan workspace_id agar percakapan terhubung dengan project tertentu.

Review:
Review diberikan setelah workspace selesai.

Notification:
Notifikasi dapat dikirim saat workspace dibuat, hasil dikirim, atau project selesai.
```

## 18. Catatan Pengembangan Berikutnya

Setelah Workspace MVC selesai, fitur berikutnya yang dapat dikembangkan adalah:

```text
Chat Workspace
Upload Hasil Kerja
Selesaikan Project
Review dan Rating
Notifikasi
```

Prioritas paling dekat setelah workspace:

```text
1. Chat sederhana berdasarkan workspace_id.
2. Upload hasil kerja atau link hasil kerja.
3. Tombol selesaikan project.
4. Review freelancer setelah project selesai.
```

## 19. Kesimpulan

Fitur Workspace MVC merupakan fitur lanjutan setelah proposal diterima oleh project owner. Workspace berfungsi sebagai ruang kerja antara project owner dan freelancer dalam menyelesaikan project.

Dengan fitur ini, alur utama aplikasi Tolongin menjadi semakin lengkap:

```text
Project Owner membuat project
→ Freelancer mencari project
→ Freelancer mengajukan proposal
→ Project Owner menerima proposal
→ Workspace otomatis dibuat
→ Owner dan Freelancer bekerja dalam workspace
→ Project selesai dan dapat diberi review
```
