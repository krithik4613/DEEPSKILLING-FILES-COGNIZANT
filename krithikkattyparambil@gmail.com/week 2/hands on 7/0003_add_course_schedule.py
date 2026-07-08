"""add course_schedule table

Revision ID: 0003
Revises: 0002
Create Date: 2026-07-03
"""
from alembic import op
import sqlalchemy as sa

revision = "0003"
down_revision = "0002"


def upgrade():
    op.create_table(
        "course_schedules",
        sa.Column("schedule_id", sa.Integer, primary_key=True),
        sa.Column("course_id", sa.Integer, sa.ForeignKey("courses.course_id")),
        sa.Column("day_of_week", sa.String(10)),
        sa.Column("start_time", sa.Time),
        sa.Column("end_time", sa.Time),
    )


def downgrade():
    op.drop_table("course_schedules")
