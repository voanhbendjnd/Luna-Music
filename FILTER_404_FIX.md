# Filter 404 Error Fix

## 🚨 **Vấn đề gặp phải**

Tất cả các trang đều trả về lỗi 404 sau khi implement Authentication Filter.

---

## 🔍 **Nguyên nhân**

### 1. **Lỗi chính tả trong web.xml**

```xml
<!-- SAI -->
<filter-class>filters.AuthenticatioinFilter</filter-class>

<!-- ĐÚNG -->
<filter-class>filters.AuthenticationFilter</filter-class>
```

### 2. **Conflict giữa @WebFilter và web.xml**

- Filter được định nghĩa cả trong annotation `@WebFilter("/*")` và web.xml
- Gây conflict và không load được filter

### 3. **Thiếu servlet mapping**

- PlaylistController không có trong web.xml
- Gây lỗi 404 cho các request đến `/playlist`

### 4. **File filter cũ**

- AuthFilter.java cũ vẫn tồn tại và có thể gây conflict

---

## ✅ **Giải pháp đã áp dụng**

### 1. **Sửa lỗi chính tả trong web.xml**

```xml
<filter>
    <filter-name>AuthFilter</filter-name>
    <filter-class>filters.AuthenticationFilter</filter-class>
</filter>
```

### 2. **Xóa @WebFilter annotation**

```java
// Xóa dòng này
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
```

### 3. **Thêm PlaylistController vào web.xml**

```xml
<servlet>
    <servlet-name>PlaylistController</servlet-name>
    <servlet-class>controllers.PlaylistController</servlet-class>
</servlet>

<servlet-mapping>
    <servlet-name>PlaylistController</servlet-name>
    <url-pattern>/playlist</url-pattern>
</servlet-mapping>
```

### 4. **Xóa file AuthFilter.java cũ**

- Deleted: `src/main/java/filters/AuthFilter.java`
- Giữ lại: `src/main/java/filters/AuthenticationFilter.java`

### 5. **Thêm debug logs**

```java
// Debug log để kiểm tra filter hoạt động
System.out.println("Filter: Request URI = " + requestURI);
System.out.println("Filter: Context Path = " + contextPath);
System.out.println("Filter: Path = " + path);
```

---

## 📁 **Files Modified**

### 1. **web.xml** (Fixed)

- ✅ Fixed typo: `AuthenticatioinFilter` → `AuthenticationFilter`
- ✅ Added PlaylistController servlet and mapping

### 2. **AuthenticationFilter.java** (Updated)

- ✅ Removed `@WebFilter("/*")` annotation
- ✅ Removed `@WebFilter` import
- ✅ Added debug logs

### 3. **AuthFilter.java** (Deleted)

- ✅ Deleted old filter file

---

## 🔄 **Filter Flow After Fix**

### **1. Request Processing**

```
Request → web.xml → AuthenticationFilter → Check Path → Decision
```

### **2. Path Checking**

```java
// Public paths (no auth required)
"/", "/home", "/login", "/register", "/logout"
"/song-detail*", "/album-detail*", "/artist-detail*"
"/assets/*", "/uploads/*", "/music/*"
"*.css", "*.js", "*.png", etc.

// Protected paths (auth required)
"/playlist*" → Need login
"/admin*" → Need login + admin role
```

### **3. Decision Logic**

```java
if (isPublicPath(path)) {
    // Allow access
    chain.doFilter(request, response);
} else if (session == null || session.getAttribute("user") == null) {
    // Redirect to login
    httpResponse.sendRedirect(contextPath + "/login");
} else if (path.startsWith("/admin") && !isAdmin(session)) {
    // Redirect to home
    httpResponse.sendRedirect(contextPath + "/home");
} else {
    // Allow access
    chain.doFilter(request, response);
}
```

---

## 🎯 **Expected Results**

### **Public Access (No Login Required)**

- ✅ `/` → Home page
- ✅ `/home` → Home page
- ✅ `/login` → Login page
- ✅ `/register` → Register page
- ✅ `/song-detail?id=1` → Song detail
- ✅ `/album-detail?id=1` → Album detail
- ✅ `/artist-detail?id=1` → Artist detail

### **Protected Access (Login Required)**

- ✅ `/playlist` → Redirect to login (if not logged in)
- ✅ `/playlist` → Playlist page (if logged in)

### **Admin Access (Admin Role Required)**

- ✅ `/admin` → Redirect to login (if not logged in)
- ✅ `/admin` → Redirect to home (if logged in but not admin)
- ✅ `/admin` → Admin page (if logged in as admin)

---

## 🚀 **Testing Steps**

### **1. Test Public Access**

```bash
# Should work without login
GET /
GET /home
GET /login
GET /register
GET /song-detail?id=1
GET /album-detail?id=1
GET /artist-detail?id=1
```

### **2. Test Protected Access**

```bash
# Should redirect to login
GET /playlist (without login)

# Should work after login
GET /playlist (with login)
```

### **3. Test Admin Access**

```bash
# Should redirect to login
GET /admin (without login)

# Should redirect to home
GET /admin (with user login, role_id ≠ 1)

# Should work
GET /admin (with admin login, role_id = 1)
```

---

## 📝 **Debug Information**

### **Console Logs**

```
Filter: Request URI = /LunaMusic/home
Filter: Context Path = /LunaMusic
Filter: Path = /home
```

### **Check Points**

1. ✅ Filter loads without errors
2. ✅ Debug logs appear in console
3. ✅ Public paths work without login
4. ✅ Protected paths redirect properly
5. ✅ Admin access control works

---

**Filter 404 issue resolved! 🎉✨**
