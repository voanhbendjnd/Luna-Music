/**
 * Color Extractor Library
 * Extracts dominant colors from images and creates dynamic backgrounds
 */

class ColorExtractor {
  constructor() {
    this.canvas = null;
    this.ctx = null;
    this.initCanvas();
  }

  initCanvas() {
    this.canvas = document.createElement("canvas");
    this.ctx = this.canvas.getContext("2d");
  }

  /**
   * Extract dominant colors from an image
   * @param {HTMLImageElement} img - The image element
   * @param {number} colorCount - Number of colors to extract (default: 5)
   * @returns {Array} Array of color objects with rgb values
   */
  extractColors(img, colorCount = 5) {
    if (!img.complete) {
      return this.getDefaultColors();
    }

    try {
      // Set canvas size to image size (resized for performance)
      const maxSize = 150;
      const ratio = Math.min(
        maxSize / img.naturalWidth,
        maxSize / img.naturalHeight
      );
      this.canvas.width = img.naturalWidth * ratio;
      this.canvas.height = img.naturalHeight * ratio;

      // Draw image to canvas
      this.ctx.drawImage(img, 0, 0, this.canvas.width, this.canvas.height);

      // Get image data
      const imageData = this.ctx.getImageData(
        0,
        0,
        this.canvas.width,
        this.canvas.height
      );
      const data = imageData.data;

      // Extract colors using k-means clustering
      return this.kMeansClustering(data, colorCount);
    } catch (error) {
      console.warn("Error extracting colors:", error);
      return this.getDefaultColors();
    }
  }

  /**
   * K-means clustering to find dominant colors
   * @param {Uint8ClampedArray} data - Image data
   * @param {number} k - Number of clusters
   * @returns {Array} Dominant colors
   */
  kMeansClustering(data, k) {
    const pixels = [];

    // Sample pixels (every 4th pixel for performance)
    for (let i = 0; i < data.length; i += 16) {
      const r = data[i];
      const g = data[i + 1];
      const b = data[i + 2];
      const a = data[i + 3];

      // Skip transparent pixels
      if (a > 128) {
        pixels.push([r, g, b]);
      }
    }

    if (pixels.length === 0) {
      return this.getDefaultColors();
    }

    // Initialize centroids randomly
    const centroids = [];
    for (let i = 0; i < k; i++) {
      const randomPixel = pixels[Math.floor(Math.random() * pixels.length)];
      centroids.push([...randomPixel]);
    }

    // K-means iterations
    for (let iteration = 0; iteration < 10; iteration++) {
      const clusters = Array(k)
        .fill()
        .map(() => []);

      // Assign pixels to nearest centroid
      pixels.forEach((pixel) => {
        let minDistance = Infinity;
        let closestCluster = 0;

        centroids.forEach((centroid, index) => {
          const distance = this.euclideanDistance(pixel, centroid);
          if (distance < minDistance) {
            minDistance = distance;
            closestCluster = index;
          }
        });

        clusters[closestCluster].push(pixel);
      });

      // Update centroids
      let changed = false;
      centroids.forEach((centroid, index) => {
        if (clusters[index].length > 0) {
          const newCentroid = [
            clusters[index].reduce((sum, pixel) => sum + pixel[0], 0) /
              clusters[index].length,
            clusters[index].reduce((sum, pixel) => sum + pixel[1], 0) /
              clusters[index].length,
            clusters[index].reduce((sum, pixel) => sum + pixel[2], 0) /
              clusters[index].length,
          ];

          if (this.euclideanDistance(centroid, newCentroid) > 1) {
            changed = true;
          }

          centroids[index] = newCentroid;
        }
      });

      if (!changed) break;
    }

    // Convert to color objects and sort by frequency
    return centroids
      .map((centroid) => ({
        r: Math.round(centroid[0]),
        g: Math.round(centroid[1]),
        b: Math.round(centroid[2]),
        rgb: `rgb(${Math.round(centroid[0])}, ${Math.round(
          centroid[1]
        )}, ${Math.round(centroid[2])})`,
      }))
      .sort((a, b) => {
        // Sort by brightness (luminance)
        const luminanceA = (0.299 * a.r + 0.587 * a.g + 0.114 * a.b) / 255;
        const luminanceB = (0.299 * b.r + 0.587 * b.g + 0.114 * b.b) / 255;
        return luminanceB - luminanceA;
      });
  }

