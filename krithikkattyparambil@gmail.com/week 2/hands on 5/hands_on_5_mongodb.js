// ============================================
// HANDS-ON 5: MongoDB - Document Modelling, CRUD & Aggregation
// Run with: mongosh < hands_on_5_mongodb.js
// ============================================

use college_nosql;

// ===== TASK 1: Create Collection & Insert Documents =====

db.feedback.insertMany([
  { student_id: 1, course_code: 'CS101', semester: '2022-ODD', rating: 5, comments: 'Excellent teaching.', tags: ['challenging', 'well-structured'], submitted_at: new Date('2022-11-30'), attachments: [{ filename: 'notes.pdf', size_kb: 240 }] },
  { student_id: 2, course_code: 'CS101', semester: '2022-ODD', rating: 4, comments: 'Good pace.', tags: ['well-structured', 'good-examples'], submitted_at: new Date('2022-11-28'), attachments: [] },
  { student_id: 5, course_code: 'CS101', semester: '2022-ODD', rating: 2, comments: 'Too fast.', tags: ['challenging'], submitted_at: new Date('2022-11-29'), attachments: [] },
  { student_id: 1, course_code: 'CS102', semester: '2022-ODD', rating: 4, comments: 'Solid content.', tags: ['good-examples'], submitted_at: new Date('2022-12-01'), attachments: [] },
  { student_id: 5, course_code: 'CS102', semester: '2022-ODD', rating: 3, comments: 'Average.', tags: ['challenging'], submitted_at: new Date('2022-12-02'), attachments: [] },
  { student_id: 2, course_code: 'CS103', semester: '2022-ODD', rating: 5, comments: 'Loved it.', tags: ['well-structured', 'good-examples'], submitted_at: new Date('2022-12-03') },  // no attachments field
  { student_id: 3, course_code: 'EC101', semester: '2021-EVEN', rating: 4, comments: 'Clear explanations.', tags: ['good-examples'], submitted_at: new Date('2021-12-10'), attachments: [] },
  { student_id: 6, course_code: 'EC101', semester: '2021-EVEN', rating: 1, comments: 'Needs improvement.', tags: ['challenging'], submitted_at: new Date('2021-12-11'), attachments: [] },
  { student_id: 4, course_code: 'ME101', semester: '2023-ODD', rating: 5, comments: 'Great course.', tags: ['well-structured'], submitted_at: new Date('2023-12-01'), attachments: [] },
  { student_id: 8, course_code: 'CS101', semester: '2022-ODD', rating: 3, comments: 'Okay overall.', tags: ['challenging', 'good-examples'], submitted_at: new Date('2022-11-27'), attachments: [] }
]);

db.feedback.countDocuments();  // should be >= 10


// ===== TASK 2: CRUD Operations =====

// READ: rating = 5
db.feedback.find({ rating: 5 });

// READ: CS101 feedback tagged 'challenging'
db.feedback.find({ course_code: 'CS101', tags: 'challenging' });

// READ: projection, exclude _id
db.feedback.find({}, { student_id: 1, course_code: 1, rating: 1, _id: 0 });

// UPDATE: flag low ratings for review
db.feedback.updateMany({ rating: { $lt: 3 } }, { $set: { needs_review: true } });

// UPDATE: tag reviewed docs
db.feedback.updateMany({ needs_review: true }, { $push: { tags: 'reviewed' } });

// DELETE: old semester feedback
db.feedback.deleteMany({ semester: '2021-EVEN' });


// ===== TASK 3: Aggregation Pipeline =====

// Avg rating & count per course, semester 2022-ODD, sorted desc
db.feedback.aggregate([
  { $match: { semester: '2022-ODD' } },
  { $group: { _id: '$course_code', avg_rating: { $avg: '$rating' }, total_feedback: { $sum: 1 } } },
  { $sort: { avg_rating: -1 } }
]);

// Same, with rounded/renamed field
db.feedback.aggregate([
  { $match: { semester: '2022-ODD' } },
  { $group: { _id: '$course_code', avg_rating: { $avg: '$rating' }, total_feedback: { $sum: 1 } } },
  { $project: { average_rating: { $round: ['$avg_rating', 1] }, total_feedback: 1 } },
  { $sort: { average_rating: -1 } }
]);

// Tag frequency leaderboard
db.feedback.aggregate([
  { $unwind: '$tags' },
  { $group: { _id: '$tags', count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]);

// Index + verify usage
db.feedback.createIndex({ course_code: 1 });
db.feedback.find({ course_code: 'CS101' }).explain('executionStats');  // check for IXSCAN
