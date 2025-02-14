<script setup>
import { ref, onMounted } from 'vue'
import { getApiService } from '../services/getApiService'
import { STATES } from '../constants'
import LoadingSpinner from './LoadingSpinner.vue'

const props = defineProps({
  storeId: {
    type: String,
    required: true,
  },
})

const loading = ref(true)
const storeId = props.storeId
const orders = ref([])
const apiService = getApiService()

async function acceptOrder(order) {
  runAndUpdateView(async () => await apiService.acceptOrder(storeId, order.tableId))
}

async function rejectOrder(order) {
  runAndUpdateView(async () => await apiService.rejectOrder(storeId, order.tableId))
}

async function markOrderAsReady(order) {
  runAndUpdateView(async () => await apiService.markOrderAsReady(storeId, order.tableId))
}

async function deleteOrder(order) {
  runAndUpdateView(async () => await apiService.deleteOrder(storeId, order.tableId))
}

async function runAndUpdateView(action) {
  loading.value = true
  await action()
  await updateView()
}

async function updateView() {
  try {
    orders.value = await apiService.getOrders(storeId)
    loading.value = false
  } catch (error) {
    console.error('Error fetching orders: ', error)
  }
}

onMounted(updateView)
</script>

<template>
  <div>
    <div class="table-container">
      <div v-if="loading" class="spinner-wrapper">
        <LoadingSpinner />
      </div>
      <table v-if="!loading && orders.length > 0" class="orders-table">

        <thead>
          <tr>
            <th>Mesa</th>
            <th>Estado del pedido</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.tableId">
            <td>{{ order.tableId }}</td>
            <td>{{ order.state }}</td>
            <td class="order-buttons">
              <button
                v-if="order.state === STATES.PENDING"
                @click="acceptOrder(order)"
                class="btn btn-success"
              >
                <img
                  src="@/assets/thumbs-up.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
              <button
                v-if="order.state === STATES.PENDING"
                @click="rejectOrder(order)"
                class="btn btn-secondary"
              >
                <img
                  src="@/assets/thumbs-down.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
              <button
                v-if="order.state === STATES.ACCEPTED"
                @click="markOrderAsReady(order)"
                class="btn btn-info"
              >
                <img
                  src="@/assets/delivered.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
              <button
                v-if="order.state === STATES.READY || order.state === STATES.REJECTED"
                @click="deleteOrder(order)"
                class="btn btn-danger"
              >
                <img
                  src="@/assets/trash.svg"
                  alt="icon"
                  style="width: 24px; height: auto"
                />
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      <h3 v-else>No hay pedidos</h3>
    </div>
  </div>
</template>

<style scoped>
.table-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 20px 0;
}

.order-buttons {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  gap: 5px;
}

.orders-table {
  max-width: 1200px;
  border-collapse: collapse;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.orders-table th,
.orders-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.orders-table th {
  background-color: #007bff;
  color: #fff;
  font-weight: 600;
}

.orders-table tr:hover {
  background-color: #f1f1f1;
}

.orders-table tr:last-child td {
  border-bottom: none;
}

.spinner-wrapper {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
</style>
