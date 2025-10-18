# Error 500 Fix - Property Name Mismatch

## 🐛 Lỗi

**Error 500 (Internal Server Error)** khi load trang playlist-detail.jsp

---

## 🔍 Nguyên nhân

### Property Name Mismatch

**Trong Entity (`Playlist.java`):**

```java
private String coverImage;  // ✅ Tên property

public String getCoverImage() {  // ✅ Getter method
    return coverImage;
}
```

**Trong JSP (SAI):**

```jsp
${playlist.coverImagePath}  // ❌ Tên sai! Không tồn tại
```

**Kết quả:**

- JSP cố gọi `getCoverImagePath()` method
- Method không tồn tại → Exception
- HTTP 500 error

---

## ✅ Cách sửa

### Đổi tên trong JSP để khớp với Entity

**File:** `src/main/webapp/views/playlist-detail.jsp`

#### Fix 1: Line 295-296

```jsp
<!-- BEFORE (SAI) -->
style="display: ${not empty playlist.coverImagePath ? 'block' : 'none'};">
<img src="${pageContext.request.contextPath}${playlist.coverImagePath}"

<!-- AFTER (ĐÚNG) -->
style="display: ${not empty playlist.coverImage ? 'block' : 'none'};">
<img src="${pageContext.request.contextPath}${playlist.coverImage}"
```

#### Fix 2: Line 310

```jsp
<!-- BEFORE (SAI) -->
style="display: ${empty playlist.coverImagePath ? 'block' : 'none'};">

<!-- AFTER (ĐÚNG) -->
style="display: ${empty playlist.coverImage ? 'block' : 'none'};">
```

---

## 📝 Quy tắc JSTL EL Property Access

### Cách JSTL EL hoạt động:

```jsp
${object.propertyName}
```

**Tự động gọi getter method:**

```java
object.getPropertyName()
```

### Ví dụ:

| JSP Expression               | Java Method Called             | Result              |
| ---------------------------- | ------------------------------ | ------------------- |
| `${playlist.coverImage}`     | `playlist.getCoverImage()`     | ✅ Works            |
| `${playlist.coverImagePath}` | `playlist.getCoverImagePath()` | ❌ Method not found |
| `${playlist.name}`           | `playlist.getName()`           | ✅ Works            |
| `${playlist.id}`             | `playlist.getId()`             | ✅ Works            |

---

## 🎯 Bài học

### 1. **Kiểm tra Entity Properties**

Trước khi dùng property trong JSP, luôn kiểm tra:

```java
// 1. Field name trong Entity
private String coverImage;

// 2. Getter method name
public String getCoverImage() { ... }

// 3. Dùng trong JSP (không có "get" prefix)
${playlist.coverImage}
```

### 2. **Naming Convention**

JSP EL tự động convert:

- `coverImage` (field) → `getCoverImage()` (method)
- `name` (field) → `getName()` (method)
- `id` (field) → `getId()` (method)

### 3. **Common Mistakes**

❌ `${playlist.getCoverImage()}` - Không cần gọi method trực tiếp
❌ `${playlist.coverImagePath}` - Property name sai
✅ `${playlist.coverImage}` - Đúng

---

## 🔧 Debug Tips

### Khi gặp Error 500 với JSP:

1. **Check Server Logs**

```
Look for: javax.el.PropertyNotFoundException
```

2. **Verify Entity Properties**

```java
// Check getter method exists and is public
public String getCoverImage() { ... }
```

3. **Match JSP with Entity**

```jsp
JSP: ${playlist.coverImage}
Entity: getCoverImage()
```

4. **Test in Console**

```java
System.out.println(playlist.getCoverImage());
```

---

## ✅ Kết quả

**Before:**

```
❌ HTTP 500 Error
❌ javax.el.PropertyNotFoundException: Property 'coverImagePath' not found
```

**After:**

```
✅ Page loads successfully
✅ Cover image displays correctly
✅ Placeholder shows when no image
```

---

## 💡 Best Practice

### Always verify property names match:

```java
// Entity
public class Playlist {
    private String coverImage;

    public String getCoverImage() {
        return coverImage;
    }
}
```

```jsp
<!-- JSP -->
${playlist.coverImage}  <!-- ✅ Matches getCoverImage() -->
```

### Avoid assumptions:

- Don't assume property names
- Check the actual entity code
- Use IDE autocomplete for JSP EL

---

## 🚀 Summary

| Issue                  | Fix                                     |
| ---------------------- | --------------------------------------- |
| Property name mismatch | Changed `coverImagePath` → `coverImage` |
| Lines affected         | 295, 296, 310                           |
| Files changed          | `playlist-detail.jsp`                   |
| Time to fix            | < 2 minutes                             |
| Lesson learned         | Always verify property names!           |

**Fixed! No more 500 errors! ✨**
