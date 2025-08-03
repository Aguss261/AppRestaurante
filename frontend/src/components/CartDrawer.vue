<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useCart } from '@/composables/useCart'

const { 
  items, 
  total, 
  isEmpty, 
  removeFromCart, 
  updateQuantity 
} = useCart()

const router = useRouter()

const props = defineProps<{
  show: boolean
}>()

const emit = defineEmits(['update:show'])

const closeDrawer = () => {
  emit('update:show', false)
}

const handleCheckout = () => {
  closeDrawer()
  router.push('/checkout')
}

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('es-CL', {
    style: 'currency',
    currency: 'CLP',
    minimumFractionDigits: 0
  }).format(price)
}

const increaseQuantity = (itemId: number) => {
  updateQuantity(itemId, 1)
}

const decreaseQuantity = (itemId: number) => {
  updateQuantity(itemId, -1)
}

const removeItem = (itemId: number) => {
  removeFromCart(itemId)
}
</script>

<template>
  <div 
    v-if="show" 
    class="cart-overlay"
    @click="closeDrawer"
  >
    <div 
      class="cart-drawer"
      @click.stop
    >
      <!-- Header -->
      <div class="cart-header">
        <div class="header-content">
          <h2 class="cart-title">
            <span class="cart-icon">🛒</span>
            Tu Pedido
          </h2>
          <button 
            @click="closeDrawer"
            class="close-button"
          >
            ✕
          </button>
        </div>
        <div v-if="!isEmpty" class="items-count">
          {{ items.length }} {{ items.length === 1 ? 'producto' : 'productos' }}
        </div>
      </div>

      <!-- Cart Content -->
      <div class="cart-content">
        <!-- Empty State -->
        <div v-if="isEmpty" class="empty-cart">
          <div class="empty-icon">🍽️</div>
          <h3>Tu carrito está vacío</h3>
          <p>Agrega algunos productos deliciosos para comenzar</p>
        </div>

        <!-- Cart Items -->
        <div v-else class="cart-items">
          <div 
            v-for="item in items" 
            :key="item.id"
            class="cart-item"
          >
            <div class="item-info">
              <h4 class="item-name">{{ item.name }}</h4>
              <div class="item-price">{{ formatPrice(item.price) }}</div>
            </div>
            
            <div class="item-controls">
              <div class="quantity-controls">
                <button 
                  @click="decreaseQuantity(item.id)"
                  class="quantity-btn decrease"
                  :disabled="item.quantity <= 1"
                >
                  −
                </button>
                <span class="quantity">{{ item.quantity }}</span>
                <button 
                  @click="increaseQuantity(item.id)"
                  class="quantity-btn increase"
                >
                  +
                </button>
              </div>
              
              <button 
                @click="removeItem(item.id)"
                class="remove-btn"
                title="Eliminar producto"
              >
                🗑️
              </button>
            </div>
            
            <div class="item-total">
              {{ formatPrice(item.price * item.quantity) }}
            </div>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div v-if="!isEmpty" class="cart-footer">
        <div class="total-section">
          <div class="total-label">Total:</div>
          <div class="total-amount">{{ formatPrice(total) }}</div>
        </div>
        
        <button 
          @click="handleCheckout"
          class="checkout-btn"
        >
          <span class="checkout-icon">💳</span>
          Confirmar Pedido
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.cart-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
  z-index: 1000;
  display: flex;
  justify-content: flex-end;
  align-items: stretch;
}

.cart-drawer {
  background: white;
  width: 100%;
  max-width: 400px;
  display: flex;
  flex-direction: column;
  box-shadow: -4px 0 20px rgba(0, 0, 0, 0.15);
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
  }
  to {
    transform: translateX(0);
  }
}

.cart-header {
  padding: 24px;
  border-bottom: 1px solid #e5e7eb;
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.cart-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.cart-icon {
  font-size: 1.25rem;
}

.close-button {
  background: #f3f4f6;
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 16px;
  color: #6b7280;
  transition: all 0.2s ease;
}

.close-button:hover {
  background: #e5e7eb;
  color: #374151;
}

.items-count {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
}

.cart-content {
  flex: 1;
  overflow-y: auto;
  padding: 0;
}

.empty-cart {
  text-align: center;
  padding: 60px 24px;
}

.empty-icon {
  font-size: 3rem;
  margin-bottom: 16px;
}

.empty-cart h3 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #374151;
  margin: 0 0 8px 0;
}

.empty-cart p {
  color: #6b7280;
  margin: 0;
  line-height: 1.5;
}

.cart-items {
  padding: 16px 0;
}

.cart-item {
  display: grid;
  grid-template-columns: 1fr auto auto;
  gap: 16px;
  align-items: center;
  padding: 16px 24px;
  border-bottom: 1px solid #f3f4f6;
  transition: background-color 0.2s ease;
}

.cart-item:hover {
  background: #f9fafb;
}

.item-info {
  min-width: 0;
}

.item-name {
  font-size: 1rem;
  font-weight: 600;
  color: #1f2937;
  margin: 0 0 4px 0;
  line-height: 1.3;
}

.item-price {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
}

.item-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.quantity-controls {
  display: flex;
  align-items: center;
  background: #f3f4f6;
  border-radius: 8px;
  padding: 2px;
}

.quantity-btn {
  background: white;
  border: none;
  border-radius: 6px;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.2s ease;
  color: #374151;
}

.quantity-btn:hover:not(:disabled) {
  background: #e5e7eb;
  transform: scale(1.05);
}

.quantity-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.quantity-btn.decrease {
  color: #ef4444;
}

.quantity-btn.increase {
  color: #10b981;
}

.quantity {
  min-width: 24px;
  text-align: center;
  font-weight: 600;
  color: #1f2937;
  font-size: 0.875rem;
}

.remove-btn {
  background: #fef2f2;
  border: none;
  border-radius: 6px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s ease;
}

.remove-btn:hover {
  background: #fee2e2;
  transform: scale(1.05);
}

.item-total {
  font-size: 1rem;
  font-weight: 700;
  color: #e74c3c;
  text-align: right;
}

.cart-footer {
  padding: 24px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.total-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 16px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.total-label {
  font-size: 1.125rem;
  font-weight: 600;
  color: #374151;
}

.total-amount {
  font-size: 1.5rem;
  font-weight: 700;
  color: #e74c3c;
}

.checkout-btn {
  width: 100%;
  background: linear-gradient(135deg, #ff6b35 0%, #e55a2b 100%);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 16px 24px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
}

.checkout-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(255, 107, 53, 0.4);
}

.checkout-btn:active {
  transform: translateY(0);
}

.checkout-icon {
  font-size: 1.125rem;
}

@media (max-width: 480px) {
  .cart-drawer {
    max-width: 100%;
  }
  
  .cart-item {
    grid-template-columns: 1fr;
    gap: 12px;
    text-align: center;
  }
  
  .item-controls {
    justify-content: center;
  }
  
  .item-total {
    text-align: center;
    font-size: 1.125rem;
  }
}
</style>


