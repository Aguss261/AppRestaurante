import axios from 'axios'

export const http = axios.create({
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000, // 10 second timeout
})

// Add response interceptor for error handling
http.interceptors.response.use(
  response => response,
  error => {
    console.error('API Error:', error.message)
    if (error.response) {
      console.error('Status:', error.response.status)
      console.error('Data:', error.response.data)
    }
    return Promise.reject(error)
  }
)
