<div align="center">

# 🛡️ Redmine Risk Management (Enterprise Edition)

[![Version](https://img.shields.io/badge/version-0.5.0-emerald.svg?style=for-the-badge)](https://github.com/Arean82/redmine_risk_management/releases)
[![Redmine Compatibility](https://img.shields.io/badge/Redmine-5.x%20%7C%206.x%20%7C%207.x-0284c7.svg?style=for-the-badge)](https://www.redmine.org/)
[![Ruby Version](https://img.shields.io/badge/Ruby-3.x%20%7C%204.x-dc2626.svg?style=for-the-badge)](https://www.ruby-lang.org/)
[![Rails Version](https://img.shields.io/badge/Rails-6.1%20%7C%207.x%20%7C%208.x-ea580c.svg?style=for-the-badge)](https://rubyonrails.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-f59e0b.svg?style=for-the-badge)](LICENSE)

**An industrial-grade, ISO 31000-aligned Risk Assessment, Scoring, and Mitigation Lifecycle Management Plugin for Redmine.**

*Maintained and modernized by **Arean Narrayan** (<arean@synorastudio.in>)*  
*Forked and modernized from the original project by [Imaginary Cloud](https://github.com/imaginary-cloud/redmine_risk_management).*

</div>

---

## 🌟 Executive Overview

**Redmine Risk Management** bridges the gap between project planning and operational security. It empowers engineering teams, risk officers, and PMO executives to proactively identify uncertainties, assess qualitative probabilities and business impacts, track risk mitigation lifecycles, and directly bind risks to actionable Redmine issues.

Modernized to **Platinum Standard**, this release features complete architectural compatibility with **Redmine 7.0**, **Rails 7/8**, **Ruby 4.0**, and the **Zeitwerk autoloading engine**.

---

## 🚀 Key Modernization Upgrades (v0.5.0)

| Layer | Legacy Implementation | Platinum Modernized Implementation |
| :--- | :--- | :--- |
| **Model Inheritance** | `ActiveRecord::Base` | `ApplicationRecord` (Rails 7+ standard) |
| **Positioning Engine** | Obsolete `acts_as_list` gem | Native Redmine `Redmine::Acts::Positioned` (`acts_as_positioned`) |
| **Loader Architecture** | `ActiveSupport::Dependencies` & `require_dependency` | `Rails.configuration.to_prepare` wrapped Zeitwerk safe patching |
| **Ruby Runtime** | Ruby 2.x only | Full support for **Ruby 3.0 through Ruby 4.x** |
| **Redmine Compatibility**| Redmine 4.x / early 5.x | Fully verified on **Redmine 5.x, 6.x, and Redmine 7.0+** |
| **Database Migrations** | Broke on Redmine 7 due to missing list methods | All 8 database migrations execute flawlessly |

---

## 🎯 Core Features

### 1. Quantitative & Qualitative Risk Matrix
- Automatically calculates risk **Criticality** on a calibrated $4 \times 4$ probability/impact grid:
  $$\text{Criticality} = \text{Probability (1--4)} \times \text{Impact (1--4)}$$
- Automatically computes standard mitigation rationales:
  - **1 – 4:** `Monitor` *(Low exposure; periodic observation)*
  - **5 – 9:** `Plan Mitigation` *(Medium exposure; mitigation roadmapping required)*
  - **10 – 16:** `Mitigate` *(High exposure; urgent active remediation)*

### 2. Seamless Redmine Issue Integration
- Link any issue directly to a recognized project risk.
- View real-time risk severity badges directly on the issue detail header.
- Edit risk association seamlessly from the issue edit pane.

### 3. Customizable Statuses & Workflow Control
- Custom status workflows with open/closed state categories (`open` vs `closed`).
- Color-coded badges for visual triage across project boards.
- Built-in status protection preventing accidental deletion of statuses in active use.

### 4. Role-Based Access Control (RBAC)
Configurable per role within Redmine's native permissions architecture:
- `View risks`
- `Add risks`
- `Edit risks`
- `Delete risks`

---

## 📊 Criticality Matrix & Rationales

```text
                  I M P A C T
          1          2          3          4
     +----------+----------+----------+----------+
   4 |    4     |    8     |    12    |    16    |  High / Critical
P    | (Monitor)| (Plan)   |(Mitigate)|(Mitigate)|
R    +----------+----------+----------+----------+
O  3 |    3     |    6     |    9     |    12    |  Significant
B    | (Monitor)| (Plan)   | (Plan)   |(Mitigate)|
A    +----------+----------+----------+----------+
B  2 |    2     |    4     |    6     |    8     |  Moderate
I    | (Monitor)| (Monitor)| (Plan)   | (Plan)   |
L    +----------+----------+----------+----------+
I  1 |    1     |    2     |    3     |    4     |  Low / Minor
T    | (Monitor)| (Monitor)| (Monitor)| (Monitor)|
Y    +----------+----------+----------+----------+
```

---

## 🛠️ System Requirements

- **Redmine:** `5.0.x`, `5.1.x`, `6.x`, `7.0.x`
- **Ruby:** `3.0`, `3.1`, `3.2`, `3.3`, `3.4`, `4.0+`
- **Rails:** `6.1`, `7.0`, `7.1`, `7.2`, `8.0`
- **Database:** PostgreSQL 12+, MySQL 8+, MariaDB 10.5+, SQLite3

---

## 📦 Installation & Setup

### Step 1: Clone the Repository
Clone into your Redmine `plugins/` directory under the exact name `redmine_risk_management`:

```bash
cd /data/redmine/plugins
git clone https://github.com/Arean82/redmine_risk_management.git
```

### Step 2: Execute Database Migrations

```bash
cd /data/redmine
RAILS_ENV=production bundle exec rake redmine:plugins:migrate NAME=redmine_risk_management
```

### Step 3: Restart Redmine

```bash
# Systemd service
sudo systemctl restart redmine

# Or Phusion Passenger / Puma touch
touch /data/redmine/tmp/restart.txt
```

---

## ⚙️ Administration & Configuration

### 1. Assign Permissions
1. Log in as an Administrator.
2. Go to **Administration → Roles and permissions**.
3. Under the **Risks** section, grant the required permissions (`View risks`, `Add risks`, `Edit risks`, `Delete risks`) to your roles (e.g. *Manager*, *Developer*).

### 2. Enable the Module in Projects
1. Open any Redmine project.
2. Go to **Project Settings → Modules**.
3. Check the **Risks** checkbox and click **Save**.
4. The **Risks** tab will now appear in your project top navigation.

### 3. Customize Risk Statuses
Navigate to **Administration → Plugins → Redmine Risk Management plugin → Configure** to customize status titles, colors, and default open/closed classifications.

---

## 📁 Repository Architecture

```text
redmine_risk_management/
├── init.rb                                         # Plugin registration & Zeitwerk initialization hooks
├── README.md                                       # Comprehensive documentation
├── LICENSE                                         # MIT License
├── config/
│   ├── routes.rb                                   # RESTful project routes
│   └── locales/
│       ├── en.yml                                  # English localization
│       └── ru.yml                                  # Russian localization
├── app/
│   ├── controllers/
│   │   ├── risks_controller.rb                     # CRUD & project scope management
│   │   └── risk_statuses_controller.rb             # Status management controller
│   ├── models/
│   │   ├── risk.rb                                 # ApplicationRecord risk entity with scoring
│   │   └── risk_status.rb                          # ApplicationRecord status entity with acts_as_positioned
│   └── views/
│       ├── issues/                                 # Issue detail & form integration partials
│       ├── risks/                                  # Matrix index, details, and editor views
│       └── settings/                               # Plugin configuration partial
├── db/
│   └── migrate/                                    # Standard Rails database migrations (001–008)
└── lib/
    └── redmine_risk_management/
        ├── hooks/
        │   └── views_issues_hook.rb                # Redmine view listeners for issue views
        └── patches/
            ├── issue_patch.rb                      # Issue association patch
            └── project_patch.rb                    # Project association patch
```

---

## 👤 Author & Support

- **Author & Maintainer:** Arean Narrayan  
- **Email:** [arean@synorastudio.in](mailto:arean@synorastudio.in)  
- **GitHub:** [@Arean82](https://github.com/Arean82)  
- **Issues & Contributions:** [https://github.com/Arean82/redmine_risk_management/issues](https://github.com/Arean82/redmine_risk_management/issues)

---

## 📄 License

This software is released under the **MIT License**.  
Copyright (c) 2010–2018 Imaginary Cloud  
Copyright (c) 2024–2026 Arean Narrayan (<arean@synorastudio.in>)
