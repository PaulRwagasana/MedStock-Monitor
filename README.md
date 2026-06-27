# 💊 MedStock Monitor

> **Empowering local pharmacies with real-time inventory visibility and automated stock alerts.**

---

## Problem Statement

Many community pharmacies across Africa still manage medicine inventory using paper records or disconnected spreadsheets. These manual processes often lead to inaccurate stock records, unexpected medicine shortages, delayed patient care, and inefficient inventory management.

**MedStock Monitor** is a lightweight inventory management system designed to help pharmacies digitally monitor medicine stock levels, update inventory in real time, and identify medicines that require restocking before shortages occur.

---

## Target Users

| User | Description |
|------|-------------|
| Pharmacists & Technicians | Manage daily inventory, update stock after dispensing or receiving supplies |
| Pharmacy Owners & Managers | Monitor stock levels and make informed restocking decisions |
| Small Community Clinics | Track essential medicines available for patient care |

---

## Core Features

1. **Medicine Stock Search** – Search medicines by name or view the full inventory list.
2. **Inventory Adjustment** – Increase or decrease stock quantities after dispensing or receiving supplies.
3. **Low-Stock Alerts** – Instantly identify medicines that have fallen below the minimum threshold.
4. **Medicine Categorization** – Medicines organized by category (Antibiotics, Analgesics, Antimalarials, etc.).
5. **Simple Web Interface** – Clean, browser-based UI — no installation required for end users.

---

## Technology Stack

| Layer | Technology |
|-------|------------|
| Backend | Node.js (Express) |
| Frontend | HTML, CSS, JavaScript |
| Data Storage | JSON (prototype) |
| Version Control | Git & GitHub |
| Future Database | SQLite / MongoDB |
| Deployment | Designed for containerization |

---

## Project Structure

```text
MedStock-Monitor/
│
├── app.js                  # Express server & API routes
├── package.json
├── data/
│   └── medicines.json      # Medicine inventory dataset
├── frontend/
│   ├── index.html          # Main UI page
│   ├── style.css           # Purple-themed stylesheet
│   └── script.js           # API calls & dynamic rendering
├── .github/
│   └── CODEOWNERS
├── .gitignore
├── LICENSE
└── README.md
```

---

## How to Run the Application

### Prerequisites

- Node.js (v18 or later)
- npm

### Installation

```bash
git clone https://github.com/Monica486-bot/MedStock-Monitor
cd MedStock-Monitor
npm install
node app.js
```

### Access the Application

| Interface | URL |
|-----------|-----|
| Frontend  | http://localhost:5000 |
| All medicines | http://localhost:5000/api/medicines |
| Single medicine | http://localhost:5000/api/medicines/:id |
| Low stock | http://localhost:5000/api/medicines/low-stock |

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/medicines` | Retrieve all medicines (supports `?name=` query) |
| GET | `/api/medicines/:id` | Retrieve a single medicine by ID |
| POST | `/api/medicines/:id/adjust` | Adjust stock quantity (`{ "adjustment": 10 }`) |
| GET | `/api/medicines/low-stock` | Retrieve all medicines below their threshold |

### Example: Adjust Stock

```bash
curl -X POST http://localhost:5000/api/medicines/1/adjust \
  -H "Content-Type: application/json" \
  -d '{"adjustment": -10}'
```

---

## Sample Medicine Dataset

The app ships with 8 pre-loaded medicines covering common categories in African community pharmacies:

| Name | Category | Initial Qty | Threshold |
|------|----------|-------------|-----------|
| Amoxicillin | Antibiotic | 120 | 20 |
| Paracetamol | Analgesic | 15 | 30 |
| Artemether | Antimalarial | 60 | 25 |
| Metformin | Antidiabetic | 8 | 20 |
| Omeprazole | Antacid | 75 | 15 |
| Cotrimoxazole | Antibiotic | 10 | 25 |
| Ibuprofen | Analgesic | 90 | 20 |
| ORS Sachets | Rehydration | 5 | 30 |

---

## Initial Functional Scope (Formative 1)

- View all medicines
- Search a medicine by name
- Update medicine stock quantity
- Identify low-stock medicines
- Store inventory data using a local JSON file

Additional features — authentication, reporting, Docker deployment, and cloud infrastructure — will be implemented in later formatives.

---

## Future Microservices Architecture

| Service | Responsibility |
|---------|----------------|
| Inventory Service | Manages medicine records and stock quantities |
| Alert Service | Detects medicines below critical stock levels |
| Reporting Service | Generates inventory reports and usage summaries |

---

## Team Collaboration

- GitHub Projects (Kanban) for task management
- Feature branches for all development work
- Pull Requests required for merging into `main`
- Branch protection enforced on `main`
- Code review required before merge

---

## Team

| Member | Role |
|--------|------|
| Paul | DevOps Lead — Repository setup, CI, branch protection |
| Mika Rurangwa | Backend Developer — Express API, data storage, endpoints |
| Monica Akoi Dau Ahol | Frontend & Documentation — UI, README, sample data |
| Cletus | TBD |

---

## License

This project is licensed under the [MIT License](LICENSE).
