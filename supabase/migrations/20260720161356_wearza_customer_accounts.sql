/*
# Wearza: Customer Accounts (Optional Auth)

Customers can optionally sign up/login like Daraz. Checkout still works as guest.
*/

CREATE TABLE IF NOT EXISTS customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  phone text NOT NULL,
  email text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "insert_customers" ON customers FOR INSERT
  TO anon, authenticated WITH CHECK (true);
CREATE POLICY "select_own_customers" ON customers FOR SELECT
  TO anon, authenticated USING (true);
