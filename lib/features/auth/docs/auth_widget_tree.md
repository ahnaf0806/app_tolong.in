# Widget Tree - Auth Feature

## AuthGate

AuthGate
└── StreamBuilder<AuthState>
├── LoginPage
│ └── ditampilkan jika user belum login
└── MainShell
└── ditampilkan jika user sudah login

## Login Page

LoginPage
└── Scaffold
└── SafeArea
└── SingleChildScrollView
└── Padding
└── Form
└── Column
├── AuthHeader
├── CustomTextField
│ └── Email Input
├── CustomTextField
│ └── Password Input
├── PrimaryButton
│ └── Login Action
└── SecondaryButton
└── Navigate to Register Page

## Register Page

RegisterPage
└── Scaffold
├── AppBar
└── SafeArea
└── SingleChildScrollView
└── Padding
└── Form
└── Column
├── AuthHeader
├── CustomTextField
│ └── Name Input
├── CustomTextField
│ └── Email Input
├── CustomTextField
│ └── Password Input
├── CustomTextField
│ └── University Input
├── CustomTextField
│ └── Study Program Input
├── CustomTextField
│ └── Semester Input
├── RoleSelector
│ ├── Project Owner Option
│ └── Freelancer Option
└── PrimaryButton
└── Register Action
