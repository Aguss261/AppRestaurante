# Docker Setup para RestauranteApp

Este proyecto incluye una configuración completa de Docker y Docker Compose para ejecutar la aplicación de restaurante con Vue.js frontend y Go backend.

## Estructura de la Aplicación

- **Frontend**: Vue 3 + Vite + TypeScript + Tailwind CSS
- **Backend**: Go + Gin + GORM + MySQL
- **Base de datos**: MySQL 8.0

## Prerequisitos

- Docker
- Docker Compose

## Configuración Rápida

### 1. Construir el Frontend

Antes de ejecutar Docker, necesitas construir el frontend:

```bash
cd frontend
npm install
npm run build
```

### 2. Ejecutar con Docker Compose

Desde la raíz del proyecto:

```bash
# Construir y ejecutar todos los servicios
docker-compose up --build

# Ejecutar en segundo plano
docker-compose up -d --build
```

### 3. Acceder a la Aplicación

- **Frontend**: http://localhost
- **Backend API**: http://localhost:5000/api
- **Base de datos**: localhost:3306

## Servicios

### Frontend (Nginx)
- Puerto: 80
- Sirve la aplicación Vue construida
- Proxy de requests `/api/*` al backend

### Backend (Go)
- Puerto: 5000
- API REST con endpoints para mesas, productos y pedidos
- Conexión automática a MySQL

### Base de Datos (MySQL)
- Puerto: 3306
- Usuario: `restaurante_user`
- Contraseña: `restaurante_password`
- Base de datos: `restaurante_db`

## Comandos Útiles

```bash
# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f database

# Parar todos los servicios
docker-compose down

# Parar y eliminar volúmenes
docker-compose down -v

# Reconstruir un servicio específico
docker-compose build backend
docker-compose up -d backend

# Ejecutar comandos en un contenedor
docker-compose exec backend sh
docker-compose exec database mysql -u restaurante_user -p restaurante_db
```

## Variables de Entorno

El backend utiliza las siguientes variables de entorno (configuradas en docker-compose.yml):

- `PORT=5000`
- `DB_HOST=database`
- `DB_PORT=3306`
- `DB_USER=restaurante_user`
- `DB_PASSWORD=restaurante_password`
- `DB_NAME=restaurante_db`

## Desarrollo

Para desarrollo local sin Docker:

1. **Base de datos**: Usar Docker solo para MySQL
   ```bash
   docker-compose up database
   ```

2. **Backend**: Ejecutar localmente
   ```bash
   cd Backend
   go run cmd/server/main.go
   ```

3. **Frontend**: Ejecutar con Vite
   ```bash
   cd frontend
   npm run dev
   ```

## Solución de Problemas

### Error de conexión a la base de datos
- Verificar que el contenedor de MySQL esté ejecutándose: `docker-compose ps`
- Revisar logs de la base de datos: `docker-compose logs database`

### Frontend no carga
- Verificar que el build del frontend se completó correctamente
- Revisar logs del contenedor frontend: `docker-compose logs frontend`

### API no responde
- Verificar logs del backend: `docker-compose logs backend`
- Verificar que la base de datos esté disponible

### Limpiar todo y empezar de nuevo
```bash
docker-compose down -v
docker system prune -a
docker-compose up --build
```
