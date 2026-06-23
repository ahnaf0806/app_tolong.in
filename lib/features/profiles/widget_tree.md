# Widget Tree Profile MVC

## 1. Nama Fitur

Profile

## 2. Tujuan Fitur

Fitur Profile digunakan untuk menampilkan dan mengelola data profil pengguna. Pada fitur ini, user dapat melihat informasi akun, mengganti foto profil, mengedit data profil, dan melihat informasi tambahan sesuai role.

Untuk role Project Owner, halaman profil menampilkan data dasar akun. Untuk role Freelancer, halaman profil juga menampilkan informasi kampus, program studi, semester, skill, portfolio, bio, rating, dan total project.

## 3. Struktur Folder MVC

```text
lib/features/profiles/
├── models/
│   └── profile_model.dart
├── services/
│   └── profile_service.dart
├── controllers/
│   └── profile_controller.dart
├── views/
│   └── profile_page.dart
├── widgets/
│   ├── profile_header_card.dart
│   ├── profile_info_card.dart
│   └── profile_edit_sheet.dart
└── docs/
    └── profile_widget_tree.md
```

## 4. Pembagian MVC

### 4.1 Model

```text
profile_model.dart
```

Model digunakan untuk merepresentasikan data profil user dari database Supabase.

Data yang dikelola:

```text
id
name
email
role
university
studyProgram
semester
photoUrl
bio
skills
portfolioUrl
ratingAverage
totalProjects
verificationStatus
```

Model juga menyediakan helper seperti:

```text
isFreelancer
isProjectOwner
roleLabel
verificationLabel
skillsText
```

### 4.2 View

```text
profile_page.dart
```

View digunakan sebagai halaman utama profil. File ini bertugas menampilkan data profil, loading state, error state, tombol edit profil, tombol logout, dan aksi mengganti foto profil.

### 4.3 Controller

```text
profile_controller.dart
```

Controller digunakan untuk mengatur state halaman profil.

Tugas controller:

```text
loadProfile()
updateProfile()
pickAndUploadPhoto()
mengatur loading
mengatur saving
mengatur upload photo loading
mengatur error message
```

### 4.4 Service

```text
profile_service.dart
```

Service digunakan untuk berkomunikasi langsung dengan Supabase.

Tugas service:

```text
mengambil data profil dari tabel profiles
mengambil data tambahan dari freelancer_profiles
mengupdate data profil
mengupload foto ke Supabase Storage
mengupdate photo_url di tabel profiles
mengambil user yang sedang login
```

## 5. Widget Tree Utama

```text
ProfilePage
└── AnimatedBuilder
    ├── Center
    │   └── CircularProgressIndicator
    │
    ├── Center
    │   └── Text(errorMessage)
    │
    └── RefreshIndicator
        └── ListView
            ├── ProfileHeaderCard
            │   ├── Container
            │   │   └── Column
            │   │       ├── Stack
            │   │       │   ├── CircleAvatar
            │   │       │   │   ├── NetworkImage
            │   │       │   │   └── Icon(person)
            │   │       │   └── Positioned
            │   │       │       └── InkWell
            │   │       │           └── Container
            │   │       │               ├── CircularProgressIndicator
            │   │       │               └── Icon(camera)
            │   │       ├── Text(name)
            │   │       ├── Text(email)
            │   │       ├── Container
            │   │       │   └── Text(roleLabel)
            │   │       └── Row
            │   │           ├── _StatItem(rating)
            │   │           ├── _StatItem(totalProjects)
            │   │           └── _StatItem(verificationLabel)
            │
            ├── Row
            │   ├── ElevatedButton.icon
            │   │   ├── Icon(edit)
            │   │   └── Text(Edit Profil)
            │   └── IconButton
            │       └── Icon(logout)
            │
            └── ProfileInfoCard
                └── Card
                    └── Padding
                        └── Column
                            ├── Text(Informasi Profil)
                            ├── _InfoTile(Nama)
                            ├── _InfoTile(Email)
                            ├── _InfoTile(Role)
                            ├── _InfoTile(Universitas)
                            ├── _InfoTile(Program Studi)
                            ├── _InfoTile(Semester)
                            ├── _InfoTile(Skills)
                            ├── _InfoTile(Portfolio)
                            └── _InfoTile(Bio)
```

## 6. Widget Tree Edit Profil

```text
ProfilePage
└── showModalBottomSheet
    └── AnimatedBuilder
        └── ProfileEditSheet
            └── SafeArea
                └── Padding
                    └── SingleChildScrollView
                        └── Column
                            ├── Container(handle)
                            ├── Text(Edit Profil)
                            ├── TextField(Nama Lengkap)
                            ├── TextField(Universitas)
                            ├── TextField(Program Studi)
                            ├── TextField(Semester)
                            ├── TextField(Skills)
                            ├── TextField(Link Portfolio)
                            ├── TextField(Bio)
                            └── SizedBox
                                └── ElevatedButton
                                    ├── CircularProgressIndicator
                                    └── Text(Simpan Profil)
```

## 7. Widget Tree Header Profil

```text
ProfileHeaderCard
└── Container
    └── Column
        ├── Stack
        │   ├── CircleAvatar
        │   │   ├── NetworkImage(photoUrl)
        │   │   └── Icon(person)
        │   └── Positioned
        │       └── InkWell
        │           └── Container
        │               ├── CircularProgressIndicator
        │               └── Icon(camera_alt)
        ├── Text(profile.name)
        ├── Text(profile.email)
        ├── Container
        │   └── Text(profile.roleLabel)
        └── Row
            ├── _StatItem
            │   ├── Icon(star)
            │   ├── Text(ratingAverage)
            │   └── Text(Rating)
            ├── _StatItem
            │   ├── Icon(work)
            │   ├── Text(totalProjects)
            │   └── Text(Project)
            └── _StatItem
                ├── Icon(verified)
                ├── Text(verificationLabel)
                └── Text(Akun)
```

