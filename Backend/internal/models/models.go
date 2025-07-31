package models

import "time"

// MesaEstado enumeration
const (
    MesaLibre     = "LIBRE"
    MesaOcupada   = "OCUPADA"
    MesaReservada = "RESERVADA"
)

// Categoria enumeration
const (
    CatBebida  = "BEBIDA"
    CatVianda  = "VIANDA"
    CatPostre  = "POSTRE"
    CatExtra   = "EXTRA"
)

// PedidoEstado enumeration
const (
    PedidoNuevo       = "NUEVO"
    PedidoPreparacion = "PREPARACION"
    PedidoEntregado   = "ENTREGADO"
    PedidoCancelado   = "CANCELADO"
)

// Mesa model
type Mesa struct {
    ID         uint      `gorm:"primaryKey" json:"id"`
    NumeroMesa uint      `json:"numero_mesa"`
    Estado     string    `json:"estado"`
    CreatedAt  time.Time `json:"created_at"`
    UpdatedAt  time.Time `json:"updated_at"`
    Pedidos    []Pedido  `json:"pedidos,omitempty"`
}

// Producto model
type Producto struct {
    ID        uint      `gorm:"primaryKey" json:"id"`
    Nombre    string    `json:"nombre"`
    Categoria string    `json:"categoria"`
    Precio    float64   `json:"precio"`
    Foto      string    `json:"foto"`
    Descripcion string    `json:"descripcion"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}

// Pedido model
type Pedido struct {
    ID        uint         `gorm:"primaryKey" json:"id"`
    MesaID    uint         `json:"mesa_id"`
    Estado    string       `json:"estado"`
    CreatedAt time.Time    `json:"created_at"`
    UpdatedAt time.Time    `json:"updated_at"`
    Items     []PedidoItem `json:"items,omitempty"`
}

// PedidoItem model
type PedidoItem struct {
    ID         uint      `gorm:"primaryKey" json:"id"`
    PedidoID   uint      `json:"pedido_id"`
    ProductoID uint      `json:"producto_id"`
    Cantidad   uint      `json:"cantidad"`
    PrecioUnit float64   `json:"precio_unit"`
    CreatedAt  time.Time `json:"created_at"`
    UpdatedAt  time.Time `json:"updated_at"`
}
