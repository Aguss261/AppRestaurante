package handlers

import (
    "net/http"
    "strconv"

    "github.com/gin-gonic/gin"
    "restauranteapp/internal/database"
    "restauranteapp/internal/models"
)

// RegisterMesaRoutes registers Mesa CRUD endpoints under provided group.
func RegisterMesaRoutes(rg *gin.RouterGroup) {
    rg.GET("/", listMesas)
    rg.GET("/:id", getMesa)
    rg.POST("/", createMesa)
    rg.PUT("/:id", updateMesa)
    rg.DELETE("/:id", deleteMesa)
}

func listMesas(c *gin.Context) {
    var mesas []models.Mesa
    if err := database.DB.Find(&mesas).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, mesas)
}

func getMesa(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var mesa models.Mesa
    if err := database.DB.First(&mesa, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Mesa not found"})
        return
    }
    c.JSON(http.StatusOK, mesa)
}

func createMesa(c *gin.Context) {
    var mesa models.Mesa
    if err := c.ShouldBindJSON(&mesa); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    if err := database.DB.Create(&mesa).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusCreated, mesa)
}

func updateMesa(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var mesa models.Mesa
    if err := database.DB.First(&mesa, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Mesa not found"})
        return
    }
    var input models.Mesa
    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    mesa.NumeroMesa = input.NumeroMesa
    mesa.Estado = input.Estado
    if err := database.DB.Save(&mesa).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, mesa)
}

func deleteMesa(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    if err := database.DB.Delete(&models.Mesa{}, id).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.Status(http.StatusNoContent)
}