## 8. Widget Tree Informasi Profil

```text
ProfileInfoCard
└── Card
    └── Padding
        └── Column
            ├── Text(Informasi Profil)
            ├── _InfoTile
            │   ├── Container
            │   │   └── Icon(person)
            │   └── Column
            │       ├── Text(Nama)
            │       └── Text(value)
            ├── _InfoTile
            │   ├── Container
            │   │   └── Icon(email)
            │   └── Column
            │       ├── Text(Email)
            │       └── Text(value)
            ├── _InfoTile
            │   ├── Container
            │   │   └── Icon(badge)
            │   └── Column
            │       ├── Text(Role)
            │       └── Text(value)
            └── _InfoTile tambahan untuk freelancer
                ├── Universitas
                ├── Program Studi
                ├── Semester
                ├── Skills
                ├── Portfolio
                └── Bio
```

## 9. Alur Data MVC

### 9.1 Load Profile

```text
ProfilePage
→ ProfileController.loadProfile()
→ ProfileService.getCurrentProfile()
→ Supabase profiles
→ Supabase freelancer_profiles
→ ProfileModel.fromMaps()
→ ProfilePage menampilkan data
```

Penjelasan:

```text
1. User membuka halaman Profil.
2. ProfilePage memanggil loadProfile().
3. Controller meminta data ke ProfileService.
4. Service mengambil data dari tabel profiles.
5. Jika role adalah freelancer, Service mengambil data tambahan dari freelancer_profiles.
6. Data dibentuk menjadi ProfileModel.
7. View menampilkan data profil.
```

### 9.2 Edit Profile

```text
ProfilePage
→ ProfileEditSheet
→ ProfileController.updateProfile()
→ ProfileService.updateProfile()
→ Supabase profiles
→ Supabase freelancer_profiles
→ ProfileController.load ulang data
→ ProfilePage refresh UI
```

Penjelasan:

```text
1. User menekan tombol Edit Profil.
2. Aplikasi membuka bottom sheet edit profil.
3. User mengubah data.
4. Controller melakukan validasi.
5. Service mengupdate data ke Supabase.
6. Controller mengambil ulang data terbaru.
7. View menampilkan profil yang sudah diperbarui.
```

### 9.3 Upload Foto Profil

```text
ProfilePage
→ ProfileHeaderCard
→ Icon kamera
→ ProfileController.pickAndUploadPhoto()
→ ImagePicker
→ ProfileService.uploadProfilePhoto()
→ Supabase Storage profile-photos
→ Supabase profiles.photo_url
→ ProfilePage refresh UI
```

Penjelasan:

```text
1. User menekan ikon kamera pada foto profil.
2. Aplikasi membuka galeri.
3. User memilih foto.
4. Controller mengirim path foto ke Service.
5. Service mengupload foto ke Supabase Storage.
6. Service mengambil public URL foto.
7. Service mengupdate kolom photo_url pada tabel profiles.
8. Controller mengambil ulang data profil.
9. Foto profil baru tampil di halaman profil.
```

## 10. State yang Digunakan

```text
isLoading
isSaving
isUploadingPhoto
errorMessage
profile
```

Penjelasan state:

```text
isLoading digunakan saat mengambil data profil.
isSaving digunakan saat menyimpan perubahan profil.
isUploadingPhoto digunakan saat mengupload foto profil.
errorMessage digunakan untuk menampilkan pesan error.
profile digunakan untuk menyimpan data profil user yang sedang login.
```

## 11. Kondisi UI

### 11.1 Loading State

```text
Jika isLoading = true dan profile masih null:
tampilkan CircularProgressIndicator.
```

### 11.2 Error State

```text
Jika errorMessage tidak null dan profile masih null:
tampilkan pesan error di tengah halaman.
```

### 11.3 Empty State

```text
Jika profile null:
tampilkan teks "Profil tidak ditemukan."
```

### 11.4 Success State

```text
Jika profile berhasil dimuat:
tampilkan ProfileHeaderCard, tombol Edit Profil, tombol Logout, dan ProfileInfoCard.
```

## 12. Perbedaan Tampilan Berdasarkan Role

### 12.1 Project Owner

Project Owner melihat:

```text
Foto profil
Nama
Email
Role
Tombol edit profil
Tombol logout
Informasi dasar profil
```

### 12.2 Freelancer

Freelancer melihat:

```text
Foto profil
Nama
Email
Role
Rating
Total project
Status akun
Universitas
Program studi
Semester
Skills
Portfolio
Bio
Tombol edit profil
Tombol logout
```

## 13. Database yang Digunakan

### 13.1 profiles

```text
id
name
email
role
university
study_program
semester
photo_url
created_at
```

### 13.2 freelancer_profiles

```text
id
user_id
skills
bio
portfolio_url
rating_average
total_projects
verification_status
created_at
```

### 13.3 Supabase Storage

```text
bucket: profile-photos
```

Storage digunakan untuk menyimpan file foto profil user.

## 14. Kesimpulan

Fitur Profile pada aplikasi Tolongin sudah menerapkan pola MVC. View bertugas menampilkan halaman profil, Controller mengatur state dan validasi, Service menghubungkan aplikasi dengan Supabase, dan Model merepresentasikan data profil.

Dengan fitur ini, user dapat melihat profil, mengedit data diri, dan mengupload foto profil. Untuk freelancer, halaman profil juga menampilkan informasi tambahan seperti skill, bio, portfolio, rating, dan total project.
