/**
 * Dynamic Background Manager
 * Applies dynamic backgrounds based on album cover colors
 */

class DynamicBackgroundManager {
  constructor() {
    this.colorExtractor = window.colorExtractor;
    this.currentColors = null;
    this.isProcessing = false;
  }

  /**
   * Initialize dynamic background for song detail page
   */
  init() {
    const albumCover = document.querySelector(".album-cover");
    if (albumCover) {
      this.applyDynamicBackground(albumCover);
    }
  }

  /**
   * Apply dynamic background based on album cover
   * @param {HTMLImageElement} albumCover - The album cover image
   */
  applyDynamicBackground(albumCover) {
    if (this.isProcessing) return;

    this.isProcessing = true;

    // Wait for image to load
    if (!albumCover.complete) {
      albumCover.addEventListener("load", () => {
        this.processImage(albumCover);
      });
    } else {
      this.processImage(albumCover);
    }
  }

  /**
   * Process the image and apply background
   * @param {HTMLImageElement} img - The image element
   */
  processImage(img) {
    try {
      // Extract colors from image
      const colors = this.colorExtractor.extractColors(img, 5);
      this.currentColors = colors;

      // Enhance colors for better visual effect
      const enhancedColors = this.colorExtractor.enhanceColors(colors);

      // Apply background to song detail section
      this.applyBackgroundToSection(enhancedColors);

      // Add smooth transition
      this.addTransitionEffect();
    } catch (error) {
      console.warn("Error processing image for dynamic background:", error);
      this.applyDefaultBackground();
    } finally {
      this.isProcessing = false;
    }
  }

  /**
   * Apply background to the song detail section
   * @param {Array} colors - Array of color objects
   */
  applyBackgroundToSection(colors) {
    const songDetailSection = document.querySelector(".song-detail-section");
    if (!songDetailSection) return;

    // Create gradient background
    const gradient = this.colorExtractor.createGradient(colors, "180deg");

    // Create blurred overlay effect
    const overlayGradient = this.createOverlayGradient(colors);

    // Apply the background
    songDetailSection.style.background = `${gradient}, ${overlayGradient}`;
    songDetailSection.style.backgroundBlendMode = "multiply";

    // Add some additional styling for better effect
    songDetailSection.style.position = "relative";
    songDetailSection.style.overflow = "hidden";

    // Add subtle animation
    this.addSubtleAnimation(songDetailSection);
  }

  /**
   * Create overlay gradient for depth effect
   * @param {Array} colors - Array of color objects
   * @returns {string} CSS gradient for overlay
   */
  createOverlayGradient(colors) {
    const primaryColor = colors[0];
    const secondaryColor = colors[1] || colors[0];

    // Create radial gradient overlay
    return `radial-gradient(circle at 30% 20%, 
                rgba(${primaryColor.r}, ${primaryColor.g}, ${primaryColor.b}, 0.3) 0%, 
                rgba(${secondaryColor.r}, ${secondaryColor.g}, ${secondaryColor.b}, 0.1) 50%, 
                rgba(0, 0, 0, 0.4) 100%)`;
  }

  /**
   * Add smooth transition effect
   */
  addTransitionEffect() {
    const songDetailSection = document.querySelector(".song-detail-section");
    if (songDetailSection) {
      songDetailSection.style.transition = "background 1.5s ease-in-out";
    }
  }

  /**
   * Add subtle animation to the background
   * @param {HTMLElement} element - The element to animate
   */
  addSubtleAnimation(element) {
    // Create animated overlay
    const animatedOverlay = document.createElement("div");
    animatedOverlay.className = "animated-background-overlay";
    animatedOverlay.style.cssText = `
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at 50% 50%, 
                rgba(255, 255, 255, 0.1) 0%, 
                rgba(255, 255, 255, 0.05) 30%, 
                transparent 70%);
            animation: backgroundPulse 8s ease-in-out infinite;
            pointer-events: none;
            z-index: 1;
        `;

    // Add CSS animation if not already added
    if (!document.querySelector("#background-animation-styles")) {
      const style = document.createElement("style");
      style.id = "background-animation-styles";
      style.textContent = `
                @keyframes backgroundPulse {
                    0%, 100% { opacity: 0.3; transform: scale(1); }
                    50% { opacity: 0.6; transform: scale(1.05); }
                }
                
                .song-detail-section {
                    position: relative;
                }
                
                .song-detail-section > * {
                    position: relative;
                    z-index: 2;
                }
            `;
      document.head.appendChild(style);
    }

    element.appendChild(animatedOverlay);
  }

  /**
   * Apply default background if processing fails
   */
  applyDefaultBackground() {
    const songDetailSection = document.querySelector(".song-detail-section");
    if (songDetailSection) {
      songDetailSection.style.background =
        "linear-gradient(180deg, #ff0040 0%, #cc0033 100%)";
    }
  }

  /**
   * Update background when song changes
   * @param {HTMLImageElement} newAlbumCover - New album cover image
   */
  updateBackground(newAlbumCover) {
    // Remove existing animated overlay
    const existingOverlay = document.querySelector(
      ".animated-background-overlay"
    );
    if (existingOverlay) {
      existingOverlay.remove();
    }

    // Apply new background
    this.applyDynamicBackground(newAlbumCover);
  }

  /**
   * Get current extracted colors
   * @returns {Array|null} Current colors or null
   */
  getCurrentColors() {
    return this.currentColors;
  }

  /**
   * Create color palette display (for debugging/development)
   * @returns {HTMLElement} Color palette element
   */
  createColorPalette() {
    if (!this.currentColors) return null;

    const palette = document.createElement("div");
    palette.className = "color-palette";
    palette.style.cssText = `
            position: fixed;
            top: 10px;
            right: 10px;
            display: flex;
            gap: 5px;
            z-index: 9999;
            padding: 10px;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 8px;
        `;

    this.currentColors.forEach((color) => {
      const colorBox = document.createElement("div");
      colorBox.style.cssText = `
                width: 30px;
                height: 30px;
                background: ${color.rgb};
                border-radius: 4px;
                border: 1px solid rgba(255, 255, 255, 0.3);
            `;
      colorBox.title = color.rgb;
      palette.appendChild(colorBox);
    });

    return palette;
  }
}

// Initialize when DOM is ready
document.addEventListener("DOMContentLoaded", function () {
  // Check if we're on song detail page
  if (document.querySelector(".song-detail-section")) {
    window.dynamicBackgroundManager = new DynamicBackgroundManager();
    window.dynamicBackgroundManager.init();

    // Remove any existing color palette
    const existingPalette = document.querySelector(".color-palette");
    if (existingPalette) {
      existingPalette.remove();
    }

    // Color palette debug is disabled
    // Uncomment the code below if you want to enable it for development
    /*
    if (
      window.location.hostname === "localhost" ||
      window.location.hostname === "127.0.0.1"
    ) {
      setTimeout(() => {
        const palette = window.dynamicBackgroundManager.createColorPalette();
        if (palette) {
          document.body.appendChild(palette);
        }
      }, 2000);
    }
    */
  }
});
