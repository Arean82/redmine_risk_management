<div align="center">

# 🛡️ Redmine Risk Management (Enterprise Edition)

[![Version](https://img.shields.io/badge/version-0.0.6-emerald.svg?style=for-the-badge)](https://github.com/Arean82/redmine_risk_management/releases)
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

**Redmine Risk Management** empowers engineering teams, risk officers, and PMO executives to proactively identify uncertainties, assess qualitative probabilities and business impacts, track risk mitigation lifecycles, and directly bind risks to actionable Redmine issues.

Modernized to **Platinum Standard**, this release features complete architectural compatibility with **Redmine 6.x / 7.0+**, **Rails 7/8**, **Ruby 4.0**, and the **Zeitwerk autoloading engine**.

---

## 🚀 Key Modernization Upgrades (v0.0.6)

| Layer | Legacy Implementation | Platinum Modernized Implementation |
| :--- | :--- | :--- |
| **Model Inheritance** | `ActiveRecord::Base` | `ApplicationRecord` (Rails 7+ standard) |
| **Positioning Engine** | Obsolete `acts_as_list` gem | Native Redmine `Redmine::Acts::Positioned` (`acts_as_positioned`) |
| **Loader Architecture** | `ActiveSupport::Dependencies` & `require_dependency` | `Rails.configuration.to_prepare` wrapped Zeitwerk safe patching |
| **Issue Linkage** | 1-to-1 (`issues.risk_id`) | **Many-to-Many (`risk_issues`)** linking multiple issues to multiple risks |
| **Query Engine** | Basic ActiveRecord pagination | **Full Redmine Standard `RiskQuery`** (custom columns, sorting, filters, CSV export) |
| **Categories** | None | **Project-level Risk Categories** (`RiskCategory`) with position ordering |
| **History & Notes** | None | **Integrated Redmine Journals** (`has_many :journals`) with notes and audit trail |
| **Activity Provider** | None | **`acts_as_activity_provider`** rendering risk events in Redmine's Activity stream |
| **Context Menus & Bulk Edit** | None | **Interactive right-click context menu and bulk editor** |
| **Ruby Runtime** | Ruby 2.x only | Full support for **Ruby 3.0 through Ruby 4.x** |
| **Redmine Compatibility**| Redmine 4.x / 5.x legacy | Fully verified on **Redmine 6.x and Redmine 7.0+** |
| **Database Migrations** | Broke on Redmine 7 | All 9 database migrations execute cleanly |

---

## 🎯 Core Features

### 1. Quantitative & Qualitative Risk Matrix
- Automatically calculates risk **Criticality** on a calibrated $4 \times 4$ probability/impact grid:
  $$\text{Criticality} = \text{Probability (1--4)} \times \text{Impact (1--4)}$$
- Automatically computes standard mitigation rationales:
  - **1 – 4:** `Monitor` *(Low exposure; periodic observation)*
  - **5 – 9:** `Plan Mitigation` *(Medium exposure; mitigation roadmapping required)*
  - **10 – 16:** `Mitigate` *(High exposure; urgent active remediation)*

### 2. Many-to-Many Issue Linkage
- Link any issue to multiple risks, and any risk to multiple issues.
- View real-time risk severity badges directly on the issue detail header.
- Add or remove risk associations directly from the issue edit pane or risk details pane.

### 3. Redmine Standard Query System (`RiskQuery`)
- Filter risks dynamically by Status (Open/Closed/Any), Project, Category, Assignee, Author, Probability, Impact, and Criticality.
- Custom column selection, group-by, and multi-criteria sorting.
- One-click **CSV export** with complete metadata.

### 4. Project-Level Risk Categories
- Organize risks by domain categories (e.g., *Security*, *Infrastructure*, *Legal*, *Operational*).
- Customizable directly within Project Settings.

### 5. Full Journal Audit Trail & Notes History
- Every change to a risk generates a Redmine journal entry with before/after attribute tracking.
- Team members can add timestamped notes, comments, and discussion threads to risks.

### 6. Interactive Context Menu & Bulk Operations
- Right-click any risk row in the risks list to trigger instant status changes, category reassignments, or deletions.
- Select multiple risks with checkboxes to perform bulk edits and mass updates in one click.

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
