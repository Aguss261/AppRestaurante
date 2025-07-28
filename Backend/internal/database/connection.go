package database

import (
    "fmt"
    "os"

    "gorm.io/driver/mysql"
    "gorm.io/gorm"

    "restauranteapp/internal/models"
)

var DB *gorm.DB

// Connect establishes connection to MySQL using individual env vars for configuration
func Connect() error {
    host := os.Getenv("DB_HOST")
    port := os.Getenv("DB_PORT")
    user := os.Getenv("DB_USER")
    pass := os.Getenv("DB_PASSWORD")
    name := os.Getenv("DB_NAME")

    if host == "" || port == "" || user == "" || name == "" {
        return fmt.Errorf("database configuration env vars missing (DB_HOST, DB_PORT, DB_USER, DB_NAME)")
    }

    dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local", 
        user, pass, host, port, name)
    
    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
    if err != nil {
        return err
    }
    DB = db
    return nil
}

// AutoMigrate migrates all models.
func AutoMigrate() error {
    return DB.AutoMigrate(
        &models.Mesa{},
        &models.Producto{},
        &models.Pedido{},
        &models.PedidoItem{},
    )
}