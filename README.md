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

**Redmine Risk Management** delivers end-to-end operational governance and risk response management for engineering organizations and PMOs.

Equipped with ISO 31000 response strategies, numerical scoring matrices, deadlines, heatmaps, and many-to-many issue bindings, it turns static risk tracking into an actionable operational workflow.

Fully modernized for **Redmine 6.x and 7.0+**, **Rails 7/8**, **Ruby 4.0**, and the **Zeitwerk autoloading engine**.

---

## 🚀 Key Modernization Upgrades (v1.0.0)

| Layer | Legacy Implementation | Enterprise v1.0.0 Implementation |
| :--- | :--- | :--- |
| **Model Inheritance** | `ActiveRecord::Base` | `ApplicationRecord` (Rails 7+ standard) |
| **Positioning Engine** | Obsolete `acts_as_list` gem | Native Redmine `Redmine::Acts::Positioned` (`acts_as_positioned`) |
| **Loader Architecture** | `ActiveSupport::Dependencies` & `require_dependency` | `Rails.configuration.to_prepare` wrapped Zeitwerk-safe patching |
| **Response Strategies** | Unstructured text | **Standard ISO 31000 Strategies** (`Mitigate`, `Accept`, `Transfer`, `Eliminate`) |
| **Action Deadlines** | None | **Direct `due_date` field with calendar picker and query filtering** |
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

## 🎯 Core Capabilities Checklist

### 1. Identification & Categorization in Project or Global Risk Register
- Project register at `/projects/:id/risks`.
- Global cross-project register supported via `RiskQuery`.
- Domain categorization via `RiskCategory` (project-specific & global levels).

### 2. Qualitative & Quantitative Analysis for Risk Assessment
- **Quantitative Analysis:** Numerical Probability ($1\text{--}4$) $\times$ Impact ($1\text{--}4$) = Criticality ($1\text{--}16$).
- **Qualitative Analysis:** Calibrated matrix levels (`Monitor`, `Plan Mitigation`, `Mitigate`).

### 3. Customizable Attributes: Probability, Impact, Severity, Response
- **Probability & Impact:** Calibrated scale from 1 to 4.
- **Severity / Criticality:** Computed product score from 1 to 16.
- **Response Strategy:** Standardized ISO classification (`Mitigate`, `Accept`, `Transfer`, `Eliminate`).
- **Treatments & Lessons:** Rich wiki-formatted text areas for mitigation plans and post-event lessons learned.
- **Custom Fields:** Unlimited custom attributes via `RiskCustomField` (text, date, list, user, boolean).

### 4. Visualization in the Risk Matrix, Graphs and Indicators, Export
- Interactive $4 \times 4$ Heatmap matrix on `/projects/:id/risks_dashboard`.
- Real-time risk density counters with severity color badges.
- One-click **PDF** and **CSV** executive reports.

### 5. Tasks, Deadlines, Assignees for Action Steps Management
- **Assignees:** Assign risks directly to users or groups (`assigned_to_id`).
- **Deadlines:** Direct target resolution date (`due_date`) with date picker and query filtering.
- **Action Tasks:** Direct many-to-many binding to actionable Redmine issues (`risk_issues`).

### 6. Easy Risk Reporting and Overview for Management
- Executive KPI Cards (Total Risks, Active/Open Risks, Resolved/Closed Risks).
- Top Critical Risks priority watchlist.
- Category and Strategy distribution summaries.

---

## 📊 Criticality Matrix & Scoring

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
│   └── migrate/                                    # Database migrations (001–010)
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
