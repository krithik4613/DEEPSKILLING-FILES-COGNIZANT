"""add is_active to students

Revision ID: 0002
Revises: 0001
Create Date: 2026-07-03
"""
from alembic import op
import sqlalchemy as sa

revision = "0002"
down_revision = "0001"


def upgrade():
    op.add_column("students", sa.Column("is_active", sa.Boolean, server_default=sa.true()))


def downgrade():
    op.drop_column("students", "is_active")
