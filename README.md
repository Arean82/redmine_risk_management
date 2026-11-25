<div align="center">

# 🛡️ Redmine Risk Management (Enterprise Edition)

[![Version](https://img.shields.io/badge/version-1.0.0-emerald.svg?style=for-the-badge)](https://github.com/Arean82/redmine_risk_management/releases)
[![Redmine Compatibility](https://img.shields.io/badge/Redmine-6.x%20%7C%207.x-0284c7.svg?style=for-the-badge)](https://www.redmine.org/)
[![Ruby Version](https://img.shields.io/badge/Ruby-3.x%20%7C%204.x-dc2626.svg?style=for-the-badge)](https://www.ruby-lang.org/)
[![Rails Version](https://img.shields.io/badge/Rails-7.x%20%7C%208.x-ea580c.svg?style=for-the-badge)](https://rubyonrails.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-f59e0b.svg?style=for-the-badge)](LICENSE)

**An industrial-grade, ISO 31000-aligned Risk Assessment, Scoring, and Mitigation Lifecycle Management Plugin for Redmine.**

*Maintained and modernized by **Arean Narrayan** (<arean@synorastudio.in>)*  
*Forked and modernized from the original project by [Imaginary Cloud](https://github.com/imaginary-cloud/redmine_risk_management).*

</div>

---

## 🌟 Executive Overview

**Redmine Risk Management** bridges the gap between project execution and operational governance. It equips project managers, risk officers, and engineering leads with quantitative/qualitative risk analysis tools, visual heatmaps, dynamic workflows, and issue linkages.

Fully modernized for **Redmine 6.x and 7.0+**, **Rails 7/8**, **Ruby 4.0**, and the **Zeitwerk autoloading engine**.

---

## 🚀 Key Modernization Upgrades (v1.0.0)

| Layer | Legacy Implementation | Enterprise Modernized Implementation |
| :--- | :--- | :--- |
| **Model Inheritance** | `ActiveRecord::Base` | `ApplicationRecord` (Rails 7+ standard) |
| **Positioning Engine** | Obsolete `acts_as_list` gem | Native Redmine `Redmine::Acts::Positioned` (`acts_as_positioned`) |
| **Loader Architecture** | `ActiveSupport::Dependencies` & `require_dependency` | `Rails.configuration.to_prepare` wrapped Zeitwerk-safe patching |
| **Issue Linkage** | 1-to-1 (`issues.risk_id`) | **Many-to-Many (`risk_issues`)** linking multiple issues to multiple risks |
| **Query Engine** | Basic ActiveRecord pagination | **Full Redmine Standard `RiskQuery`** (filters, custom columns, sorting, CSV & PDF export) |
| **Visual Dashboard** | None | **Interactive Risk Dashboard & Heatmap** (`RiskDashboardsController`) |
| **Categories** | None | **Project-Level & Global Risk Categories** with dedicated Project Settings tab |
| **Custom Fields** | None | **`RiskCustomField`** fully integrated into Redmine's custom field engine |
| **Interactive AJAX Relations** | None | **AJAX Issue Linking & Unlinking** inline on Risk show view |
| **Audit & History** | None | **Integrated Redmine Journals** with timestamped comments & change tracking |
| **Activity Provider** | None | **`acts_as_activity_provider`** streaming risk events into Redmine Activity |
| **Context Menus & Bulk Edit** | None | **Right-click context menu & mass update editor** |
| **Reporting & Export** | None | **PDF Reports** (List and Detail) + CSV Export |
| **Ruby Runtime** | Ruby 2.x only | Full support for **Ruby 3.0 through Ruby 4.x** |
| **Redmine Compatibility**| Redmine 4.x / 5.x legacy | Verified on **Redmine 6.x and Redmine 7.0+** |

---

## 🎯 Core Features

### 1. Quantitative & Qualitative Risk Matrix
- Automatically calculates risk **Criticality** on a calibrated $4 \times 4$ probability/impact grid:
  $$\text{Criticality} = \text{Probability (1--4)} \times \text{Impact (1--4)}$$
- Automatically computes standard mitigation rationales:
  - **1 – 4:** `Monitor` *(Low exposure; periodic observation)*
  - **5 – 9:** `Plan Mitigation` *(Medium exposure; mitigation roadmapping required)*
  - **10 – 16:** `Mitigate` *(High exposure; urgent active remediation)*

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

### 2. Visual Risk Dashboard & Heatmap
- Dedicated project dashboard page (`/projects/:project_id/risks_dashboard`).
- Visual $4 \times 4$ heatmap card matrix with real-time risk density distribution.
- Executive KPI cards for Total, Active (Open), and Resolved (Closed) risks.
- Top Critical Risks priority watchlist.
- Category and Mitigation Rationale breakdown.

### 3. Redmine Standard Query System (`RiskQuery`)
- Filter risks dynamically by Status (Open/Closed/Any), Project, Category, Assignee, Author, Probability, Impact, and Criticality.
- Custom column selection, group-by grouping, and multi-criteria sorting.
- One-click **CSV** and **PDF** exports with complete metadata.

### 4. Many-to-Many Issue Linkage & AJAX Relations
- Associate any number of Redmine issues to a risk, and link multiple risks to an issue.
- Interactive inline AJAX form to link or unlink issues directly on the risk details page without page reload.
- Real-time risk severity badges directly on the issue detail header.

### 5. Project-Level Risk Categories
- Organize risks by domain categories (e.g., *Security*, *Infrastructure*, *Operational*, *Legal*).
- Managed directly inside Redmine's **Project Settings → Risk categories** tab or globally in Plugin Configuration.

### 6. Full Journal Audit Trail & Discussion History
- Every update to a risk creates a Redmine journal entry tracking changed fields before and after.
- Team members can add timestamped notes, comments, and discussion threads to risks.

### 7. Risk Custom Fields
- Add custom fields of any standard Redmine format (Text, Date, List, User, Boolean, etc.) to Risks via **Administration → Custom fields → Risks**.

### 8. Interactive Context Menu & Bulk Operations
- Right-click any risk row in the risks list to trigger instant status updates, category reassignments, or deletions.
- Check multiple risks to perform bulk edits and mass updates in one click.

---

## 🛠️ System Requirements

- **Redmine:** `6.x`, `7.0.x`
- **Ruby:** `3.0`, `3.1`, `3.2`, `3.3`, `3.4`, `4.0+`
- **Rails:** `7.0`, `7.1`, `7.2`, `8.0`
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
sudo systemctl restart redmine
# Or touch restart.txt
touch /data/redmine/tmp/restart.txt
```

---

## ⚙️ Administration & Permissions

1. Go to **Administration → Roles and permissions**.
2. Under the **Risks** section, configure the following granular permissions:
   - `View risks`: Access risk lists, details, and dashboard.
   - `Add risks`: Create new project risks.
   - `Edit risks`: Update risks, log journal notes, and link issues.
   - `Delete risks`: Delete individual or bulk risks.
   - `Manage risk categories`: Create and manage project-level risk categories.

---

## 📁 Repository Architecture

```text
redmine_risk_management/
├── init.rb                                         # Plugin registration, Zeitwerk hooks & helper prepends
├── README.md                                       # Comprehensive enterprise documentation
├── LICENSE                                         # MIT License
├── config/
│   ├── routes.rb                                   # RESTful project routes, dashboard, ajax relations, bulk actions
│   └── locales/
│       ├── en.yml                                  # English localization
│       └── ru.yml                                  # Russian localization
├── app/
│   ├── controllers/
│   │   ├── risks_controller.rb                     # Query retrieval, pagination, CRUD, bulk actions, PDF export, preview
│   │   ├── risk_dashboards_controller.rb           # Heatmap matrix & KPI dashboard
│   │   ├── risk_categories_controller.rb           # Project-level category controller
│   │   ├── risk_issues_controller.rb               # AJAX issue linking & unlinking
│   │   ├── risk_context_menus_controller.rb        # Interactive right-click context menu
│   │   └── risk_statuses_controller.rb             # Status management controller
│   ├── models/
│   │   ├── risk.rb                                 # ApplicationRecord entity, scoring, journals, activity provider
│   │   ├── risk_status.rb                          # ApplicationRecord status entity with acts_as_positioned
│   │   ├── risk_category.rb                        # ApplicationRecord category entity with acts_as_positioned
│   │   ├── risk_issue.rb                           # Join model for many-to-many issue-risk relationships
│   │   ├── risk_query.rb                           # Redmine Query engine implementation with filters & columns
│   │   └── risk_custom_field.rb                    # CustomField integration for Risks
│   └── views/
│       ├── issues/                                 # Issue detail & form integration partials
│       ├── projects/settings/                      # Project Settings "Risk categories" tab partial
│       ├── risk_categories/                        # Category creation and edit forms
│       ├── risk_context_menus/                     # Right-click context menu partial
│       ├── risk_dashboards/                        # Heatmap & KPI cards dashboard view
│       ├── risk_issues/                            # AJAX response templates (create.js, destroy.js)
│       ├── risks/                                  # Matrix index, details, relations partial, history, bulk edit
│       └── settings/                               # Plugin global settings partials
├── db/
│   └── migrate/                                    # Database migrations (001–009)
└── lib/
    └── redmine_risk_management/
        ├── hooks/
        │   └── views_issues_hook.rb                # View listener for issue pages
        └── patches/
            ├── issue_patch.rb                      # Issue association patch
            ├── project_patch.rb                    # Project association patch
            └── projects_helper_patch.rb            # ProjectsHelper prepend for project settings tab
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
