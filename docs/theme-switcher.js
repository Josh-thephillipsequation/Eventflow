// Theme Switcher for EventFlow GitHub Pages
const themes = {
  'cyberpunk': {
    name: 'Neon Dreams 2077 ⚡',
    file: 'themes/cyberpunk.css'
  },
  'halloween': {
    name: 'Spooky Pumpkin Patches 🎃',
    file: 'themes/halloween.css'
  },
  'purple': {
    name: 'Purple Gradient',
    file: 'styles.css'
  },
  'cassette': {
    name: 'VHS Analog Tomorrow 📼',
    file: 'themes/cassette-futurism.css'
  },
  'google': {
    name: 'Material You Zen ✨',
    file: 'themes/google-workspace.css'
  },
  'hipster': {
    name: 'Artisanal Pixels Organic ☕',
    file: 'themes/tech-hipster.css'
  },
  'miami': {
    name: 'Miami 1988 🌴',
    file: 'themes/miami-1988.css'
  }
};

// Get or set the current theme
function getCurrentTheme() {
  return localStorage.getItem('eventflow-theme') || 'cyberpunk';
}

function setTheme(themeId) {
  const theme = themes[themeId];
  if (!theme) return;
  
  // Update the stylesheet link
  let themeLink = document.getElementById('theme-stylesheet');
  if (!themeLink) {
    themeLink = document.createElement('link');
    themeLink.id = 'theme-stylesheet';
    themeLink.rel = 'stylesheet';
    document.head.appendChild(themeLink);
  }
  
  themeLink.href = theme.file;
  
  // Save to localStorage
  localStorage.setItem('eventflow-theme', themeId);
  
  // Update dropdown if it exists
  const selector = document.getElementById('theme-selector');
  if (selector) {
    selector.value = themeId;
  }
}

// Initialize theme on page load
document.addEventListener('DOMContentLoaded', () => {
  // Create floating theme selector widget
  const themeWidget = document.createElement('div');
  themeWidget.className = 'theme-widget';
  themeWidget.innerHTML = `
    <button class="theme-widget-toggle" aria-label="Toggle theme selector">
      <span class="theme-widget-toggle-icon">🎨</span>
    </button>
    <div class="theme-widget-content">
      <div class="theme-widget-header">
        <span class="theme-widget-icon">🎨</span>
        <span class="theme-widget-title">Choose Theme</span>
        <button class="theme-widget-close" aria-label="Close theme selector">×</button>
      </div>
      <select id="theme-selector" class="theme-selector" aria-label="Select site theme">
        ${Object.entries(themes).map(([id, theme]) => 
          `<option value="${id}">${theme.name}</option>`
        ).join('')}
      </select>
    </div>
  `;
  
  document.body.appendChild(themeWidget);
  
  // Toggle widget open/close
  const toggleBtn = themeWidget.querySelector('.theme-widget-toggle');
  const closeBtn = themeWidget.querySelector('.theme-widget-close');
  const content = themeWidget.querySelector('.theme-widget-content');
  
  toggleBtn.addEventListener('click', () => {
    themeWidget.classList.toggle('theme-widget-open');
  });
  
  closeBtn.addEventListener('click', () => {
    themeWidget.classList.remove('theme-widget-open');
  });
  
  // Add change event listener
  const selector = document.getElementById('theme-selector');
  selector.addEventListener('change', (e) => {
    setTheme(e.target.value);
  });
  
  // Apply saved theme or default
  const currentTheme = getCurrentTheme();
  setTheme(currentTheme);
});
