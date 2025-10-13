# JPA Hibernate Setup Guide - Luna Music

## Tổng quan

Dự án Luna Music đã được cấu hình để sử dụng JPA Hibernate thay vì JDBC truyền thống. Điều này mang lại nhiều lợi ích:

- **Object-Relational Mapping (ORM)**: Mapping tự động giữa Java objects và database tables
- **Type Safety**: Sử dụng JPQL thay vì SQL strings
- **Automatic Schema Management**: Tự động tạo/cập nhật database schema
- **Better Performance**: Connection pooling và caching
- **Easier Maintenance**: Code dễ đọc và maintain hơn

## Cấu hình đã thực hiện

### 1. Dependencies (pom.xml)

```xml
<!-- Hibernate dependencies -->
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>6.4.1.Final</version>
</dependency>
<dependency>
    <groupId>jakarta.persistence</groupId>
    <artifactId>jakarta.persistence-api</artifactId>
    <version>3.1.0</version>
</dependency>
```

**Lưu ý**: Trong Hibernate 6.x, `hibernate-entitymanager` đã được merge vào `hibernate-core`, không cần thêm dependency này nữa.

### 2. Persistence Configuration (persistence.xml)

- Persistence Unit: `luna_music_pu`
- Database: SQL Server (LunaMusicPro)
- Auto schema update: `hibernate.hbm2ddl.auto = update`
- SQL logging enabled

### 3. Entity Annotations

Tất cả entity classes đã được thêm JPA annotations:

- `@Entity`: Đánh dấu class là entity
- `@Table`: Chỉ định tên table
- `@Id`: Primary key
- `@GeneratedValue`: Auto-generated ID
- `@Column`: Column mapping
- `@ManyToOne`, `@OneToMany`: Relationship mapping
- `@Enumerated`: Enum mapping

### 4. HibernateUtil Class

Utility class để quản lý EntityManager:

- Thread-safe EntityManager
- Transaction management
- Connection pooling

### 5. DAO Classes

- `UserDAO.java`: Đã được cập nhật để sử dụng JPA Hibernate
- `UserDAOJPA.java`: Ví dụ DAO sử dụng JPA (backup)
- Có thể tạo thêm các DAO khác theo pattern tương tự

## Cách sử dụng

### 1. Khởi tạo EntityManager

```java
EntityManager em = HibernateUtil.getEntityManager();
```

### 2. CRUD Operations

#### Create

```java
User user = new User();
user.setName("John Doe");
user.setEmail("john@example.com");
// ... set other fields

UserDAO userDAO = new UserDAO();
boolean success = userDAO.create(user);
```

#### Read

```java
UserDAO userDAO = new UserDAO();

// Find by ID
User user = userDAO.findById(1L);

// Find by email
User user = userDAO.findByEmail("john@example.com");

// Find all with search
List<User> users = userDAO.findAll("john");

// Find active users
List<User> activeUsers = userDAO.findActiveUsers();

// Find by gender
List<User> maleUsers = userDAO.findByGender(GenderEnum.MALE);

// Find by role
List<User> adminUsers = userDAO.findByRole(1L);

// Count users
long userCount = userDAO.count();

// Check email exists
boolean emailExists = userDAO.emailExists("john@example.com");
```

#### Update

```java
User user = userDAO.findById(1L);
user.setName("Updated Name");
boolean success = userDAO.update(user);
```

#### Delete

```java
boolean success = userDAO.delete(1L);
```

### 3. JPQL Queries

```java
EntityManager em = HibernateUtil.getEntityManager();
TypedQuery<User> query = em.createQuery(
    "SELECT u FROM User u WHERE u.active = :active",
    User.class
);
query.setParameter("active", true);
List<User> activeUsers = query.getResultList();
```

### 4. Transaction Management

```java
HibernateUtil.executeInTransaction(() -> {
    // Multiple operations here
    userDAO.create(user1);
    userDAO.update(user2);
});
```

## Migration từ JDBC sang JPA

