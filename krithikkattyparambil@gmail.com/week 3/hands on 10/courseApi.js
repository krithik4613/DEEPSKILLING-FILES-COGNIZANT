import { apiClient } from './apiClient.js';

// Components only ever call these functions — they never see HTTP status
// codes or the raw Axios response; the interceptor already unwraps the data.

export async function getAllCourses() {
  const posts = await apiClient.get('/posts?_limit=5');
  return posts.map((post, index) => ({
    id: post.id,
    name: post.title.slice(0, 24),
    code: `CS${100 + index}`,
    credits: 3 + (index % 2),
    grade: 'TBD',
  }));
}

export async function getCourseById(id) {
  const post = await apiClient.get(`/posts/${id}`);
  return {
    id: post.id,
    name: post.title.slice(0, 24),
    code: `CS${100 + id}`,
    credits: 3,
    grade: 'TBD',
  };
}

export async function enrollStudent(studentId, courseId) {
  // JSONPlaceholder fakes a successful POST and echoes the payload back
  return apiClient.post('/posts', { studentId, courseId });
}
