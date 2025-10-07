package domain.entity;

import java.time.Instant;
import java.util.List;

/**
 * Artist entity representing the Artists table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class Artist {
    private Long id;
    private String name;
    private String bio;
    private String imagePath;
    private Instant createdAt;
    private Instant updatedAt;

    // Relationships
    private List<Album> albums;
    private List<SongArtist> songArtists;

    public Artist() {
    }

    public Artist(Long id, String name, String bio, String imagePath, Instant createdAt, Instant updatedAt) {
        this.id = id;
        this.name = name;
        this.bio = bio;
        this.imagePath = imagePath;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Artist(Long id, String name, String bio, String imagePath, Instant createdAt, Instant updatedAt,
            List<Album> albums, List<SongArtist> songArtists) {
        this.id = id;
        this.name = name;
        this.bio = bio;
        this.imagePath = imagePath;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.albums = albums;
        this.songArtists = songArtists;
    }

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
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<Album> getAlbums() {
        return albums;
    }

    public void setAlbums(List<Album> albums) {
        this.albums = albums;
    }

    public List<SongArtist> getSongArtists() {
        return songArtists;
    }

    public void setSongArtists(List<SongArtist> songArtists) {
        this.songArtists = songArtists;
    }

    @Override
    public String toString() {
        return "Artist{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", bio='" + bio + '\'' +
                ", imagePath='" + imagePath + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", albums=" + albums +
                ", songArtists=" + songArtists +
                '}';
    }
}
