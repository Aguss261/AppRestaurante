<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useCart } from '@/composables/useCart'
import { useOrder } from '@/composables/useOrder'

const router = useRouter()
const { items, total, isEmpty, updateQuantity, removeFromCart, clearCart } = useCart()
const { createOrder, loading: orderLoading, error: orderError } = useOrder()

const customerInfo = ref({
  name: '',
  phone: '',
  notes: ''
})

const paymentMethod = ref('efectivo')
const isSubmitting = ref(false)

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

const goBack = () => {
  router.push('/')
}

const isFormValid = computed(() => {
  return customerInfo.value.name.trim() !== '' && 
         customerInfo.value.phone.trim() !== '' &&
         !isEmpty.value
})

const submitOrder = async () => {
  if (!isFormValid.value) return
  
  isSubmitting.value = true
  
  try {
    const orderId = await createOrder()
    
    if (orderId) {
      // Clear cart after successful order
      clearCart()
      
      // Redirect to success page
      router.push({
        name: 'Success',
        query: { orderId }
      })
    }
  } catch (error) {
    console.error('Error submitting order:', error)
  } finally {
    isSubmitting.value = false
  }
}

// Redirect to menu if cart is empty
const checkCartAndRedirect = () => {
  if (isEmpty.value) {
    router.push('/')
  }
}

// Check on component mount
checkCartAndRedirect()
</script>

<template>
  <div class="checkout-view">
    <div class="checkout-container">
      <!-- Header -->
      <div class="checkout-header">
        <button @click="goBack" class="back-btn">
          <span class="back-icon">←</span>
          Volver al menú
        </button>
        <h1 class="checkout-title">Confirmar Pedido</h1>
        <p class="checkout-subtitle">Revisa tu pedido y completa la información</p>
      </div>

      <!-- Empty cart state -->
      <div v-if="isEmpty" class="empty-cart-state">
        <div class="empty-icon">🛒</div>
        <h3>Tu carrito está vacío</h3>
        <p>Agrega algunos productos antes de continuar</p>
        <button @click="goBack" class="continue-shopping-btn">
          Continuar comprando
        </button>
      </div>

      <!-- Checkout content -->
      <div v-else class="checkout-content">
        <!-- Order summary -->
        <div class="order-summary">
          <h2 class="section-title">
            <span class="section-icon">📋</span>
            Resumen del pedido
          </h2>
          
          <div class="order-items">
            <div 
              v-for="item in items" 
              :key="item.id"
              class="order-item"
            >
              <div class="item-info">
                <h4 class="item-name">{{ item.name }}</h4>
                <div class="item-price">{{ formatPrice(item.price) }} c/u</div>
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
          
          <div class="order-total">
            <div class="total-row">
              <span class="total-label">Total del pedido:</span>
              <span class="total-amount">{{ formatPrice(total) }}</span>
            </div>
          </div>
        </div>

        <!-- Customer information -->
        <div class="customer-info">
          <h2 class="section-title">
            <span class="section-icon">👤</span>
            Información del cliente
          </h2>
          
          <form @submit.prevent="submitOrder" class="customer-form">
            <div class="form-group">
              <label for="name" class="form-label">Nombre completo *</label>
              <input
                id="name"
                v-model="customerInfo.name"
                type="text"
                class="form-input"
                placeholder="Ingresa tu nombre completo"
                required
              />
            </div>
            
            <div class="form-group">
              <label for="phone" class="form-label">Teléfono *</label>
              <input
                id="phone"
                v-model="customerInfo.phone"
                type="tel"
                class="form-input"
                placeholder="Ej: +56 9 1234 5678"
                required
              />
            </div>
            
            <div class="form-group">
              <label for="notes" class="form-label">Notas especiales (opcional)</label>
              <textarea
                id="notes"
                v-model="customerInfo.notes"
                class="form-textarea"
                placeholder="Instrucciones especiales, alergias, etc."
                rows="3"
              ></textarea>
            </div>
            
            <div class="form-group">
              <label class="form-label">Método de pago</label>
              <div class="payment-options">
                <label class="payment-option">
                  <input
                    v-model="paymentMethod"
                    type="radio"
                    value="efectivo"
                    class="payment-radio"
                  />
                  <span class="payment-label">
                    <span class="payment-icon">💵</span>
                    Efectivo
                  </span>
                </label>
                
                <label class="payment-option">
                  <input
                    v-model="paymentMethod"
                    type="radio"
                    value="tarjeta"
                    class="payment-radio"
                  />
                  <span class="payment-label">
                    <span class="payment-icon">💳</span>
                    Tarjeta
                  </span>
                </label>
                
                <label class="payment-option">
                  <input
                    v-model="paymentMethod"
                    type="radio"
                    value="transferencia"
                    class="payment-radio"
                  />
                  <span class="payment-label">
                    <span class="payment-icon">🏦</span>
                    Transferencia
                  </span>
                </label>
              </div>
            </div>
          </form>
        </div>

        <!-- Submit section -->
        <div class="submit-section">
          <div v-if="orderError" class="error-message">
            <span class="error-icon">⚠️</span>
            {{ orderError }}
          </div>
          
          <button
            @click="submitOrder"
            :disabled="!isFormValid || isSubmitting || orderLoading"
            class="submit-btn"
            :class="{ 'loading': isSubmitting || orderLoading }"
          >
            <span v-if="isSubmitting || orderLoading" class="loading-spinner"></span>
            <span v-else class="submit-icon">✅</span>
            <span v-if="isSubmitting || orderLoading">Procesando pedido...</span>
            <span v-else>Confirmar pedido - {{ formatPrice(total) }}</span>
          </button>
          
          <p class="submit-note">
            Al confirmar tu pedido, recibirás una confirmación y el tiempo estimado de preparación.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.checkout-view {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 20px;
}

