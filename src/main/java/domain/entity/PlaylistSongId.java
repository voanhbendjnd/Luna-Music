package domain.entity;

import java.io.Serializable;
import java.util.Objects;

public class PlaylistSongId implements Serializable {
    private Long playlistId;
    private Long songId;

    // Default constructor
    public PlaylistSongId() {
    }

    // Constructor with parameters
    public PlaylistSongId(Long playlistId, Long songId) {
        this.playlistId = playlistId;
        this.songId = songId;
    }

    // Getters and Setters
    public Long getPlaylistId() {
        return playlistId;
    }

    public void setPlaylistId(Long playlistId) {
        this.playlistId = playlistId;
    }

    public Long getSongId() {
        return songId;
    }

    public void setSongId(Long songId) {
        this.songId = songId;
    }

    // Override equals and hashCode for composite key
    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        PlaylistSongId that = (PlaylistSongId) o;
        return playlistId == that.playlistId && songId == that.songId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(playlistId, songId);
    }

    @Override
    public String toString() {
        return "PlaylistSongId{" +
                "playlistId=" + playlistId +
                ", songId=" + songId +
                '}';
    }
}
