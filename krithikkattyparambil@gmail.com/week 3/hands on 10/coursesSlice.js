import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { getAllCourses } from '../api/courseApi.js';

// Task 2: async thunk wraps the API call; Redux manages loading/error state
// so components never need their own useState for it.
export const fetchAllCourses = createAsyncThunk('courses/fetchAll', async () => {
  return await getAllCourses();
});

const coursesSlice = createSlice({
  name: 'courses',
  initialState: {
    items: [],
    loading: false,
    error: null,
  },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchAllCourses.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchAllCourses.fulfilled, (state, action) => {
        state.items = action.payload;
        state.loading = false;
      })
      .addCase(fetchAllCourses.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message ?? 'Failed to load courses';
      });
  },
});

// Selectors — components use these instead of reaching into store shape directly
export const selectCourses = (state) => state.courses.items;
export const selectCoursesLoading = (state) => state.courses.loading;
export const selectCoursesError = (state) => state.courses.error;

export default coursesSlice.reducer;