.checkout-container {
  max-width: 800px;
  margin: 0 auto;
}

.checkout-header {
  text-align: center;
  margin-bottom: 40px;
}

.back-btn {
  background: rgba(255, 255, 255, 0.9);
  border: none;
  border-radius: 12px;
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.back-btn:hover {
  background: white;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.back-icon {
  font-size: 18px;
}

.checkout-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin: 0 0 8px 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.checkout-subtitle {
  font-size: 1.1rem;
  color: #7f8c8d;
  margin: 0;
}

.empty-cart-state {
  text-align: center;
  padding: 60px 20px;
  background: white;
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 20px;
}

.empty-cart-state h3 {
  color: #2c3e50;
  margin: 0 0 12px 0;
  font-size: 1.5rem;
}

.empty-cart-state p {
  color: #7f8c8d;
  margin: 0 0 24px 0;
}

.continue-shopping-btn {
  background: #3498db;
  color: white;
  border: none;
  border-radius: 12px;
  padding: 16px 32px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.continue-shopping-btn:hover {
  background: #2980b9;
  transform: translateY(-1px);
}

.checkout-content {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.order-summary, .customer-info {
  background: white;
  border-radius: 20px;
  padding: 30px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 24px 0;
  display: flex;
  align-items: center;
  gap: 10px;
}

.section-icon {
  font-size: 1.25rem;
}

.order-items {
  margin-bottom: 24px;
}

.order-item {
  display: grid;
  grid-template-columns: 1fr auto auto;
  gap: 20px;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid #f3f4f6;
}

.order-item:last-child {
  border-bottom: none;
}

.item-info {
  min-width: 0;
}

.item-name {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1f2937;
  margin: 0 0 4px 0;
}

.item-price {
  font-size: 0.9rem;
  color: #6b7280;
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
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 16px;
  font-weight: 600;
  transition: all 0.2s ease;
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
  min-width: 32px;
  text-align: center;
  font-weight: 600;
  color: #1f2937;
  padding: 0 8px;
}

.remove-btn {
  background: #fef2f2;
  border: none;
  border-radius: 6px;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s ease;
}

.remove-btn:hover {
  background: #fee2e2;
  transform: scale(1.05);
}

.item-total {
  font-size: 1.1rem;
  font-weight: 700;
  color: #e74c3c;
  text-align: right;
}

.order-total {
  border-top: 2px solid #e5e7eb;
  padding-top: 20px;
}

.total-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.total-label {
  font-size: 1.25rem;
  font-weight: 600;
  color: #374151;
}

.total-amount {
  font-size: 1.75rem;
  font-weight: 700;
  color: #e74c3c;
}

.customer-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label {
  font-weight: 600;
  color: #374151;
  font-size: 0.95rem;
}

.form-input, .form-textarea {
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  padding: 12px 16px;
  font-size: 16px;
  transition: all 0.2s ease;
  background: #f9fafb;
}

.form-input:focus, .form-textarea:focus {
  outline: none;
  border-color: #ff6b35;
  background: white;
  box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
}

.form-textarea {
  resize: vertical;
  min-height: 80px;
}

.payment-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 12px;
}

.payment-option {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.payment-radio {
  display: none;
}

.payment-label {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  background: #f9fafb;
  transition: all 0.2s ease;
  width: 100%;
  font-weight: 500;
}

.payment-radio:checked + .payment-label {
  border-color: #ff6b35;
  background: #fff7f5;
  color: #ff6b35;
}

.payment-icon {
  font-size: 1.2rem;
}

.submit-section {
  background: white;
  border-radius: 20px;
  padding: 30px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.error-message {
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  padding: 12px 16px;
  color: #dc2626;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.error-icon {
  font-size: 1.2rem;
}

.submit-btn {
  width: 100%;
  background: linear-gradient(135deg, #ff6b35 0%, #e55a2b 100%);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 18px 24px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
  margin-bottom: 16px;
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(255, 107, 53, 0.4);
}

.submit-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.submit-btn.loading {
  background: #95a5a6;
}

.loading-spinner {
  width: 20px;
  height: 20px;
  border: 2px solid transparent;
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.submit-icon {
  font-size: 1.2rem;
}

.submit-note {
  color: #6b7280;
  font-size: 0.9rem;
  margin: 0;
  line-height: 1.4;
}

@media (max-width: 768px) {
  .checkout-view {
    padding: 16px;
  }
  
  .checkout-title {
    font-size: 2rem;
  }
  
  .order-summary, .customer-info, .submit-section {
    padding: 20px;
  }
  
  .order-item {
    grid-template-columns: 1fr;
    gap: 12px;
    text-align: center;
  }
  
  .item-controls {
    justify-content: center;
  }
  
  .item-total {
    text-align: center;
    font-size: 1.25rem;
  }
  
  .payment-options {
    grid-template-columns: 1fr;
  }
}
</style>
