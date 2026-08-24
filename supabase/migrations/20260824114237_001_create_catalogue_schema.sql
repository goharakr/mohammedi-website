/*
# Mohammedi Gypsum Tiles & Sanitary — Catalogue Schema

1. Purpose
   Creates the full product catalogue database for a premium building-materials
   showroom website. Categories → Subcategories → Products, with product images,
   variants, and AI visualizations. Designed to scale beyond 2,000 products.

2. New Tables
   - `categories` — top-level catalogue groups (Tiles, Sanitaryware, Granite & Marble, ...)
   - `subcategories` — children of a category (Floor Tiles, Wall Tiles, ...)
   - `products` — individual products, each linked to a category + subcategory
   - `product_images` — multiple images per product (main, detail, installed, visualization, angle)
   - `product_variants` — size / finish / colour / variant code per product
   - `visualizations` — AI-generated room visualizations per product + room type
   - `enquiries` — customer enquiries / price requests submitted from the site

3. Columns of note
   - products.status: published | draft | coming_soon | out_of_stock
   - products.featured, new_arrival, bestseller: boolean flags
   - products.hidden: hides a product even if published
   - products.tags: text[] for fast search
   - products.seo_title, seo_description, image_alt: SEO fields

4. Security
   - RLS enabled on every table.
   - Public read (anon + authenticated) on all catalogue tables — this is a public storefront.
   - Write operations restricted to `authenticated` (the owner/admin signs in to manage).
   - `enquiries` is public-insert (anyone can submit) but only authenticated can read.

5. Indexes
   - products: category_id, subcategory_id, product_code, status
   - product_images: product_id
   - product_variants: product_id
   - visualizations: product_id
   - GIN index on products.tags for fast tag search

6. Notes
   - No user_id columns — this is a single-tenant storefront managed by one owner.
   - The owner authenticates via Supabase email/password to access admin write operations.
*/

-- ============================================================
-- CATEGORIES
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  image_url text,
  sort_order integer NOT NULL DEFAULT 0,
  active boolean NOT NULL DEFAULT true,
  seo_title text,
  seo_description text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_categories" ON categories;
CREATE POLICY "public_read_categories" ON categories FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "auth_insert_categories" ON categories;
CREATE POLICY "auth_insert_categories" ON categories FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "auth_update_categories" ON categories;
CREATE POLICY "auth_update_categories" ON categories FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_delete_categories" ON categories;
CREATE POLICY "auth_delete_categories" ON categories FOR DELETE
  TO authenticated USING (true);

-- ============================================================
-- SUBCATEGORIES
-- ============================================================
CREATE TABLE IF NOT EXISTS subcategories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  slug text NOT NULL,
  description text,
  image_url text,
  sort_order integer NOT NULL DEFAULT 0,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (category_id, slug)
);

ALTER TABLE subcategories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_subcategories" ON subcategories;
CREATE POLICY "public_read_subcategories" ON subcategories FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "auth_insert_subcategories" ON subcategories;
CREATE POLICY "auth_insert_subcategories" ON subcategories FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "auth_update_subcategories" ON subcategories;
CREATE POLICY "auth_update_subcategories" ON subcategories FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_delete_subcategories" ON subcategories;
CREATE POLICY "auth_delete_subcategories" ON subcategories FOR DELETE
  TO authenticated USING (true);

-- ============================================================
-- PRODUCTS
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  subcategory_id uuid REFERENCES subcategories(id) ON DELETE SET NULL,
  product_code text NOT NULL,
  name text,
  description text,
  status text NOT NULL DEFAULT 'draft',
  featured boolean NOT NULL DEFAULT false,
  new_arrival boolean NOT NULL DEFAULT false,
  bestseller boolean NOT NULL DEFAULT false,
  hidden boolean NOT NULL DEFAULT false,
  sizes text[] DEFAULT '{}',
  finish text,
  colour text,
  pattern text,
  application text,
  brand text,
  specifications jsonb DEFAULT '{}',
  tags text[] DEFAULT '{}',
  seo_title text,
  seo_description text,
  image_alt text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Public can only see published, non-hidden products
DROP POLICY IF EXISTS "public_read_products" ON products;
CREATE POLICY "public_read_products" ON products FOR SELECT
  TO anon, authenticated USING (status = 'published' AND hidden = false);

