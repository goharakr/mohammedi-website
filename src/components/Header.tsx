import { Calculator, Menu, Search, Sparkles, X } from 'lucide-react';
import { useState } from 'react';

interface HeaderProps { onNavigate: (page: string) => void; }

export function Header({ onNavigate }: HeaderProps) {
  const [open, setOpen] = useState(false);

  const navigate = (page: string) => {
    onNavigate(page);
    setOpen(false);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const goToSection = (section: string) => {
    onNavigate('home');
    setOpen(false);
    setTimeout(() => {
      document.getElementById(section)?.scrollIntoView({ behavior: 'smooth' });
    }, 100);
  };

  return (
    <>
      <header className="site-header">
        <button className="brand" onClick={() => navigate('home')}>
          <span className="brand-mark">M</span>
          <span><strong>MOHAMMEDI</strong><small>GYPSUM · TILES · SANITARY</small></span>
        </button>
        <nav className="desktop-nav">
          <button onClick={() => navigate('home')}>Home</button>
          <button onClick={() => navigate('catalogue')}>Collection</button>
          <button onClick={() => navigate('visualizer')}>AI Studio</button>
          <button onClick={() => goToSection('about')}>Our story</button>
          <button onClick={() => goToSection('contact')}>Visit us</button>
        </nav>
        <div className="header-actions">
          <button className="icon-button" aria-label="Search" onClick={() => navigate('catalogue')}><Search size={18} /></button>
          <button className="visualizer-link" onClick={() => goToSection('calculator')}><Calculator size={15} /> Tile calculator</button>
          <button className="visualizer-link" onClick={() => navigate('visualizer')}><Sparkles size={15} /> Visualize your room</button>
          <button className="menu-button" aria-label="Open menu" onClick={() => setOpen(true)}><Menu size={22} /></button>
        </div>
      </header>
      {open && (
        <div className="mobile-menu">
          <div className="mobile-menu-top">
            <button className="brand" onClick={() => navigate('home')}>
              <span className="brand-mark">M</span>
              <span><strong>MOHAMMEDI</strong><small>GYPSUM · TILES · SANITARY</small></span>
            </button>
            <button className="icon-button" onClick={() => setOpen(false)}><X size={22} /></button>
          </div>
          <div className="mobile-links">
            <button onClick={() => navigate('home')}>Home <span>01</span></button>
            <button onClick={() => navigate('catalogue')}>Explore collection <span>02</span></button>
            <button onClick={() => navigate('visualizer')}>AI studio <span>03</span></button>
            <button onClick={() => goToSection('calculator')}>Tile calculator <span>04</span></button>
            <button onClick={() => goToSection('about')}>Our story <span>05</span></button>
            <button onClick={() => goToSection('contact')}>Contact <span>06</span></button>
          </div>
          <div className="mobile-menu-foot">Kisumu, Kenya<br /><span>Complete building solutions.</span></div>
        </div>
      )}
    </>
  );
}
