import { supabase } from '@/lib/supabase';
import type { Category, Product, Subcategory } from '@/types/catalogue';

export async function fetchCatalogue() {
  if (!supabase) throw new Error('Catalogue connection unavailable');
  const [categoriesResult, subcategoriesResult, productsResult] = await Promise.all([
    supabase.from('categories').select('*').eq('active', true).order('sort_order'),
    supabase.from('subcategories').select('*').eq('active', true).order('sort_order'),
    supabase.from('products').select('*, product_images(*)').eq('status', 'published').eq('hidden', false).order('created_at', { ascending: false }),
  ]);
  if (categoriesResult.error || subcategoriesResult.error || productsResult.error) throw new Error('Catalogue unavailable');
  return {
    categories: (categoriesResult.data ?? []) as Category[],
    subcategories: (subcategoriesResult.data ?? []) as Subcategory[],
    products: (productsResult.data ?? []) as Product[],
  };
}
