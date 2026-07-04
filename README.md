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
| Database | PostgreSQL |
| Version Control | Git & GitHub |
| Containerization | Docker & Docker Compose |
| CI/CD | GitHub Actions |

---

## Project Structure

```text
MedStock-Monitor/
│
├── backend/
│   ├── src/
│   │   ├── config/
│   │   │   └── db.js               # PostgreSQL connection pool
│   │   ├── controllers/
│   │   │   └── medicineController.js
│   │   ├── middlewares/
│   │   │   └── errorHandler.js
│   │   ├── models/
│   │   │   └── medicineModel.js    # SQL queries
│   │   ├── routes/
│   │   │   └── medicineRoutes.js
│   │   └── services/
│   │       └── medicineService.js
│   ├── migrations/
│   │   └── 001_create_tables.sql   # Schema & seed data
│   ├── app.js
│   ├── server.js
│   ├── Dockerfile
│   └── package.json
├── frontend/
│   ├── index.html
│   ├── style.css
│   └── script.js
├── docker-compose.yml
├── .env.example
├── .github/
│   └── workflows/
│       └── node.js.yml             # CI pipeline
├── .gitignore
├── LICENSE
└── README.md
```

---

## How to Run the Application

### Option 1 — Docker (Recommended)

#### Prerequisites

- Docker
- Docker Compose

#### Steps

```bash
git clone https://github.com/PaulRwagasana/MedStock-Monitor
cd MedStock-Monitor
cp .env.example .env        # fill in your values
docker compose up --build
```

The API will be available at `http://localhost:5000` and PostgreSQL will start automatically alongside it.

> Note: Never commit your `.env` file. It is listed in `.gitignore`.

### Option 2 — Run Locally (Without Docker)

#### Prerequisites

- Node.js (v18 or later)
- PostgreSQL (running locally)

#### Steps

```bash
git clone https://github.com/PaulRwagasana/MedStock-Monitor
cd MedStock-Monitor/backend
cp ../.env.example .env        # then fill in your local DB credentials
npm install
npm start
```

Run the migration to create the database schema:

```bash
psql -U <your_db_user> -d <your_db_name> -f migrations/001_create_tables.sql
```

### Access the Application

| Interface | URL |
|-----------|-----|
| Frontend | http://localhost:5000 |
| All medicines | http://localhost:5000/api/medicines |
| Single medicine | http://localhost:5000/api/medicines/:id |
| Low stock | http://localhost:5000/api/medicines/alerts/low-stock |

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/medicines` | Retrieve all medicines |
| GET | `/api/medicines/search?name=` | Search medicines by name |
| GET | `/api/medicines/alerts/low-stock` | Retrieve all medicines below their threshold |
| GET | `/api/medicines/category/:category` | Retrieve medicines by category |
| GET | `/api/medicines/:id` | Retrieve a single medicine by ID |
| POST | `/api/medicines` | Add a new medicine |
| PUT | `/api/medicines/:id` | Update a medicine record |
| DELETE | `/api/medicines/:id` | Delete a medicine |
| PATCH | `/api/medicines/:id/add-stock` | Increase stock (`{ "amount": 10 }`) |
| PATCH | `/api/medicines/:id/reduce-stock` | Decrease stock (`{ "amount": 5 }`) |

### Example: Add Stock

```bash
curl -X PATCH http://localhost:5000/api/medicines/1/add-stock \
  -H "Content-Type: application/json" \
  -d '{"amount": 10}'
```

### Example: Search

```bash
curl http://localhost:5000/api/medicines/search?name=para
```

---

## Sample Medicine Dataset

The migration seed data includes medicines covering common categories in African community pharmacies:

| Name | Category | Initial Qty | Threshold |
|------|----------|-------------|-----------|
| Paracetamol | Analgesics | 120 | 20 |
| Amoxicillin | Antibiotics | 30 | 15 |
| Coartem | Antimalarials | 8 | 10 |
| Ibuprofen | Analgesics | 65 | 20 |
| Metformin | Diabetes | 40 | 15 |

---

## Formative 1 — Core Inventory System

- View all medicines
- Search a medicine by name
- Update medicine stock quantity
- Identify low-stock medicines
- Frontend dashboard with purple-themed UI
- Data stored in a local JSON file (prototype)

## Formative 2 — CI Pipeline & Containerization

- Migrated data storage from JSON to PostgreSQL
- Dockerized the backend application
- Added Docker Compose for multi-service orchestration (app + database)
- CI pipeline via GitHub Actions — runs on every push and PR to `main`
- Database schema managed via SQL migration file

---

## Environment Variables

Copy `.env.example` to `.env` and fill in your values:

| Variable | Description | Example |
|----------|-------------|---------|
| `DB_HOST` | PostgreSQL host | `localhost` or `db` (Docker) |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DB_USER` | Database user | `postgres` |
| `DB_PASSWORD` | Database password | `yourpassword` |
| `DB_NAME` | Database name | `medstock` |
| `PORT` | API server port | `5000` |

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
| Paul Rwagasana | DevOps Lead — Repository setup, CI, branch protection |
| Mika Rurangwa | Backend Developer — Express API, data storage, endpoints |
| Monica Akoi Dau Ahol | Frontend & Documentation — UI, README, sample data |
| Cletus Ayeebo Abugre | Frontend Styling — UI design, CSS, visual presentation |

---

## Usage

### View All Medicines
Open http://localhost:5000 in your browser to see the full inventory dashboard.

### Search a Medicine
Type a medicine name in the search bar to filter results in real time.

### Add a Medicine
Click the **Add Medicine** button, fill in the form and click **Add Medicine** to save.

### Adjust Stock
Enter a positive number (e.g. `10`) to increase stock or use the reduce option with a positive number (e.g. `5`) to decrease stock, then click **Update**.

### Delete a Medicine
Click the **Delete** button on any row and confirm to remove it from inventory.

### View Low Stock
Click **Low Stock** in the sidebar to see all medicines below their minimum threshold.

---

## Links

- [GitHub Projects Board](https://github.com/users/PaulRwagasana/projects/2)
- [Team Participation Sheet](https://docs.google.com/spreadsheets/d/1blNfxmnIE4V08rAdkrFbVRxIW0tneXAPW_wd-nVdoM0/edit?gid=0#gid=0)

---

## License

This project is licensed under the [MIT License](LICENSE).
