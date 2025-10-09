package domain.entity;

import java.time.Instant;
import java.util.List;

/**
 * Album entity representing the Albums table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class Album {
    private Long id;
    private String title;
    private Integer releaseYear;
    private String coverImagePath;
    private Instant createdAt;
    private Integer songCount;
    private String totalDuration;
    // Relationships
    private List<Song> songs;
    private Artist artist;

    public Album() {
    }

    public Album(Long id, String title, Artist artist, Integer releaseYear, String coverImagePath,
            Instant createdAt, List<Song> songs) {
        this.id = id;
        this.title = title;
        this.artist = artist;
        this.releaseYear = releaseYear;
        this.coverImagePath = coverImagePath;
        this.createdAt = createdAt;
        this.songs = songs;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Artist getArtist() {
        return artist;
    }

    public void setArtist(Artist artist) {
        this.artist = artist;
    }

    public Integer getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(Integer releaseYear) {
        this.releaseYear = releaseYear;
    }

    public String getCoverImagePath() {
        return coverImagePath;
    }

    public void setCoverImagePath(String coverImagePath) {
        this.coverImagePath = coverImagePath;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public List<Song> getSongs() {
        return songs;
    }

    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }

    public Integer getSongCount() {
        return songCount;
    }

    public void setSongCount(Integer songCount) {
        this.songCount = songCount;
    }

    public String getTotalDuration() {
        return totalDuration;
    }

    public void setTotalDuration(String totalDuration) {
        this.totalDuration = totalDuration;
    }

    @Override
    public String toString() {
        return "Album{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", artist=" + artist +
                ", releaseYear=" + releaseYear +
                ", coverImagePath='" + coverImagePath + '\'' +
                ", createdAt=" + createdAt +
                ", songs=" + songs +
                '}';
    }
}
