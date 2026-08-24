import { contact } from '@/data/content';
import type { Product } from '@/types/catalogue';

export function createWhatsAppMessage(product?: Product, request = 'I would like to ask about this product.') {
  const productLine = product ? `Product: ${product.name ?? 'Catalogue product'} (${product.product_code})` : '';
  return `Hello Mohammedi Gypsum Tiles & Sanitary,\n${productLine}\n${request}`;
}

export function whatsappLink(product?: Product, request?: string) {
  return `https://wa.me/${contact.whatsapp}?text=${encodeURIComponent(createWhatsAppMessage(product, request))}`;
}
