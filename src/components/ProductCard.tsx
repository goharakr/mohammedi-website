import { ArrowUpRight, Sparkles } from 'lucide-react';
import type { Product } from '@/types/catalogue';

interface ProductCardProps {
  product: Product;
  onSelect: (product: Product) => void;
  onVisualize: (product: Product) => void;
}

export function ProductCard({ product, onSelect, onVisualize }: ProductCardProps) {
  const image = product.product_images?.[0]?.image_url;
  return (
    <article className="product-card group" onClick={() => onSelect(product)}>
      <div className="product-image-wrap">
        {image ? <img src={image} alt={product.image_alt ?? product.name ?? product.product_code} loading="lazy" /> : <div className="image-placeholder">Image coming soon</div>}
        <div className="product-badges">
          {product.new_arrival && <span>New</span>}
          {product.featured && <span>Featured</span>}
        </div>
        <button className="card-visualize" onClick={(event) => { event.stopPropagation(); onVisualize(product); }}><Sparkles size={14} /> Visualize</button>
        <div className="product-arrow"><ArrowUpRight size={18} /></div>
      </div>
      <div className="product-info">
        <div><p className="product-code">{product.product_code}</p><h3>{product.name ?? 'Catalogue product'}</h3></div>
        <p className="product-meta">{product.sizes?.[0] ?? product.categories?.name ?? 'Details available in store'}</p>
      </div>
    </article>
  );
}
