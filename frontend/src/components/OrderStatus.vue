<script setup>
import { computed } from 'vue'

import { STATES_USER_MESSAGES } from '../constants'

const props = defineProps({
  order: {
    type: Object,
    required: true,
  },
})

const chooseStateColor = computed(() => {
  switch (props.order.state) {
    case 'REJECTED':
      return 'danger'
    case 'ACCEPTED':
      return 'info'
    case 'READY':
      return 'success'
    default:
      return 'primary'
  }
})
</script>

<template>
  <main>
    <div class="order-status">
      <h1>Número de la orden: #{{ order.tableId }}</h1>
      <h2 :class="['order-state', chooseStateColor]">{{ STATES_USER_MESSAGES[order.state] }}</h2>
    </div>
  </main>
</template>

<style scoped>
main {
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 100vh;
  padding: 20px;
  background-color: #f9f9f9;
  font-family: Arial, sans-serif;
}

.order-status {
  background-color: #ffffff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
  max-width: 400px;
  width: 100%;
}

.order-status h1 {
  font-size: 1.8em;
  margin-bottom: 15px;
}

.order-status h2 {
  font-size: 1.5em;
  margin-top: 0;
}

.order-state {
  font-weight: bold;
}

.danger {
  color: #dc3545;
}

.info {
  color: #17a2b8;
}

.success {
  color: #28a745;
}

.primary {
  color: #007bff;
}
</style>
