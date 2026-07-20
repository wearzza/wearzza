/*
# Wearza: Dynamic Categories (Admin Menu Management)

Admin can add/remove product categories that appear in the customer navbar,
homepage, and seller product form. Replaces hardcoded category lists.
*/

CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  label text NOT NULL,
  icon text DEFAULT '📦',
  color text DEFAULT '#6b7280',
  sort_order integer DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_categories" ON categories FOR SELECT
  TO anon, authenticated USING (true);
CREATE POLICY "insert_categories" ON categories FOR INSERT
  TO authenticated WITH CHECK (true);
CREATE POLICY "update_categories" ON categories FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "delete_categories" ON categories FOR DELETE
  TO authenticated USING (true);

-- Seed default categories
INSERT INTO categories (slug, label, icon, color, sort_order) VALUES
  ('men', 'Men', '👔', '#3b82f6', 1),
  ('women', 'Women', '👗', '#ec4899', 2),
  ('kids', 'Kids', '👶', '#f59e0b', 3),
  ('streetwear', 'Streetwear', '🧢', '#8b5cf6', 4),
  ('old_money', 'Old Money', '💼', '#1a2340', 5),
  ('budget', 'Budget Deals', '💰', '#22c55e', 6)
ON CONFLICT (slug) DO NOTHING;
