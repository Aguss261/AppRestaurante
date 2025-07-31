package main

import (
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"

	"restauranteapp/internal/database"
	"restauranteapp/internal/handlers"
)

func main() {
	_ = godotenv.Load()

	if err := database.Connect(); err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	if err := database.AutoMigrate(); err != nil {
		log.Fatalf("auto migration failed: %v", err)
	}

	r := gin.Default()

	
config := cors.Config{
    AllowOrigins:     []string{"http://localhost:5173", "http://localhost:5000","http://localhost:5174"},
    AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
    AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
    ExposeHeaders:    []string{"Content-Length"},
    AllowCredentials: true,
    MaxAge:           12 * time.Hour,
}
r.Use(cors.New(config))

	// Rutas de API
	api := r.Group("/api")
	handlers.RegisterMesaRoutes(api.Group("/mesas"))
	handlers.RegisterProductoRoutes(api.Group("/productos"))
	handlers.RegisterPedidoRoutes(api.Group("/pedidos"))

	// Rutas frontend (sirve la carpeta ./dist de Vue)
	r.Use(staticMiddleware())

	// Redirige cualquier ruta no API al index.html (SPA)
	r.NoRoute(func(c *gin.Context) {
		if strings.HasPrefix(c.Request.URL.Path, "/api") {
			c.JSON(http.StatusNotFound, gin.H{"error": "Ruta no encontrada"})
		} else {
			c.File("./dist/index.html")
		}
	})

	// Puerto
	port := os.Getenv("PORT")
	if port == "" {
		port = "5000"
	}

	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}

// staticMiddleware sirve los archivos de ./dist sin interferir con /api
func staticMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		if strings.HasPrefix(c.Request.URL.Path, "/api") {
			c.Next()
			return
		}
		// Sirve archivos estáticos de la carpeta ./dist
		http.StripPrefix("/", http.FileServer(http.Dir("./dist"))).ServeHTTP(c.Writer, c.Request)
		c.Abort()
	}
}