# Restaurante App - Frontend

Aplicación web progresiva (PWA) para realizar pedidos en restaurantes, desarrollada con Vue 3, TypeScript y Vite.

## Características

- Interfaz móvil primero con diseño responsivo
- Carrito de compras con persistencia local
- Filtrado por categorías
- Notificaciones toast
- Modo offline con caché de catálogo
- Instalable como PWA

## Requisitos

- Node.js 16+ y npm 8+
- Backend REST API ejecutándose (por defecto en `http://localhost:8080`)

## Configuración

1. Clonar el repositorio
2. Instalar dependencias:
   ```bash
   npm install
   ```
3. Configurar variables de entorno (ver `.env.example`):
   ```env
   VITE_API_URL=http://localhost:8080/api/v1
   ```

## Comandos disponibles

- `npm run dev` - Inicia el servidor de desarrollo
- `npm run build` - Compila para producción
- `npm run preview` - Previsualiza la versión de producción

## Estructura del proyecto

```
src/
├── api/           # Configuración de API y servicios
├── assets/        # Recursos estáticos
├── components/    # Componentes reutilizables
├── composables/   # Composición API
├── router/        # Configuración de rutas
├── stores/        # Almacenes Pinia
├── views/         # Vistas de la aplicación
└── main.ts        # Punto de entrada
```

## Stack tecnológico

- Vue 3 (Composition API)
- TypeScript
- Vite
- Pinia (gestión de estado)
- Vue Router
- Tailwind CSS
- Headless UI
- Vite PWA Plugin

## Licencia

MIT
