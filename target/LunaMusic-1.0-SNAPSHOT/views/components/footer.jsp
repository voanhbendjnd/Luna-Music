<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">

<footer class="footer-main" style="border-top: 1px solid rgb(0, 0, 0);">
    <div class="footer-content">
        <div class="footer-columns" style="padding: 0 2rem;">
            <!-- Company Column -->
            <div class="footer-column">
                <h5>Company</h5>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Jobs</a></li>
                    <li><a href="https://github.com/voanhbendjnd">For the Record</a></li>
                </ul>
            </div>

            <!-- Communities Column -->
            <div class="footer-column">
                <h5>Communities</h5>
                <ul>
                    <li><a href="https://github.com/voanhbendjnd">For Artists</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Developers</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Advertising</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Investors</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Vendors</a></li>
                </ul>
            </div>

            <!-- Useful Links Column -->
            <div class="footer-column">
                <h5>Useful links</h5>
                <ul>
                    <li><a href="https://github.com/voanhbendjnd">Support</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Free Mobile App</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Popular by Country</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin">Import your music</a></li>
                </ul>
            </div>

            <!-- Luna Plans Column -->
            <div class="footer-column">
                <h5>Luna Plans</h5>
                <ul>
                    <li><a href="https://github.com/voanhbendjnd">Premium Individual</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Premium Student</a></li>
                    <li><a href="https://github.com/voanhbendjnd">Luna Free</a></li>
                </ul>
            </div>
        </div>

        <!-- Social Media Icons -->
        <div class="social-media">
            <a href="https://github.com/voanhbendjnd" class="social-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-github"
                    viewBox="0 0 16 16">
                    <path
                        d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8" />
                </svg>
            </a>
            <a href="https://www.facebook.com/voanhbendjnd" class="social-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
                    <path
                        d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                </svg>
            </a>
        </div>

        <!-- Separator Line -->
        <hr class="footer-separator">

        <!-- Copyright Section -->
        <div class="footer-copyright">
            <p class="copyright-text">
                <%= java.time.Year.now() %> Luna Music
            </p>
        </div>
    </div>
</footer>