  /**
   * Calculate Euclidean distance between two color points
   * @param {Array} color1 - First color [r, g, b]
   * @param {Array} color2 - Second color [r, g, b]
   * @returns {number} Distance
   */
  euclideanDistance(color1, color2) {
    return Math.sqrt(
      Math.pow(color1[0] - color2[0], 2) +
        Math.pow(color1[1] - color2[1], 2) +
        Math.pow(color1[2] - color2[2], 2)
    );
  }

  /**
   * Get default colors if extraction fails
   * @returns {Array} Default color palette
   */
  getDefaultColors() {
    return [
      { r: 255, g: 0, b: 64, rgb: "rgb(255, 0, 64)" }, // Red
      { r: 204, g: 0, b: 51, rgb: "rgb(204, 0, 51)" }, // Dark red
      { r: 102, g: 0, b: 25, rgb: "rgb(102, 0, 25)" }, // Very dark red
      { r: 51, g: 0, b: 12, rgb: "rgb(51, 0, 12)" }, // Almost black
      { r: 25, g: 0, b: 6, rgb: "rgb(25, 0, 6)" }, // Black
    ];
  }

  /**
   * Create gradient background from colors
   * @param {Array} colors - Array of color objects
   * @param {string} direction - Gradient direction (default: 'to bottom')
   * @returns {string} CSS gradient string
   */
  createGradient(colors, direction = "to bottom") {
    if (!colors || colors.length === 0) {
      return "linear-gradient(to bottom, rgb(255, 0, 64), rgb(204, 0, 51))";
    }

    // Use the brightest colors for gradient
    const gradientColors = colors.slice(0, 3);
    const stops = gradientColors
      .map((color, index) => {
        const percentage = (index / (gradientColors.length - 1)) * 100;
        return `${color.rgb} ${percentage}%`;
      })
      .join(", ");

    return `linear-gradient(${direction}, ${stops})`;
  }

  /**
   * Create blurred background effect
   * @param {Array} colors - Array of color objects
   * @param {number} blurAmount - Blur amount in pixels (default: 20)
   * @returns {string} CSS background with blur effect
   */
  createBlurredBackground(colors, blurAmount = 20) {
    const gradient = this.createGradient(colors);
    return `${gradient}, radial-gradient(circle at center, rgba(255,255,255,0.1) 0%, rgba(0,0,0,0.3) 100%)`;
  }

  /**
   * Adjust color brightness
   * @param {Object} color - Color object with r, g, b
   * @param {number} factor - Brightness factor (0-2, 1 = no change)
   * @returns {Object} Adjusted color
   */
  adjustBrightness(color, factor) {
    return {
      r: Math.min(255, Math.max(0, Math.round(color.r * factor))),
      g: Math.min(255, Math.max(0, Math.round(color.g * factor))),
      b: Math.min(255, Math.max(0, Math.round(color.b * factor))),
      rgb: `rgb(${Math.min(
        255,
        Math.max(0, Math.round(color.r * factor))
      )}, ${Math.min(
        255,
        Math.max(0, Math.round(color.g * factor))
      )}, ${Math.min(255, Math.max(0, Math.round(color.b * factor)))})`,
    };
  }

  /**
   * Make colors more vibrant
   * @param {Array} colors - Array of color objects
   * @returns {Array} More vibrant colors
   */
  enhanceColors(colors) {
    return colors.map((color) => {
      // Increase saturation and adjust brightness
      const enhanced = this.adjustBrightness(color, 1.2);
      return enhanced;
    });
  }
}

// Global instance
window.colorExtractor = new ColorExtractor();
