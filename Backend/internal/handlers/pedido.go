package handlers

import (
    "net/http"
    "strconv"

    "github.com/gin-gonic/gin"
    "restauranteapp/internal/database"
    "restauranteapp/internal/models"
)

// RegisterPedidoRoutes registers endpoints for Pedido and items
func RegisterPedidoRoutes(rg *gin.RouterGroup) {
    rg.GET("/", listPedidos)
    rg.GET("/:id", getPedido)
    rg.POST("/", createPedido)
    rg.PUT("/:id", updatePedidoEstado)
    rg.DELETE("/:id", deletePedido)

    // items under pedido
    rg.POST("/:id/items", addItem)
}

func listPedidos(c *gin.Context) {
    var pedidos []models.Pedido
    if err := database.DB.Preload("Items").Find(&pedidos).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, pedidos)
}

func getPedido(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var pedido models.Pedido
    if err := database.DB.Preload("Items").First(&pedido, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Pedido not found"})
        return
    }
    c.JSON(http.StatusOK, pedido)
}

func createPedido(c *gin.Context) {
    var pedido models.Pedido
    if err := c.ShouldBindJSON(&pedido); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    if pedido.Estado == "" {
        pedido.Estado = models.PedidoNuevo
    }
    if err := database.DB.Create(&pedido).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusCreated, pedido)
}

func updatePedidoEstado(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var pedido models.Pedido
    if err := database.DB.First(&pedido, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Pedido not found"})
        return
    }
    var body struct{ Estado string `json:"estado"` }
    if err := c.ShouldBindJSON(&body); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    pedido.Estado = body.Estado
    if err := database.DB.Save(&pedido).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, pedido)
}

func deletePedido(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    if err := database.DB.Delete(&models.Pedido{}, id).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.Status(http.StatusNoContent)
}

func addItem(c *gin.Context) {
    pid, _ := strconv.Atoi(c.Param("id"))
    var pedido models.Pedido
    if err := database.DB.First(&pedido, pid).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Pedido not found"})
        return
    }
    var item models.PedidoItem
    if err := c.ShouldBindJSON(&item); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    item.PedidoID = uint(pid)
    if err := database.DB.Create(&item).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusCreated, item)
}
