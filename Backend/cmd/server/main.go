package main

import (
    "log"
    "os"

    "github.com/gin-gonic/gin"
    "github.com/joho/godotenv"

    "restauranteapp/internal/database"
    "restauranteapp/internal/handlers"
)

func main() {
    // Load env vars (ignore in production if using other config)
    _ = godotenv.Load()

    // Initialize database
    if err := database.Connect(); err != nil {
        log.Fatalf("failed to connect database: %v", err)
    }

    // Perform auto-migration
    if err := database.AutoMigrate(); err != nil {
        log.Fatalf("auto migration failed: %v", err)
    }

    r := gin.Default()

    // Register routes
    handlers.RegisterMesaRoutes(r.Group("/mesas"))
    handlers.RegisterProductoRoutes(r.Group("/productos"))
    handlers.RegisterPedidoRoutes(r.Group("/pedidos"))

    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    if err := r.Run(":" + port); err != nil {
        log.Fatalf("Server failed: %v", err)
    }
}
