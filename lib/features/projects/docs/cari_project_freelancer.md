# Dokumentasi Fitur: Cari Project untuk Freelancer

## 1. Deskripsi

Fitur **Cari Project** memungkinkan pengguna dengan role `freelancer` untuk melihat daftar project yang tersedia (status `open`) di aplikasi Tolongin. Freelancer dapat membuka detail project dan melanjutkan ke fitur Ajukan Proposal.

---

## 2. Struktur File

```
lib/features/projects/
├── models/
│   ├── project_model.dart          ← ditambahkan: fromJson, field categoryName & ownerName
│   └── project_category_model.dart
├── services/
│   └── project_service.dart        ← ditambahkan: getOpenProjects()
├── controllers/
│   ├── project_controller.dart     (existing, untuk Buat Project)
│   └── project_list_controller.dart ← BARU
├── view/
│   └── create_project_page.dart    (existing)
├── views/                           ← BARU (folder)
│   ├── project_list_page.dart      ← BARU
│   └── project_detail_page.dart    ← BARU
└── widgets/
    ├── anti_joki_checkbox.dart     (existing)
    ├── category_dropdown.dart      (existing)
    ├── difficulty_selector.dart    (existing)
    └── project_card.dart           ← BARU
```

---

## 3. Alur MVC

```
ProjectListPage (View)
  └── ProjectListController (Controller)
        └── ProjectService.getOpenProjects() (Service)
              └── Supabase table: projects
                    ├── join: project_categories(name)
                    └── join: profiles(full_name)
```

---

## 4. Query Supabase

```sql
SELECT
  id, owner_id, category_id, title, project_field,
  description, deadline, budget, difficulty,
  attachment_url, status, created_at,
  project_categories(name),
  profiles(full_name)
FROM projects
WHERE status = 'open'
ORDER BY created_at DESC;
```

> **Catatan RLS**: Pastikan policy Supabase mengizinkan authenticated user untuk SELECT dari tabel `projects`.

---

## 5. Navigasi

- **MainShell** membaca role user saat login.
- Jika role = `freelancer` → menu **Project** → `ProjectListPage`
- Jika role = `project_owner` → menu **Buat** → `CreateProjectPage`

---

## 6. State yang Dikelola (`ProjectListController`)

| State | Tipe | Keterangan |
|---|---|---|
| `isLoading` | `bool` | Status loading data |
| `errorMessage` | `String?` | Pesan error jika gagal |
| `projects` | `List<ProjectModel>` | Daftar project open |

---

## 7. Pengembangan Berikutnya

- Halaman **Ajukan Proposal** (`proposal_page.dart`)
- Tombol "Ajukan Proposal" di `ProjectDetailPage` sudah disiapkan sebagai entry point
- Data yang akan dikirim ke tabel `proposals`: `project_id`, `freelancer_id`, `message`, `price`, `estimated_days`, `work_method`
