package domain.entity;

public class SongArtist {
    private Artist artist;
    private Song song;

    public SongArtist() {
    }

    public SongArtist(Artist artist, Song song) {
        this.artist = artist;
        this.song = song;
    }

    public Artist getArtist() {
        return artist;
    }

    public void setArtist(Artist artist) {
        this.artist = artist;
    }

    public Song getSong() {
        return song;
    }

    public void setSong(Song song) {
        this.song = song;
    }
}
