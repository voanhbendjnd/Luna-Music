package domain.response;

import domain.entity.Album;
import domain.entity.Artist;
import domain.entity.Song;

import java.util.List;

public class ResSearch {
    private List<Song> songs;
    private List<Artist> artists;
    private List<Album> albums;
    public ResSearch(){}
    public ResSearch(List<Song> songs, List<Artist> artists, List<Album> albums) {
        this.songs = songs;
        this.artists = artists;
        this.albums = albums;
    }

    public List<Song> getSongs() {
        return songs;
    }

    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }

    public List<Artist> getArtists() {
        return artists;
    }

    public void setArtist(List<Artist> artists) {
        this.artists = artists;
    }

    public List<Album> getAlbums() {
        return albums;
    }

    public void setAlbums(List<Album> albums) {
        this.albums = albums;
    }
}