### 1. Thay thế DAO Classes

- Tạo DAO mới sử dụng JPA (như `UserDAOJPA`)
- Giữ nguyên interface public methods
- Thay thế dần từng DAO

### 2. Update Controllers

```java
// Old way
UserDAO userDAO = new UserDAO();

// New way
UserDAO userDAO = new UserDAO();
```

### 3. Entity Relationships

- `@ManyToOne`: User -> Role (EAGER fetch)
- `@OneToMany`: Role -> Users (LAZY fetch, PERSIST/MERGE cascade)
- `@ManyToOne`: Song -> Album, Song -> Genre (EAGER fetch)
- `@OneToMany`: Album -> Songs, Genre -> Songs (LAZY fetch, PERSIST/MERGE/REMOVE cascade)
- `@OneToMany`: Artist -> Albums, Artist -> SongArtists (LAZY fetch, PERSIST/MERGE/REMOVE cascade)
- `@ManyToMany`: Song <-> Artist (qua SongArtist với EAGER fetch)

## Best Practices

### 1. Lazy Loading

```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "role_id")
private Role role;
```

### 2. Cascade Operations

```java
@OneToMany(mappedBy = "role", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
private List<User> users;
```

### 3. Transaction Management

- Luôn sử dụng transactions cho write operations
- Sử dụng `HibernateUtil.executeInTransaction()` cho multiple operations

### 4. Exception Handling

```java
try {
    // JPA operations
} catch (Exception e) {
    HibernateUtil.rollbackTransaction();
    // Handle error
} finally {
    HibernateUtil.closeEntityManager();
}
```

## Database Schema

Hibernate sẽ tự động tạo/cập nhật schema dựa trên entity annotations. Các table chính:

- `Users`: User information
- `Roles`: User roles
- `Songs`: Song information
- `Albums`: Album information
- `Artists`: Artist information
- `Genres`: Genre information
- `SongArtists`: Many-to-many relationship between songs and artists

## Troubleshooting

### 1. Maven Dependency Issues

**Lỗi**: `hibernate-entitymanager:jar:6.4.1.Final was not found`
**Giải pháp**: Trong Hibernate 6.x, `hibernate-entitymanager` đã được merge vào `hibernate-core`. Xóa dependency này khỏi `pom.xml`.

```xml
<!-- KHÔNG CẦN dependency này trong Hibernate 6.x -->
<!-- <dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-entitymanager</artifactId>
    <version>6.4.1.Final</version>
</dependency> -->
```

### 2. Connection Issues

- Kiểm tra database connection trong `persistence.xml`
- Đảm bảo SQL Server đang chạy
- Kiểm tra credentials

### 3. Schema Issues

- Set `hibernate.hbm2ddl.auto = create` để tạo lại schema
- Kiểm tra table names và column names
- Verify foreign key relationships

### 4. Performance Issues

- Sử dụng lazy loading
- Optimize queries với proper indexing
- Monitor SQL logs

## Next Steps

1. **Migrate remaining DAOs**: SongDAO, AlbumDAO, ArtistDAO, GenreDAO
2. **Update Controllers**: Thay thế DAO calls
3. **Add Validation**: Sử dụng Bean Validation annotations
4. **Add Caching**: Configure second-level cache
5. **Add Tests**: Unit tests cho DAO classes

## Files Modified/Created

- `pom.xml`: Added Hibernate dependencies
- `persistence.xml`: JPA configuration
- `HibernateUtil.java`: Utility class for EntityManager management
- `UserDAO.java`: Updated to use JPA Hibernate
- `UserDAOJPA.java`: Example JPA-based DAO (backup)
- `UserDAODemo.java`: Demo class to test UserDAO
- `SongArtistId.java`: Composite key class
- All entity classes: Added JPA annotations with improved relationships

## Support

Nếu gặp vấn đề, hãy kiểm tra:

1. Database connection
2. Entity annotations
3. Transaction management
4. SQL Server logs
5. Application logs
