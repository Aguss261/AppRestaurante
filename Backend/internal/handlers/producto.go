package handlers

import (
    "net/http"
    "strconv"

    "github.com/gin-gonic/gin"
    "restauranteapp/internal/database"
    "restauranteapp/internal/models"
)

// RegisterProductoRoutes registers CRUD endpoints for Producto.
func RegisterProductoRoutes(rg *gin.RouterGroup) {
    rg.GET("/", listProductos)
    rg.GET("/:id", getProducto)
    rg.POST("/", createProducto)
    rg.PUT("/:id", updateProducto)
    rg.DELETE("/:id", deleteProducto)
}

func listProductos(c *gin.Context) {
    var productos []models.Producto
    if err := database.DB.Find(&productos).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, productos)
}

func getProducto(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var prod models.Producto
    if err := database.DB.First(&prod, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Producto not found"})
        return
    }
    c.JSON(http.StatusOK, prod)
}

func createProducto(c *gin.Context) {
    var prod models.Producto
    if err := c.ShouldBindJSON(&prod); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    if err := database.DB.Create(&prod).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusCreated, prod)
}

func updateProducto(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var prod models.Producto
    if err := database.DB.First(&prod, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Producto not found"})
        return
    }
    var input models.Producto
    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    prod.Nombre = input.Nombre
    prod.Categoria = input.Categoria
    prod.Precio = input.Precio
    if err := database.DB.Save(&prod).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, prod)
}

func deleteProducto(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    if err := database.DB.Delete(&models.Producto{}, id).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.Status(http.StatusNoContent)
}
