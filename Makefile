.PHONY: help setup-db backend-setup frontend-setup backend-run frontend-run seed migrate clean install dev stop

help:
	@echo "ReLink Development Commands:"
	@echo "  make setup-db      - Create MySQL database and user"
	@echo "  make backend-setup - Setup backend virtual environment and dependencies"
	@echo "  make frontend-setup- Setup frontend dependencies"
	@echo "  make install       - Setup both backend and frontend"
	@echo "  make seed          - Seed database with sample data"
	@echo "  make migrate       - Run database migrations"
	@echo "  make backend-run   - Start backend server"
	@echo "  make frontend-run  - Start frontend server"
	@echo "  make dev           - Start both backend and frontend (requires 2 terminals)"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make stop          - Stop running servers"

db-setup:
	@echo "Creating database and user..."
	@mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS relink CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; CREATE USER IF NOT EXISTS 'relink'@'localhost' IDENTIFIED BY 'relinkpass'; GRANT ALL PRIVILEGES ON relink.* TO 'relink'@'localhost'; FLUSH PRIVILEGES;"

be-setup:
	@echo "Setting up backend..."
	cd backend && python3 -m venv venv
	cd backend && . venv/bin/activate && pip install -r requirements.txt

fe-setup:
	@echo "Setting up frontend..."
	cd fe && npm install

seed:
	@echo "Seeding database..."
	cd backend && . venv/bin/activate && python seed_db.py

migrate:
	@echo "Running migrations..."
	cd backend && . venv/bin/activate && python migrate_db.py

be-run:
	@echo "Starting backend server..."
	cd backend && . venv/bin/activate && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

fe-run:
	@echo "Starting frontend server..."
	cd fe && npm run dev

clean:
	@echo "Cleaning build artifacts..."
	cd fe && rm -rf .next node_modules/.cache
	cd backend && find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
