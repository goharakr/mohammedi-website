export type ProductStatus = 'published' | 'draft' | 'coming_soon' | 'out_of_stock';

export interface Category {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  sort_order: number;
  active: boolean;
}

export interface Subcategory {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  sort_order: number;
  active: boolean;
}

export interface ProductImage {
  id: string;
  product_id: string;
  image_url: string;
  image_type: string;
  sort_order: number;
}

export interface Product {
  id: string;
  category_id: string;
  subcategory_id: string | null;
  product_code: string;
  name: string | null;
  description: string | null;
  status: ProductStatus;
  featured: boolean;
  new_arrival: boolean;
  bestseller: boolean;
  hidden: boolean;
  sizes: string[];
  finish: string | null;
  colour: string | null;
  pattern: string | null;
  application: string | null;
  brand: string | null;
  tags: string[];
  image_alt: string | null;
  product_images?: ProductImage[];
  categories?: Category;
  subcategories?: Subcategory | null;
}

export const categoryImages: Record<string, string> = {
  tiles: 'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'sanitaryware': 'https://images.pexels.com/photos/6782476/pexels-photo-6782476.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'taps-mixers': 'https://images.pexels.com/photos/6444259/pexels-photo-6444259.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'granite-marble': 'https://images.pexels.com/photos/2291738/pexels-photo-2291738.jpeg?auto=compress&cs=tinysrgb&w=1200',
  kitchen: 'https://images.pexels.com/photos/3214064/pexels-photo-3214064.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'gypsum-ceiling': 'https://images.pexels.com/photos/157811/pexels-photo-157811.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'bathroom-fittings': 'https://images.pexels.com/photos/6589127/pexels-photo-6589127.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'doors-hardware': 'https://images.pexels.com/photos/12616295/pexels-photo-12616295.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'water-heaters': 'https://images.pexels.com/photos/6489119/pexels-photo-6489119.jpeg?auto=compress&cs=tinysrgb&w=1200',
  'hooks-hardware': 'https://images.pexels.com/photos/5691622/pexels-photo-5691622.jpeg?auto=compress&cs=tinysrgb&w=1200',
  handles: 'https://images.pexels.com/photos/6585758/pexels-photo-6585758.jpeg?auto=compress&cs=tinysrgb&w=1200',
  cabinets: 'https://images.pexels.com/photos/667838/pexels-photo-667838.jpeg?auto=compress&cs=tinysrgb&w=1200',
};
