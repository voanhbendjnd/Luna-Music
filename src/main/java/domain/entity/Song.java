package domain.entity;

import java.time.Instant;
import java.util.List;

/**
 * Song entity representing the Songs table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class Song {
    private Long id;
    private String title;
    private String filePath;
    private String coverImage; // Cover image path for the song
    private Integer duration; // Duration in seconds
    private Integer playCount;
    private Album album;
    private Genre genre;
    private Instant createdAt;
    private Instant updatedAt;
    private String lyric;
    private List<SongArtist> songArtists;

    public Song() {
    }

    public Song(Long id, String title, String filePath, String coverImage, Integer duration, Integer playCount,
            Album album, Genre genre, String lyric,
            Instant createdAt, Instant updatedAt, List<SongArtist> songArtists) {
        this.id = id;
        this.title = title;
        this.filePath = filePath;
        this.coverImage = coverImage;
        this.duration = duration;
        this.playCount = playCount;
        this.album = album;
        this.genre = genre;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.songArtists = songArtists;
        this.lyric = lyric;
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

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public Integer getPlayCount() {
        return playCount;
    }

    public void setPlayCount(Integer playCount) {
        this.playCount = playCount;
    }

    public List<SongArtist> getSongArtists() {
        return songArtists;
    }

    public void setSongArtists(List<SongArtist> songArtists) {
        this.songArtists = songArtists;
    }

    public Album getAlbum() {
        return album;
    }

    public void setAlbum(Album album) {
        this.album = album;
    }

    public Genre getGenre() {
        return genre;
    }

    public void setGenre(Genre genre) {
        this.genre = genre;
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

    public String getLyric() {
        return lyric;
    }

    public void setLyric(String lyric) {
        this.lyric = lyric;
    }

    /**
     * Helper method to format duration from seconds to MM:SS format
     * 
     * @return formatted duration string
     */
    public String getFormattedDuration() {
        if (duration == null)
            return "00:00";
        int minutes = duration / 60;
        int seconds = duration % 60;
        return String.format("%02d:%02d", minutes, seconds);
    }
}
