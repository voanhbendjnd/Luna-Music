package filters;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication Filter - Controls access to protected resources
 * 
 * Rules:
 * - Home, login, register, and related features (music, album, artist, song)
 * are public
 * - Admin pages require login and admin role (role_id = 1)
 * - Playlist pages require login
 */
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Debug log
        System.out.println("Filter: Request URI = " + requestURI);
        System.out.println("Filter: Context Path = " + contextPath);
        System.out.println("Filter: Path = " + path);

        // Get session
        HttpSession session = httpRequest.getSession(false);

        // Public paths that don't require authentication
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in - redirect to login
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // Check admin access
        if (path.startsWith("/admin")) {
            Object role = session.getAttribute("role");
            if (role == null || !role.equals("ADMIN-LUNA")) {
                // Not admin - redirect to home
                httpResponse.sendRedirect(contextPath + "/home");
                return;
            }
        }

        // User is logged in and has proper permissions
        chain.doFilter(request, response);
    }

    /**
     * Check if the path is public (doesn't require authentication)
     */
    private boolean isPublicPath(String path) {
        // Exact matches
        if (path.equals("/") ||
                path.equals("/home") ||
                path.equals("/login") ||
                path.equals("/register") ||
                path.equals("/logout")) {
            return true;
        }

        // Paths that start with these patterns
        if (path.startsWith("/song-detail") ||
                path.startsWith("/album-detail") ||
                path.startsWith("/artist-detail") ||
                path.startsWith("/song") ||
                path.startsWith("/album") ||
                path.startsWith("/artist") ||
                path.startsWith("/assets/") ||
                path.startsWith("/uploads/") ||
                path.startsWith("/music/")) {
            return true;
        }

        // Static resources
        if (path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".png") ||
                path.endsWith(".jpg") ||
                path.endsWith(".jpeg") ||
                path.endsWith(".gif") ||
                path.endsWith(".ico") ||
                path.endsWith(".mp3") ||
                path.endsWith(".m4a") ||
                path.endsWith(".wav")) {
            return true;
        }

        return false;
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
