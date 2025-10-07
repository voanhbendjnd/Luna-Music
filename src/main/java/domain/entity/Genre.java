package domain.entity;

import java.util.List;

/**
 * Genre entity representing the Genres table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class Genre {
    private Long id;
    private String name;
    private String description;

    // Relationships
    private List<Song> songs;

    public Genre() {
    }

    public Genre(Long id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public Genre(Long id, String name, String description, List<Song> songs) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.songs = songs;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Song> getSongs() {
        return songs;
    }

    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }

    @Override
    public String toString() {
        return "Genre{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", songs=" + songs +
                '}';
    }
}
