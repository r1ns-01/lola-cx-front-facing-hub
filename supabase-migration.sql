-- ═══════════════════════════════════════════════════════════
-- Lola Blankets Training Hub — Supabase Migration
-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor)
-- ═══════════════════════════════════════════════════════════

-- 1. Progress tracking table
CREATE TABLE IF NOT EXISTS training_progress (
  id BIGSERIAL PRIMARY KEY,
  user_name TEXT NOT NULL,
  section_id TEXT NOT NULL,
  completed BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_name, section_id)
);

-- 2. Notes table (private + public)
CREATE TABLE IF NOT EXISTS training_notes (
  id BIGSERIAL PRIMARY KEY,
  user_name TEXT NOT NULL,
  section_id TEXT NOT NULL,
  note_text TEXT NOT NULL,
  is_public BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Enable Row Level Security
ALTER TABLE training_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE training_notes ENABLE ROW LEVEL SECURITY;

-- 4. RLS Policies — allow all operations for anon users
--    (since we use a simple name-based auth, not Supabase Auth)
DROP POLICY IF EXISTS "Allow all reads on progress" ON training_progress;
CREATE POLICY "Allow all reads on progress"
  ON training_progress FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Allow all inserts on progress" ON training_progress;
CREATE POLICY "Allow all inserts on progress"
  ON training_progress FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all updates on progress" ON training_progress;
CREATE POLICY "Allow all updates on progress"
  ON training_progress FOR UPDATE
  USING (true);

DROP POLICY IF EXISTS "Allow all deletes on progress" ON training_progress;
CREATE POLICY "Allow all deletes on progress"
  ON training_progress FOR DELETE
  USING (true);

DROP POLICY IF EXISTS "Allow all reads on notes" ON training_notes;
CREATE POLICY "Allow all reads on notes"
  ON training_notes FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Allow all inserts on notes" ON training_notes;
CREATE POLICY "Allow all inserts on notes"
  ON training_notes FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all deletes on notes" ON training_notes;
CREATE POLICY "Allow all deletes on notes"
  ON training_notes FOR DELETE
  USING (true);

-- 3b. Notifications table (@mention alerts between users)
CREATE TABLE IF NOT EXISTS training_notifications (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  recipient TEXT NOT NULL,
  sender TEXT NOT NULL,
  section_id TEXT NOT NULL,
  note_text TEXT NOT NULL,
  read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS on notifications
ALTER TABLE training_notifications ENABLE ROW LEVEL SECURITY;

-- RLS Policies for notifications
DROP POLICY IF EXISTS "Allow all reads on notifications" ON training_notifications;
CREATE POLICY "Allow all reads on notifications"
  ON training_notifications FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Allow all inserts on notifications" ON training_notifications;
CREATE POLICY "Allow all inserts on notifications"
  ON training_notifications FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all updates on notifications" ON training_notifications;
CREATE POLICY "Allow all updates on notifications"
  ON training_notifications FOR UPDATE
  USING (true);

DROP POLICY IF EXISTS "Allow all deletes on notifications" ON training_notifications;
CREATE POLICY "Allow all deletes on notifications"
  ON training_notifications FOR DELETE
  USING (true);

-- 4. Note reactions table (👍 ❤️ 👌 🙏 on public notes)
CREATE TABLE IF NOT EXISTS note_reactions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  note_id BIGINT NOT NULL,
  user_name TEXT NOT NULL,
  reaction_type TEXT NOT NULL CHECK (reaction_type IN ('thumbsup','heart','ok','thanks')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(note_id, user_name, reaction_type)
);

ALTER TABLE note_reactions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all reads on reactions" ON note_reactions;
CREATE POLICY "Allow all reads on reactions"
  ON note_reactions FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow all inserts on reactions" ON note_reactions;
CREATE POLICY "Allow all inserts on reactions"
  ON note_reactions FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all deletes on reactions" ON note_reactions;
CREATE POLICY "Allow all deletes on reactions"
  ON note_reactions FOR DELETE USING (true);

-- 5. Indexes for performance
CREATE INDEX IF NOT EXISTS idx_progress_user ON training_progress(user_name);
CREATE INDEX IF NOT EXISTS idx_progress_section ON training_progress(section_id);
CREATE INDEX IF NOT EXISTS idx_notes_section ON training_notes(section_id);
CREATE INDEX IF NOT EXISTS idx_notes_user ON training_notes(user_name);
CREATE INDEX IF NOT EXISTS idx_notif_recipient ON training_notifications(recipient);
CREATE INDEX IF NOT EXISTS idx_notif_read ON training_notifications(recipient, read);
CREATE INDEX IF NOT EXISTS idx_reactions_note ON note_reactions(note_id);
CREATE INDEX IF NOT EXISTS idx_reactions_user ON note_reactions(user_name);
