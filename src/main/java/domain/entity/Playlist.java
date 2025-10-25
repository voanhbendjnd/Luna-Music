package domain.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Playlist {
    private Long id;

    private String name;

    private String description;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
    private String coverImage;

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    private User user;

    private List<PlaylistSong> playlistSongs = new ArrayList<>();

    public Playlist() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Playlist(String name, User user) {
        this();
        this.name = name;
        this.user = user;
    }

    public Playlist(String name, String description, User user, String coverImage) {
        this(name, user);
        this.coverImage = coverImage;
        this.description = description;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<PlaylistSong> getPlaylistSongs() {
        return playlistSongs;
    }

    public void setPlaylistSongs(List<PlaylistSong> playlistSongs) {
        this.playlistSongs = playlistSongs;
    }

    // Helper methods
    public int getSongCount() {
        return playlistSongs.size();
    }

    public String getTotalDuration() {
        int totalSeconds = playlistSongs.stream()
                .mapToInt(ps -> ps.getSong().getDuration())
                .sum();

        int hours = totalSeconds / 3600;
        int minutes = (totalSeconds % 3600) / 60;
        int seconds = totalSeconds % 60;

        if (hours > 0) {
            return String.format("%d:%02d:%02d", hours, minutes, seconds);
        } else {
            return String.format("%d:%02d", minutes, seconds);
        }
    }

    public String getCoverImage() {
        return coverImage;
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    @Override
    public String toString() {
        return "Playlist{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", user=" + (user != null ? user.getName() : "null") +
                ", songCount=" + getSongCount() +
                '}';
    }
}
