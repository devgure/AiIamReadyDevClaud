.PHONY: help install dev prod build test clean deploy

help:
	@echo "Etincel - Production Commands"
	@echo "=============================="
	@echo "make install       - Install all dependencies"
	@echo "make dev           - Start development environment"
	@echo "make prod          - Start production environment"
	@echo "make build         - Build all services"
	@echo "make test          - Run tests"
	@echo "make migrate       - Run database migrations"
	@echo "make seed          - Seed database"
	@echo "make deploy        - Deploy to production"
	@echo "make clean         - Clean containers and volumes"
	@echo "make logs          - View logs"
	@echo "make backup        - Backup database"

install:
	@echo "📦 Installing dependencies..."
	npm install
	cd services/auth-service && npm install && npx prisma generate
	cd services/profile-service && npm install && npx prisma generate
	cd services/match-service && npm install && npx prisma generate
	cd services/chat-service && npm install && npx prisma generate
	cd services/payment-service && npm install && npx prisma generate
	cd services/notification-service && npm install
	cd services/media-service && npm install
	cd services/analytics-service && npm install
	cd services/blockchain-service && npm install
	cd services/ai-service && pip install -r requirements.txt
	cd client/mobile-native && npm install
	cd client/mobile-web && npm install
	cd client/desktop-web && npm install
	cd admin-dashboard && npm install
	@echo "✅ Installation complete!"

dev:
	@echo "🚀 Starting development environment..."
	docker-compose -f docker-compose.dev.yml up --build

prod:
	@echo "🚀 Starting production environment..."
	docker-compose up -d --build

build:
	@echo "🔨 Building all services..."
	docker-compose build

migrate:
	@echo "🗄️  Running database migrations..."
	docker-compose run --rm auth-service npx prisma migrate deploy

seed:
	@echo "🌱 Seeding database..."
	docker-compose run --rm auth-service npm run seed

deploy:
	@echo "🚀 Deploying to production..."
	bash scripts/deploy.sh

clean:
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	docker system prune -af
	@echo "✅ Cleanup complete!"

logs:
	docker-compose logs -f

backup:
	@echo "💾 Backing up database..."
	docker exec etincel-mongodb mongodump --out=/backup/$(date +%Y%m%d)
	@echo "✅ Backup complete!"

restart:
	@echo "🔄 Restarting services..."
	docker-compose restart

status:
	@echo "📊 Service status:"
	docker-compose ps