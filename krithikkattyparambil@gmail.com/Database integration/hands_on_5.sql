task 1:


Database Name:

college_nosql

Collection Name:

feedback

for inserting:

{
  "student_id": 1,
  "course_code": "CS101",
  "semester": "2022-ODD",
  "rating": 5,
  "comments": "Excellent teaching",
  "tags": ["challenging","well-structured"],
  "submitted_at": "2022-11-30",
  "attachments": [
    {
      "filename":"notes.pdf",
      "size_kb":240
    }
  ]
}

add data 1:

{
  "student_id": 1,
  "course_code": "CS101",
  "semester": "2022-ODD",
  "rating": 5,
  "comments": "Excellent teaching",
  "tags": ["challenging","well-structured"],
  "submitted_at": "2022-11-30",
  "attachments": [
    {
      "filename":"notes.pdf",
      "size_kb":240
    }
  ]
}

add data 2:

{
  "student_id": 2,
  "course_code": "CS101",
  "semester": "2022-ODD",
  "rating": 4,
  "comments": "Very good course",
  "tags": ["challenging","good-examples"],
  "submitted_at": "2022-11-28",
  "attachments": [
    {
      "filename":"assignment.pdf",
      "size_kb":180
    }
  ]
}

add data 3:

{
  "student_id": 3,
  "course_code": "CS101",
  "semester": "2022-ODD",
  "rating": 2,
  "comments": "Needs improvement",
  "tags": ["difficult"],
  "submitted_at": "2022-11-27",
  "attachments": [
    {
      "filename":"feedback.pdf",
      "size_kb":100
    }
  ]
}

data 4:

{
  "student_id": 4,
  "course_code": "CS102",
  "semester": "2022-EVEN",
  "rating": 5,
  "comments": "Excellent DBMS course",
  "tags": ["well-structured"],
  "submitted_at": "2022-11-20",
  "attachments": [
    {
      "filename":"dbms.pdf",
      "size_kb":220
    }
  ]
}

data 5:

{
  "student_id": 5,
  "course_code": "CS102",
  "semester": "2022-EVEN",
  "rating": 3,
  "comments": "Average course",
  "tags": ["average"],
  "submitted_at": "2022-11-21",
  "attachments": [
    {
      "filename":"report.pdf",
      "size_kb":140
    }
  ]
}

data 6:

{
  "student_id": 6,
  "course_code": "CS103",
  "semester": "2021-EVEN",
  "rating": 1,
  "comments": "Poor experience",
  "tags": ["hard"],
  "submitted_at": "2021-11-21",
  "attachments": [
    {
      "filename":"old.pdf",
      "size_kb":120
    }
  ]
}

data 7:

{
  "student_id": 7,
  "course_code": "EC101",
  "semester": "2022-ODD",
  "rating": 4,
  "comments": "Interesting course",
  "tags": ["good-examples"],
  "submitted_at": "2022-11-15",
  "attachments": [
    {
      "filename":"ec.pdf",
      "size_kb":150
    }
  ]
}

data 8:


{
  "student_id": 8,
  "course_code": "ME101",
  "semester": "2022-ODD",
  "rating": 5,
  "comments": "Excellent",
  "tags": ["challenging"],
  "submitted_at": "2022-11-10",
  "attachments": [
    {
      "filename":"me.pdf",
      "size_kb":190
    }
  ]
}

data 9:

{
  "student_id": 9,
  "course_code": "CS103",
  "semester": "2022-EVEN",
  "rating": 2,
  "comments": "Needs revision",
  "tags": ["difficult"],
  "submitted_at": "2022-11-05",
  "attachments": [
    {
      "filename":"rev.pdf",
      "size_kb":110
    }
  ]
}

data 10:

{
  "student_id": 10,
  "course_code": "CS102",
  "semester": "2022-ODD",
  "rating": 5,
  "comments": "Outstanding",
  "tags": ["challenging","good-examples"],
  "submitted_at": "2022-11-01"
}


to verify total documents:

db.feedback.countDocuments()


task 2:

{ "rating": 5 }



{
  "course_code": "CS101",
  "tags": "challenging"
}


{
  "_id": 0,
  "student_id": 1,
  "course_code": 1,
  "rating": 1
}




in mongosh:

db.feedback.updateMany(
   { rating: { $lt: 3 } },
   { $set: { needs_review: true } }
)


 to verify:

db.feedback.find({ needs_review: true })


add the tag:

db.feedback.updateMany(
   { needs_review: true },
   { $push: { tags: "reviewed" } }
)


to verify:


db.feedback.find({ needs_review: true })


to delete:

db.feedback.deleteMany(
   { semester: "2021-EVEN" }
)

toverify:

db.feedback.countDocuments()



task 3:


opening mongosh:

db.feedback.aggregate([
  {
    $match: { semester: "2022-ODD" }
  },
  {
    $group: {
      _id: "$course_code",
      avg_rating: { $avg: "$rating" },
      feedback_count: { $sum: 1 }
    }
  },
  {
    $sort: { avg_rating: -1 }
  }
])

rename avg_rating:

db.feedback.aggregate([
  {
    $match: { semester: "2022-ODD" }
  },
  {
    $group: {
      _id: "$course_code",
      avg_rating: { $avg: "$rating" },
      feedback_count: { $sum: 1 }
    }
  },
  {
    $project: {
      _id: 0,
      course_code: "$_id",
      average_rating: {
        $round: ["$avg_rating", 1]
      },
      feedback_count: 1
    }
  },
  {
    $sort: { average_rating: -1 }
  }
])

tag frequency leaderboard:

db.feedback.aggregate([
  {
    $unwind: "$tags"
  },
  {
    $group: {
      _id: "$tags",
      count: { $sum: 1 }
    }
  },
  {
    $sort: { count: -1 }
  }
])

create an index:

db.feedback.createIndex(
  { course_code: 1 }
)

to verify:

db.feedback.find(
  { course_code: "CS101" }
).explain("executionStats")




