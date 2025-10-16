package domain.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "PlaylistSongs")
@IdClass(PlaylistSongId.class)
public class PlaylistSong {
    @Id
    @Column(name = "playlist_id")
    private Long playlistId;

    @Id
    @Column(name = "song_id")
    private Long songId;

    @Column(name = "added_at")
    private LocalDateTime addedAt;

    @Column(name = "coverImage")
    private String coverImage;

    // Many-to-One relationship with Playlist
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "playlist_id", insertable = false, updatable = false)
    private Playlist playlist;

    // Many-to-One relationship with Song
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "song_id", insertable = false, updatable = false)
    private Song song;

    // Constructors
    public PlaylistSong() {
        this.addedAt = LocalDateTime.now();
    }

    public PlaylistSong(Long playlistId, Long songId) {
        this();
        this.playlistId = playlistId;
        this.songId = songId;
    }

    public PlaylistSong(Playlist playlist, Song song) {
        this();
        this.playlist = playlist;
        this.song = song;
        this.playlistId = playlist.getId();
        this.songId = song.getId();
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

    public LocalDateTime getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public Playlist getPlaylist() {
        return playlist;
    }

    public void setPlaylist(Playlist playlist) {
        this.playlist = playlist;
        if (playlist != null) {
            this.playlistId = playlist.getId();
        }
    }

    public Song getSong() {
        return song;
    }

    public void setSong(Song song) {
        this.song = song;
        if (song != null) {
            this.songId = song.getId();
        }
    }

    @Override
    public String toString() {
        return "PlaylistSong{" +
                "playlistId=" + playlistId +
                ", songId=" + songId +
                ", addedAt=" + addedAt +
                ", playlist=" + (playlist != null ? playlist.getName() : "null") +
                ", song=" + (song != null ? song.getTitle() : "null") +
                '}';
    }
}
