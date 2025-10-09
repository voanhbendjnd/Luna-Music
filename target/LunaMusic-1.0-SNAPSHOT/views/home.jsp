<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="domain.entity.Song" %>
            <%@ page import="domain.entity.Artist" %>
                <%@ page import="domain.entity.Album" %>

                    <style>
                        .home-container {
                            background-color: #121212;
                            min-height: 100vh;
                            color: white;
                            padding: 20px;
                        }

                        .section {
                            margin-bottom: 40px;
                        }

                        .section-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 20px;
                        }

                        .section-title {
                            font-size: 24px;
                            font-weight: bold;
                            color: white;
                        }

                        .show-all-btn {
                            color: #b3b3b3;
                            text-decoration: none;
                            font-size: 14px;
                        }

                        .show-all-btn:hover {
                            color: white;
                            text-decoration: underline;
                        }

                        .horizontal-scroll {
                            display: flex;
                            overflow-x: auto;
                            gap: 16px;
                            padding: 10px 0;
                            scrollbar-width: none;
                            -ms-overflow-style: none;
                        }

                        .horizontal-scroll::-webkit-scrollbar {
                            display: none;
                        }

                        .song-card {
                            min-width: 180px;
                            background-color: #181818;
                            border-radius: 8px;
                            padding: 16px;
                            cursor: pointer;
                            transition: background-color 0.3s;
                        }

                        .song-card:hover {
                            background-color: #282828;
                        }

                        .song-image {
                            width: 100%;
                            height: 180px;
                            background-color: #333;
                            border-radius: 8px;
                            margin-bottom: 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 48px;
                            color: #b3b3b3;
                        }

                        .song-title {
                            font-size: 16px;
                            font-weight: bold;
                            color: white;
                            margin-bottom: 4px;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .song-artist {
                            font-size: 14px;
                            color: #b3b3b3;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .artist-card {
                            min-width: 150px;
                            text-align: center;
                            cursor: pointer;
                        }

                        .artist-image {
                            width: 150px;
                            height: 150px;
                            border-radius: 50%;
                            background-color: #333;
                            margin: 0 auto 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 48px;
                            color: #b3b3b3;
                        }

                        .artist-name {
                            font-size: 14px;
                            font-weight: bold;
                            color: white;
                            margin-bottom: 4px;
                        }

                        .artist-label {
                            font-size: 12px;
                            color: #b3b3b3;
                        }

                        .album-card {
                            min-width: 180px;
                            background-color: #181818;
                            border-radius: 8px;
                            padding: 16px;
                            cursor: pointer;
                            transition: background-color 0.3s;
                        }

                        .album-card:hover {
                            background-color: #282828;
                        }

                        .album-image {
                            width: 100%;
                            height: 180px;
                            background-color: #333;
                            border-radius: 8px;
                            margin-bottom: 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 48px;
                            color: #b3b3b3;
                        }

                        .album-title {
                            font-size: 16px;
                            font-weight: bold;
                            color: white;
                            margin-bottom: 4px;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .album-artist {
                            font-size: 14px;
                            color: #b3b3b3;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .scroll-arrow {
                            position: absolute;
                            right: 0;
                            top: 50%;
                            transform: translateY(-50%);
                            background-color: rgba(0, 0, 0, 0.7);
                            border: none;
                            color: white;
                            padding: 10px;
                            cursor: pointer;
                            border-radius: 50%;
                            font-size: 18px;
                        }
                    </style>

                    <div class="home-container">
                        <!-- Songs Section -->
                        <div class="section">
                            <div class="section-header">
                                <h2 class="section-title">Songs</h2>
                                <a href="#" class="show-all-btn">Show all</a>
                            </div>
                            <div class="horizontal-scroll" style="position: relative;">
                                <% List<Song> trendingSongs = (List<Song>) request.getAttribute("trendingSongs");
                                        System.out.println("JSP - Trending songs: " + (trendingSongs != null ?
                                        trendingSongs.size() : "null"));
                                        if (trendingSongs != null && !trendingSongs.isEmpty()) {
                                        for (Song song : trendingSongs) {
                                        %>
                                        <div class="song-card" onclick="openSongDetail(<%= song.getId() %>)">
                                            <div class="song-image">
                                                <% if (song.getCoverImage() !=null && !song.getCoverImage().isEmpty()) {
                                                    %>
                                                    <img src="${pageContext.request.contextPath}<%= song.getCoverImage() %>"
                                                        style="width: 100%; height: 100%; object-fit: cover; border-radius: 8px;"
                                                        alt="<%= song.getTitle() %>">
                                                    <% } else { %>
                                                        🎵
                                                        <% } %>
                                            </div>
                                            <div class="song-title">
                                                <%= song.getTitle() %>
                                            </div>
                                            <div class="song-artist">
                                                <% if (song.getSongArtists() !=null && !song.getSongArtists().isEmpty())
                                                    { %>
                                                    <%= song.getSongArtists().get(0).getArtist().getName() %>
                                                        <% } else { %>
                                                            Unknown Artist
                                                            <% } %>
                                            </div>
                                        </div>
                                        <% } } else { %>
                                            <div style="color: #b3b3b3; text-align: center; padding: 40px;">
                                                No songs available. Please check database connection.
                                            </div>
                                            <% } %>
                            </div>
                        </div>

                        <!-- Popular Artists Section -->
                        <div class="section">
                            <div class="section-header">
                                <h2 class="section-title">Popular artists</h2>
                                <a href="#" class="show-all-btn">Show all</a>
                            </div>
                            <div class="horizontal-scroll" style="position: relative;">
                                <% List<Artist> popularArtists = (List<Artist>) request.getAttribute("popularArtists");
                                        System.out.println("JSP - Popular artists: " + (popularArtists != null ?
                                        popularArtists.size() : "null"));
                                        if (popularArtists != null && !popularArtists.isEmpty()) {
                                        for (Artist artist : popularArtists) {
                                        %>
                                        <div class="artist-card" onclick="openArtistDetail(<%= artist.getId() %>)">
                                            <div class="artist-image">
                                                <% if (artist.getImagePath() !=null && !artist.getImagePath().isEmpty())
                                                    { %>
                                                    <img src="${pageContext.request.contextPath}<%= artist.getImagePath() %>"
                                                        style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;"
                                                        alt="<%= artist.getName() %>">
                                                    <% } else { %>
                                                        👤
                                                        <% } %>
                                            </div>
                                            <div class="artist-name">
                                                <%= artist.getName() %>
                                            </div>
                                            <div class="artist-label">Artist</div>
                                        </div>
                                        <% } } else { %>
                                            <div style="color: #b3b3b3; text-align: center; padding: 40px;">
                                                No artists available. Please check database connection.
                                            </div>
                                            <% } %>
                            </div>
                        </div>

                        <!-- Albums Section -->
                        <div class="section">
                            <div class="section-header">
                                <h2 class="section-title">Albums</h2>
                                <a href="#" class="show-all-btn">Show all</a>
                            </div>
                            <div class="horizontal-scroll" style="position: relative;">
                                <% List<Album> albums = (List<Album>) request.getAttribute("albums");
                                        System.out.println("JSP - Albums: " + (albums != null ? albums.size() :
                                        "null"));
                                        if (albums != null && !albums.isEmpty()) {
                                        for (Album album : albums) {
                                        %>
                                        <div class="album-card" onclick="openAlbumDetail(<%= album.getId() %>)">
                                            <div class="album-image">
                                                <% if (album.getCoverImagePath() !=null &&
                                                    !album.getCoverImagePath().isEmpty()) { %>
                                                    <img src="${pageContext.request.contextPath}<%= album.getCoverImagePath() %>"
                                                        style="width: 100%; height: 100%; object-fit: cover; border-radius: 8px;"
                                                        alt="<%= album.getTitle() %>">
                                                    <% } else { %>
                                                        💿
                                                        <% } %>
                                            </div>
                                            <div class="album-title">
                                                <%= album.getTitle() %>
                                            </div>
                                            <div class="album-artist">
                                                <% if (album.getArtist() !=null) { %>
                                                    <%= album.getArtist().getName() %>
                                                        <% } else { %>
                                                            Unknown Artist
                                                            <% } %>
                                            </div>
                                        </div>
                                        <% } } else { %>
                                            <div style="color: #b3b3b3; text-align: center; padding: 40px;">
                                                No albums available. Please check database connection.
                                            </div>
                                            <% } %>
                            </div>
                        </div>
                    </div>

                    <script>
                        function openSongDetail(songId) {
                            // Open song detail modal
                            fetch('/LunaMusic/api/song/' + songId)
                                .then(response => response.json())
                                .then(data => {
                                    showSongDetailModal(data);
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                });
                        }

                        function openArtistDetail(artistId) {
                            // Open artist detail modal
                            fetch('/LunaMusic/api/artist/' + artistId)
                                .then(response => response.json())
                                .then(data => {
                                    showArtistDetailModal(data);
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                });
                        }

                        function openAlbumDetail(albumId) {
                            // Open album detail modal
                            fetch('/LunaMusic/api/album/' + albumId)
                                .then(response => response.json())
                                .then(data => {
                                    showAlbumDetailModal(data);
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                });
                        }

                        function showSongDetailModal(song) {
                            // This will be implemented later
                            console.log('Song detail:', song);
                        }

                        function showArtistDetailModal(artist) {
                            // This will be implemented later
                            console.log('Artist detail:', artist);
                        }

                        function showAlbumDetailModal(album) {
                            // This will be implemented later
                            console.log('Album detail:', album);
                        }
                    </script>