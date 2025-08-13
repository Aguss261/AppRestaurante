# Docker Setup para Backend - RestauranteApp

Este documento describe cómo dockerizar únicamente el backend de la aplicación de restaurante (Go + MySQL).

## Estructura

- **Backend**: Go + Gin + GORM
- **Base de datos**: MySQL 8.0
- **Frontend**: Se ejecuta localmente con Vite (desarrollo)

## Prerequisitos

- Docker
- Docker Compose
- Node.js (para el frontend local)

## Configuración

### 1. Construir el Frontend (para servir archivos estáticos)

El backend sirve los archivos estáticos del frontend desde `./dist`, así que necesitas construir el frontend:

```bash
cd frontend
npm install
npm run build
```

### 2. Ejecutar Backend con Docker

Desde la raíz del proyecto:

```bash
# Construir y ejecutar backend + base de datos
docker-compose up --build

# Ejecutar en segundo plano
docker-compose up -d --build
```

### 3. Ejecutar Frontend en Desarrollo

En otra terminal, ejecuta el frontend localmente:

```bash
cd frontend
npm run dev
```

## Acceso a los Servicios

- **Frontend (desarrollo)**: http://localhost:5173
- **Backend API**: http://localhost:5000/api
- **Base de datos**: localhost:3306

## Servicios Docker

### Backend (Go)
- Puerto: 5000
- API REST con endpoints para mesas, productos y pedidos
- Sirve archivos estáticos del frontend en rutas no-API
- Conexión automática a MySQL

### Base de Datos (MySQL)
- Puerto: 3306
- Usuario: `restaurante_user`
- Contraseña: `restaurante_password`
- Base de datos: `restaurante_db`

## Comandos Útiles

```bash
# Ver logs del backend
docker-compose logs -f backend

# Ver logs de la base de datos
docker-compose logs -f database

# Parar servicios
docker-compose down

# Reconstruir solo el backend
docker-compose build backend
docker-compose up -d backend

# Acceder al contenedor del backend
docker-compose exec backend sh

# Acceder a MySQL
docker-compose exec database mysql -u restaurante_user -p restaurante_db
```

## Variables de Entorno

El backend utiliza estas variables (configuradas en docker-compose.yml):

- `PORT=5000`
- `DB_HOST=database`
- `DB_PORT=3306`
- `DB_USER=restaurante_user`
- `DB_PASSWORD=restaurante_password`
- `DB_NAME=restaurante_db`

## Flujo de Desarrollo

1. **Iniciar servicios Docker** (backend + database):
   ```bash
   docker-compose up -d
   ```

2. **Desarrollar frontend localmente**:
   ```bash
   cd frontend
   npm run dev
   ```

3. **El frontend local** (puerto 5173) se conectará automáticamente al backend dockerizado (puerto 5000) gracias a la configuración del proxy en `vite.config.ts`.

## Solución de Problemas

### Backend no se conecta a la base de datos
```bash
# Verificar que MySQL esté ejecutándose
docker-compose ps
docker-compose logs database
```

### Frontend no puede conectarse al backend
- Verificar que el backend esté en puerto 5000: `docker-compose ps`
- Verificar configuración del proxy en `vite.config.ts`

### Limpiar y reiniciar
```bash
docker-compose down -v
docker-compose up --build
```
