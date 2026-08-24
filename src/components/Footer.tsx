import { ArrowUpRight, Facebook, Instagram, Mail, MapPin, Phone } from 'lucide-react';
import { contact } from '@/data/content';
import { whatsappLink } from '@/lib/whatsapp';

interface FooterProps { onNavigate: (page: string) => void; }

export function Footer({ onNavigate }: FooterProps) {
  const goToSection = (section: string) => {
    onNavigate('home');
    setTimeout(() => {
      document.getElementById(section)?.scrollIntoView({ behavior: 'smooth' });
    }, 100);
  };

  return (
    <footer className="footer">
      <div className="footer-top">
        <div>
          <span className="eyebrow">MOHAMMEDI / 01</span>
          <h2>Make room for<br /><em>better living.</em></h2>
        </div>
        <button className="footer-cta" onClick={() => onNavigate('catalogue')}>Explore the collection <ArrowUpRight size={18} /></button>
      </div>
      <div className="footer-grid">
        <div className="footer-brand">
          <span className="brand-mark">M</span>
          <p>Premium tiles, sanitaryware<br />and complete finishing solutions.</p>
        </div>
        <div>
          <span className="footer-label">Explore</span>
          <button onClick={() => onNavigate('catalogue')}>All products</button>
          <button onClick={() => onNavigate('visualizer')}>AI visualizer</button>
          <button onClick={() => goToSection('inspiration')}>Inspiration</button>
        </div>
        <div id="contact">
          <span className="footer-label">Visit</span>
          <a href={contact.mapsUrl} target="_blank" rel="noopener noreferrer"><MapPin size={14} /> {contact.addressLabel}</a>
          <a href={whatsappLink()} target="_blank" rel="noopener noreferrer"><Phone size={14} /> {contact.phoneDisplay}</a>
          <a href={`mailto:${contact.email}`}><Mail size={14} /> {contact.email}</a>
        </div>
        <div>
          <span className="footer-label">Follow the studio</span>
          <a href={contact.instagramUrl} target="_blank" rel="noopener noreferrer"><Instagram size={14} /> Instagram</a>
          <a href={contact.facebookUrl} target="_blank" rel="noopener noreferrer"><Facebook size={14} /> Facebook</a>
          <a href={whatsappLink()} target="_blank" rel="noopener noreferrer"><Phone size={14} /> WhatsApp</a>
        </div>
      </div>
      <div className="footer-bottom">
        <span>© 2026 Mohammedi Gypsum Tiles & Sanitary</span>
        <span>Designed for considered spaces.</span>
      </div>
    </footer>
  );
}
