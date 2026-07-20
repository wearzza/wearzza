/*
# Fix RLS Policies With Always-True Clauses

## Problem
47 write policies (INSERT/UPDATE/DELETE) across 11 tables used literal `true`
in their USING/WITH CHECK clauses, effectively disabling row-level security for
the anon role. Any client with the anon key could insert, update, or delete any
row in banners, categories, customers, notifications, order_items, orders,
otp_codes, products, promo_codes, reviews, and sellers.

## Fix
Replace every always-true write policy with a real predicate that requires a
Supabase Auth session (`auth.uid() IS NOT NULL`). SELECT policies are unchanged
(browsing products, banners, categories, reviews, sellers is intentionally public).

## Impact / Required Follow-up
The frontend currently uses the anon key for ALL writes (admin panel, seller
dashboard, customer checkout, reviews, OTP). With these policies now requiring
an authenticated session, those write flows will fail until the app either:
  1. Adopts Supabase Auth (email/password) for admin/seller/customer sign-in, OR
  2. Routes writes through edge functions that use the service role key.
This migration secures the database; restoring frontend write functionality is
a separate follow-up task.

## Tables updated
- banners, categories, customers, notifications, order_items, orders,
  otp_codes, products, promo_codes, reviews, sellers

## Security
- All write policies now `TO authenticated` with `auth.uid() IS NOT NULL`.
- anon role can no longer insert/update/delete any data.
- SELECT remains open to anon, authenticated (public catalog browsing).
*/

-- banners
DROP POLICY IF EXISTS "banners_insert" ON banners;
CREATE POLICY "banners_insert" ON banners FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "banners_update" ON banners;
CREATE POLICY "banners_update" ON banners FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "banners_delete" ON banners;
CREATE POLICY "banners_delete" ON banners FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- categories
DROP POLICY IF EXISTS "insert_categories" ON categories;
CREATE POLICY "insert_categories" ON categories FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "update_categories" ON categories;
CREATE POLICY "update_categories" ON categories FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "delete_categories" ON categories;
CREATE POLICY "delete_categories" ON categories FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- customers
DROP POLICY IF EXISTS "insert_customers" ON customers;
CREATE POLICY "insert_customers" ON customers FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);

-- notifications
DROP POLICY IF EXISTS "notifs_insert" ON notifications;
CREATE POLICY "notifs_insert" ON notifications FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "notifs_update" ON notifications;
CREATE POLICY "notifs_update" ON notifications FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "notifs_delete" ON notifications;
CREATE POLICY "notifs_delete" ON notifications FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_insert_notification" ON notifications;
CREATE POLICY "public_insert_notification" ON notifications FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_update_notification" ON notifications;
CREATE POLICY "public_update_notification" ON notifications FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_delete_notification" ON notifications;
CREATE POLICY "public_delete_notification" ON notifications FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- order_items
DROP POLICY IF EXISTS "order_items_insert" ON order_items;
CREATE POLICY "order_items_insert" ON order_items FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "order_items_update" ON order_items;
CREATE POLICY "order_items_update" ON order_items FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "order_items_delete" ON order_items;
CREATE POLICY "order_items_delete" ON order_items FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_insert_order_item" ON order_items;
CREATE POLICY "public_insert_order_item" ON order_items FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_update_order_item" ON order_items;
CREATE POLICY "public_update_order_item" ON order_items FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_delete_order_item" ON order_items;
CREATE POLICY "public_delete_order_item" ON order_items FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- orders
DROP POLICY IF EXISTS "orders_insert" ON orders;
CREATE POLICY "orders_insert" ON orders FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "orders_update" ON orders;
CREATE POLICY "orders_update" ON orders FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "orders_delete" ON orders;
CREATE POLICY "orders_delete" ON orders FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_insert_order" ON orders;
CREATE POLICY "public_insert_order" ON orders FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_delete_order" ON orders;
CREATE POLICY "public_delete_order" ON orders FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "seller_update_order" ON orders;
CREATE POLICY "seller_update_order" ON orders FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- otp_codes
DROP POLICY IF EXISTS "otp_insert" ON otp_codes;
CREATE POLICY "otp_insert" ON otp_codes FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "otp_update" ON otp_codes;
CREATE POLICY "otp_update" ON otp_codes FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "otp_delete" ON otp_codes;
CREATE POLICY "otp_delete" ON otp_codes FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- products
DROP POLICY IF EXISTS "products_insert" ON products;
CREATE POLICY "products_insert" ON products FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "products_update" ON products;
CREATE POLICY "products_update" ON products FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "products_delete" ON products;
CREATE POLICY "products_delete" ON products FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "seller_insert_product" ON products;
CREATE POLICY "seller_insert_product" ON products FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "seller_update_product" ON products;
CREATE POLICY "seller_update_product" ON products FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "seller_delete_product" ON products;
CREATE POLICY "seller_delete_product" ON products FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- promo_codes
DROP POLICY IF EXISTS "promos_insert" ON promo_codes;
CREATE POLICY "promos_insert" ON promo_codes FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "promos_update" ON promo_codes;
CREATE POLICY "promos_update" ON promo_codes FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "promos_delete" ON promo_codes;
CREATE POLICY "promos_delete" ON promo_codes FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_insert_promo" ON promo_codes;
CREATE POLICY "public_insert_promo" ON promo_codes FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_update_promo" ON promo_codes;
CREATE POLICY "public_update_promo" ON promo_codes FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_delete_promo" ON promo_codes;
CREATE POLICY "public_delete_promo" ON promo_codes FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- reviews
DROP POLICY IF EXISTS "reviews_insert" ON reviews;
CREATE POLICY "reviews_insert" ON reviews FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "reviews_update" ON reviews;
CREATE POLICY "reviews_update" ON reviews FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "reviews_delete" ON reviews;
CREATE POLICY "reviews_delete" ON reviews FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_insert_review" ON reviews;
CREATE POLICY "public_insert_review" ON reviews FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_update_review" ON reviews;
CREATE POLICY "public_update_review" ON reviews FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "public_delete_review" ON reviews;
CREATE POLICY "public_delete_review" ON reviews FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);

-- sellers
DROP POLICY IF EXISTS "seller_insert" ON sellers;
CREATE POLICY "seller_insert" ON sellers FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "seller_update_own" ON sellers;
CREATE POLICY "seller_update_own" ON sellers FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "seller_delete_own" ON sellers;
CREATE POLICY "seller_delete_own" ON sellers FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "sellers_insert" ON sellers;
CREATE POLICY "sellers_insert" ON sellers FOR INSERT
  TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "sellers_update" ON sellers;
CREATE POLICY "sellers_update" ON sellers FOR UPDATE
  TO authenticated USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS "sellers_delete" ON sellers;
CREATE POLICY "sellers_delete" ON sellers FOR DELETE
  TO authenticated USING (auth.uid() IS NOT NULL);
