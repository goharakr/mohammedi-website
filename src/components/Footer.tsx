import { ArrowUpRight, Instagram, MapPin } from 'lucide-react';

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
          <p><MapPin size={14} /> Kisumu, Kenya</p>
          <p>Phone / WhatsApp<br /><span className="muted">Details coming soon</span></p>
        </div>
        <div>
          <span className="footer-label">Follow the studio</span>
          <button onClick={() => goToSection('contact')}><Instagram size={14} /> Instagram</button>
          <button onClick={() => goToSection('contact')}>Facebook</button>
          <button onClick={() => goToSection('contact')}>Pinterest</button>
        </div>
      </div>
      <div className="footer-bottom">
        <span>© 2026 Mohammedi Gypsum Tiles & Sanitary</span>
        <span>Designed for considered spaces.</span>
      </div>
    </footer>
  );
}
