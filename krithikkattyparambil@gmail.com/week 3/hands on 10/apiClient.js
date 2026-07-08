import axios from 'axios';

// Task 1: a single, centralised Axios instance used by every API module.
// Changing baseURL here (dev vs prod) affects the whole app in one place.
export const apiClient = axios.create({
  baseURL: 'https://jsonplaceholder.typicode.com',
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor: attaches a mock auth token to every outgoing request
apiClient.interceptors.request.use((config) => {
  config.headers.Authorization = 'Bearer mock-token-123';
  console.log(`API call started: ${config.baseURL}${config.url}`);
  return config;
});

// Response interceptor:
//  (a) unwraps response.data so callers never see the Axios wrapper
//  (b) standardises errors into { message, statusCode }
apiClient.interceptors.response.use(
  (response) => response.data,
  (error) => {
    const statusCode = error.response ? error.response.status : 0;
    const message = error.response
      ? `Request failed with status ${statusCode}`
      : 'Network error — please check your connection';
    return Promise.reject({ message, statusCode });
  }
);
