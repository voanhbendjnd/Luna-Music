package DALs;

import domain.entity.Playlist;
import domain.entity.PlaylistSong;
import domain.entity.Song;
import domain.entity.User;
import utils.DatabaseConfig;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PlaylistDAO extends DatabaseConfig {

    public PlaylistDAO() {
        super();
    }

    public boolean updateCoverImage(String coverImage, Long id) {
        try {
            var sql = "update Playlists set coverImage = ? where id = ?";
            System.out.println(sql);
            var ps = connection.prepareStatement(sql);
            ps.setString(1, coverImage);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            return false;
        }
    }

    // Create a new playlist
    public Playlist createPlaylist(Playlist playlist) {
        String sql = "INSERT INTO Playlists (name, user_id, description, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, playlist.getName());
            ps.setLong(2, playlist.getUser().getId());
            ps.setString(3, playlist.getDescription());
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        playlist.setId(generatedKeys.getLong(1));
                        return playlist;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Playlist findById(Long id) {
        try {
            var sql = "select * from Playlists where id = ?";
            var ps = connection.prepareStatement(sql);
            var rs = ps.executeQuery();
            if (rs.next()) {
                var playlist = new Playlist();
                playlist.setName(rs.getString("name"));
                playlist.setId(rs.getLong("id"));
                String coverImage = rs.getString("coverImage");
                if (coverImage != null) {
                    playlist.setCoverImage(coverImage);
                }
                return playlist;
            }
        } catch (SQLException ex) {
            return null;
        }
        return null;
    }

    public List<Playlist> getPlayListOfUser(Long userID) {
        List<Playlist> playlists = new ArrayList<>();
        try {
            var sql = "select id, name, coverImage from Playlists where user_id = ?";
            var ps = connection.prepareStatement(sql);
            ps.setLong(1, userID);
            var rs = ps.executeQuery();
            while (rs.next()) {
                var pl = new Playlist();
                String coverImage = rs.getString("coverImage");
                if (coverImage != null && !coverImage.equals("")) {
                    pl.setCoverImage(coverImage);
                } else {
                    pl.setCoverImage(null);
                }
                pl.setId(rs.getLong("id"));
                pl.setName(rs.getString("name"));
                playlists.add(pl);
            }
            return playlists;
        } catch (SQLException ex) {
            return null;
        }
    }

    // Get playlist by ID
    public Playlist getPlaylistById(Long id) {
        String sql = "SELECT p.*, u.name as user_name FROM Playlists p " +
                "JOIN Users u ON p.user_id = u.id WHERE p.id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPlaylist(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all playlists for a user
    public List<Playlist> getPlaylistsByUserId(Long userId) {
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT p.*, u.name as user_name FROM Playlists p " +
                "JOIN Users u ON p.user_id = u.id WHERE p.user_id = ? ORDER BY p.updatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    playlists.add(mapResultSetToPlaylist(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return playlists;
    }

    public List<Playlist> getPlaylistsByID(Long id) {
        var sql = "SELECT p.*, u.name as user_name FROM Playlists p " +
                "JOIN Users u ON p.user_id = u.id WHERE p.user_id = ? ORDER BY p.updatedAt DESC";
        try {
            var ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            var rs = ps.executeQuery();
            var playlists = new ArrayList<Playlist>();
            while (rs.next()) {
                var playlist = mapResultSetToPlaylist(rs);
                playlists.add(playlist);
            }
            return playlists;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    // Get all playlists for a user with songs loaded
    public List<Playlist> getPlaylistsByUserIdWithSongs(Long userId) {
        List<Playlist> playlists = getPlaylistsByUserId(userId);

        // Load songs for each playlist
        for (Playlist playlist : playlists) {
            List<Song> songs = getSongsInPlaylist(playlist.getId());
            // Create PlaylistSong objects for the playlist
            List<PlaylistSong> playlistSongList = new ArrayList<>();
            for (Song song : songs) {
                PlaylistSong playlistSong = new PlaylistSong();
                playlistSong.setSong(song);
                playlistSong.setPlaylist(playlist);
                playlistSongList.add(playlistSong);
            }
            playlist.setPlaylistSongs(playlistSongList);
        }

        return playlists;
    }

    // Get all playlists
    public List<Playlist> getAllPlaylists() {
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT p.*, u.name as user_name FROM Playlists p " +
                "JOIN Users u ON p.user_id = u.id ORDER BY p.updatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    playlists.add(mapResultSetToPlaylist(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return playlists;
    }

    // Update playlist
    public Playlist updatePlaylist(Playlist playlist) {
        String sql = "UPDATE Playlists SET name = ?, description = ?, updatedAt = ? WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, playlist.getName());
            ps.setString(2, playlist.getDescription());
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setLong(4, playlist.getId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return playlist;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Delete playlist
    public boolean deletePlaylist(Long id) {
        String sql = "DELETE FROM Playlists WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Add song to playlist
    public boolean addSongToPlaylist(Long playlistId, Long songId) {
        // Check if song is already in playlist
        String checkSql = "SELECT COUNT(*) FROM PlaylistSongs WHERE playlist_id = ? AND song_id = ?";

        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setLong(1, playlistId);
            checkPs.setLong(2, songId);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Song already exists in playlist
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Add song to playlist
        String sql = "INSERT INTO PlaylistSongs (playlist_id, song_id, added_at) VALUES (?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, playlistId);
            ps.setLong(2, songId);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Remove song from playlist
    public boolean removeSongFromPlaylist(Long playlistId, Long songId) {
        String sql = "DELETE FROM PlaylistSongs WHERE playlist_id = ? AND song_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, playlistId);
            ps.setLong(2, songId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get songs in playlist
    public List<Song> getSongsInPlaylist(Long playlistId) {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT s.*, a.title as album_title, g.name as genre_name " +
                "FROM Songs s " +
                "JOIN PlaylistSongs ps ON s.id = ps.song_id " +
                "LEFT JOIN Albums a ON s.album_id = a.id " +
                "LEFT JOIN Genres g ON s.genre_id = g.id " +
                "WHERE ps.playlist_id = ? ORDER BY ps.added_at ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, playlistId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    songs.add(mapResultSetToSong(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return songs;
    }

    // Get playlist with songs (for detail view)
    public Playlist getPlaylistWithSongs(Long playlistId) {
        Playlist playlist = getPlaylistById(playlistId);
        if (playlist != null) {
            List<Song> songs = getSongsInPlaylist(playlistId);
            // Note: In JDBC approach, we don't have automatic relationship mapping
            // The songs will be loaded separately in the controller
        }
        return playlist;
    }

    // Search playlists by name
    public List<Playlist> searchPlaylistsByName(String name) {
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT p.*, u.name as user_name FROM Playlists p " +
                "JOIN Users u ON p.user_id = u.id " +
                "WHERE LOWER(p.name) LIKE LOWER(?) ORDER BY p.updatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    playlists.add(mapResultSetToPlaylist(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return playlists;
    }

    // Get public playlists (excluding current user's playlists)
    public List<Playlist> getPublicPlaylists() {
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT TOP 20 p.*, u.name as user_name FROM Playlists p " +
                "JOIN Users u ON p.user_id = u.id ORDER BY p.updatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    playlists.add(mapResultSetToPlaylist(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return playlists;
    }

    // Get public playlists excluding specific user
    public List<Playlist> getPublicPlaylistsExcludingUser(Long excludeUserId) {
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT TOP 20 p.*, u.name as user_name FROM Playlists p " +
                "JOIN Users u ON p.user_id = u.id " +
                "WHERE p.user_id != ? ORDER BY p.updatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, excludeUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    playlists.add(mapResultSetToPlaylist(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return playlists;
    }

    // Helper method to map ResultSet to Playlist
    private Playlist mapResultSetToPlaylist(ResultSet rs) throws SQLException {
        Playlist playlist = new Playlist();
        playlist.setId(rs.getLong("id"));
        playlist.setName(rs.getString("name"));
        String coverImage = rs.getString("coverImage");
        if (coverImage != null && !coverImage.equals("")) {
            playlist.setCoverImage(coverImage);
        } else {
            playlist.setCoverImage(null);
        }
        playlist.setDescription(rs.getString("description"));
        playlist.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        playlist.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());

        // Create user object
        User user = new User();
        user.setId(rs.getLong("user_id"));
        user.setName(rs.getString("user_name"));
        playlist.setUser(user);

        return playlist;
    }

    // Helper method to map ResultSet to Song
    private Song mapResultSetToSong(ResultSet rs) throws SQLException {
        Song song = new Song();
        song.setId(rs.getLong("id"));
        song.setTitle(rs.getString("title"));
        song.setFilePath(rs.getString("file_path"));
        song.setCoverImage(rs.getString("coverImage"));
        song.setDuration(rs.getInt("duration"));
        song.setPlayCount(rs.getInt("play_count"));
        song.setLyric(rs.getString("lyric"));

        if (rs.getTimestamp("createdAt") != null) {
            song.setCreatedAt(rs.getTimestamp("createdAt").toInstant());
        }
        if (rs.getTimestamp("updatedAt") != null) {
            song.setUpdatedAt(rs.getTimestamp("updatedAt").toInstant());
        }

        return song;
    }
}