# MedStock Monitor

> **Empowering local pharmacies with real-time inventory visibility and automated stock alerts.**

---

# Problem Statement

Many community pharmacies across Africa still manage medicine inventory using paper records or disconnected spreadsheets. These manual processes often lead to inaccurate stock records, unexpected medicine shortages, delayed patient care, and inefficient inventory management.

**MedStock Monitor** is a lightweight inventory management system designed to help pharmacies digitally monitor medicine stock levels, update inventory in real time, and identify medicines that require restocking before shortages occur.

---

# Target Users

* **Pharmacists and Pharmacy Technicians** – Manage daily medicine inventory and update stock after dispensing or receiving supplies.
* **Pharmacy Owners and Managers** – Monitor inventory levels and make informed restocking decisions.
* **Small Community Clinics** – Track essential medicines available for patient care.

---

# Core Features

1. **Medicine Stock Search** – View the current quantity and availability of medicines.
2. **Inventory Adjustment** – Increase or decrease stock quantities after receiving or dispensing medicines.
3. **Low-Stock Alerts** – Identify medicines that fall below a predefined stock threshold.
4. **Medicine Categorization** – Organize medicines by category such as Antibiotics, Analgesics, and Antimalarials.
5. **Simple Web Interface** – A browser-based interface for searching and updating inventory.

---

# Technology Stack

| Layer           | Technology                           |
| --------------- | ------------------------------------ |
| Backend         | Node.js (Express)                    |
| Frontend        | HTML, CSS, JavaScript                |
| Data Storage    | JSON (initial prototype)             |
| Version Control | Git & GitHub                         |
| Future Database | Postgres
| Deployment      | Designed for future containerization |

---

# Project Structure

```text
MedStock-Monitor/
│
├── app.js
├── package.json
├── data/
│   └── medicines.json
├── frontend/
│   ├── index.html
│   ├── style.css
│   └── script.js
├── .github/
│   └── CODEOWNERS
├── .gitignore
├── LICENSE
└── README.md
```

---

# How to Run the Application

## Prerequisites

* Node.js (v18 or later)
* npm

## Installation

```bash
git clone https://github.com/Monica486-bot/MedStock-Monitor
cd MedStock-Monitor
npm install
node app.js
```

## Access the Application

* Frontend: http://localhost:5000
* API: http://localhost:5000/api/medicines

---

# Initial Functional Scope (Formative 1)

The first submission focuses on delivering a working prototype with the following functionality:

* View all medicines
* Search a medicine by name or ID
* Update medicine stock quantity
* Store inventory data using a local JSON file

Additional features such as low-stock notifications, reporting, authentication, Docker deployment, and cloud infrastructure will be implemented in later stages of the project.

---

# Planned API Endpoints

| Method | Endpoint                    | Purpose                            |
| ------ | --------------------------- | ---------------------------------- |
| GET    | `/api/medicines`            | Retrieve all medicines             |
| GET    | `/api/medicines/:id`        | Retrieve one medicine              |
| POST   | `/api/medicines/:id/adjust` | Update stock quantity              |
| GET    | `/api/medicines/low-stock`  | Retrieve medicines below threshold |

---

# Future Microservices Architecture

This project is designed to evolve into a microservices architecture consisting of:

* **Inventory Service** – Manages medicine records and stock quantities.
* **Alert Service** – Detects medicines below critical stock levels.
* **Reporting Service** – Generates inventory reports and usage summaries.

---

# Team Collaboration

The project is developed using GitHub and DevOps collaboration practices.

* GitHub Projects (Kanban) for task management
* Feature branches for development
* Pull Requests for all code changes
* Branch protection on the `main` branch
* Code review before merging
* Equal contribution from all team members

---

# Team

| Member              | Role                                                              |
| ------------------- | ----------------------------------------------------------------- |
| Paul                | DevOps Lead — Repository setup, CI, branch protection            |
| Mika Rurangwa       | Backend Developer — Express API, data storage, endpoints         |
| Monica Akoi Dau Ahol| Frontend & Documentation — UI, README, sample data               |
| Cletus Ayeebo Abugre             | TBD                                                               |

---

# License

This project is licensed under the MIT License.