-- Admin (authenticated) can see and manage everything
DROP POLICY IF EXISTS "auth_select_products" ON products;
CREATE POLICY "auth_select_products" ON products FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "auth_insert_products" ON products;
CREATE POLICY "auth_insert_products" ON products FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "auth_update_products" ON products;
CREATE POLICY "auth_update_products" ON products FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_delete_products" ON products;
CREATE POLICY "auth_delete_products" ON products FOR DELETE
  TO authenticated USING (true);

-- ============================================================
-- PRODUCT IMAGES
-- ============================================================
CREATE TABLE IF NOT EXISTS product_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  image_url text NOT NULL,
  image_type text NOT NULL DEFAULT 'main',
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE product_images ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_product_images" ON product_images;
CREATE POLICY "public_read_product_images" ON product_images FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "auth_insert_product_images" ON product_images;
CREATE POLICY "auth_insert_product_images" ON product_images FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "auth_update_product_images" ON product_images;
CREATE POLICY "auth_update_product_images" ON product_images FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_delete_product_images" ON product_images;
CREATE POLICY "auth_delete_product_images" ON product_images FOR DELETE
  TO authenticated USING (true);

-- ============================================================
-- PRODUCT VARIANTS
-- ============================================================
CREATE TABLE IF NOT EXISTS product_variants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  size text,
  finish text,
  colour text,
  variant_code text,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_product_variants" ON product_variants;
CREATE POLICY "public_read_product_variants" ON product_variants FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "auth_insert_product_variants" ON product_variants;
CREATE POLICY "auth_insert_product_variants" ON product_variants FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "auth_update_product_variants" ON product_variants;
CREATE POLICY "auth_update_product_variants" ON product_variants FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_delete_product_variants" ON product_variants;
CREATE POLICY "auth_delete_product_variants" ON product_variants FOR DELETE
  TO authenticated USING (true);

-- ============================================================
-- VISUALIZATIONS (AI room visualizations per product)
-- ============================================================
CREATE TABLE IF NOT EXISTS visualizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  room_type text NOT NULL,
  generated_image text,
  prompt text,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE visualizations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_visualizations" ON visualizations;
CREATE POLICY "public_read_visualizations" ON visualizations FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "auth_insert_visualizations" ON visualizations;
CREATE POLICY "auth_insert_visualizations" ON visualizations FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "auth_update_visualizations" ON visualizations;
CREATE POLICY "auth_update_visualizations" ON visualizations FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_delete_visualizations" ON visualizations;
CREATE POLICY "auth_delete_visualizations" ON visualizations FOR DELETE
  TO authenticated USING (true);

-- ============================================================
-- ENQUIRIES (customer price requests / contact)
-- ============================================================
CREATE TABLE IF NOT EXISTS enquiries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  product_code text,
  customer_name text,
  customer_phone text,
  customer_email text,
  message text,
  enquiry_type text NOT NULL DEFAULT 'price_request',
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE enquiries ENABLE ROW LEVEL SECURITY;

-- Anyone can submit an enquiry
DROP POLICY IF EXISTS "public_insert_enquiries" ON enquiries;
CREATE POLICY "public_insert_enquiries" ON enquiries FOR INSERT
  TO anon, authenticated WITH CHECK (true);

-- Only admin can read enquiries
DROP POLICY IF EXISTS "auth_read_enquiries" ON enquiries;
CREATE POLICY "auth_read_enquiries" ON enquiries FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "auth_delete_enquiries" ON enquiries;
CREATE POLICY "auth_delete_enquiries" ON enquiries FOR DELETE
  TO authenticated USING (true);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_subcategory ON products(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_products_code ON products(product_code);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_tags ON products USING gin (tags);
CREATE INDEX IF NOT EXISTS idx_product_images_product ON product_images(product_id);
CREATE INDEX IF NOT EXISTS idx_product_variants_product ON product_variants(product_id);
CREATE INDEX IF NOT EXISTS idx_visualizations_product ON visualizations(product_id);
CREATE INDEX IF NOT EXISTS idx_subcategories_category ON subcategories(category_id);

-- ============================================================
-- updated_at trigger function
-- ============================================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_categories_updated ON categories;
CREATE TRIGGER trg_categories_updated BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_subcategories_updated ON subcategories;
CREATE TRIGGER trg_subcategories_updated BEFORE UPDATE ON subcategories
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_products_updated ON products;
CREATE TRIGGER trg_products_updated BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
