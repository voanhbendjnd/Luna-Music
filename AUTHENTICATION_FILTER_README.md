# Authentication Filter Implementation

## 🔐 **Tổng quan**

Đã implement Authentication Filter để kiểm soát quyền truy cập trong ứng dụng Luna Music theo yêu cầu:

- **Public Access**: Home, login, register, và các tính năng nghe nhạc
- **Protected Access**: Admin và Playlist (cần đăng nhập)
- **Admin Only**: Trang admin (cần role_id = 1)

---

## 📁 **Files Modified**

### 1. **AuthenticationFilter.java** (New)

- **Location**: `src/main/java/filters/AuthenticationFilter.java`
- **Annotation**: `@WebFilter("/*")` - Filter tất cả requests
- **Purpose**: Kiểm soát quyền truy cập

### 2. **LoginController.java** (Updated)

- **Line 48**: Added `session.setAttribute("roleId", user.getRole().getId())`
- **Purpose**: Lưu roleId vào session để filter kiểm tra

---

## 🛡️ **Filter Logic**

### **Public Paths** (Không cần đăng nhập)

```java
// Exact matches
"/", "/home", "/login", "/register", "/logout"

// Pattern matches
"/song-detail*", "/album-detail*", "/artist-detail*"
"/song*", "/album*", "/artist*"
"/assets/*", "/uploads/*", "/music/*"

// Static resources
*.css, *.js, *.png, *.jpg, *.jpeg, *.gif, *.ico
*.mp3, *.m4a, *.wav
```

### **Protected Paths** (Cần đăng nhập)

```java
// Playlist pages
"/playlist*"

// Admin pages (cần role_id = 1)
"/admin*"
```

---

## 🔄 **Flow Logic**

### **1. Public Access**

```
Request → Filter → Check isPublicPath() → Allow → Continue
```

### **2. Protected Access (Not Logged In)**

```
Request → Filter → Check Session → No Session → Redirect to /login
```

### **3. Admin Access (Not Admin)**

```
Request → Filter → Check Session → Check roleId → Not Admin → Redirect to /home
```

### **4. Valid Access**

```
Request → Filter → Check Session → Check roleId → Valid → Continue
```

---

## 🎯 **Access Control Matrix**

| Resource         | Public | Logged In | Admin Only |
| ---------------- | ------ | --------- | ---------- |
| `/` (Home)       | ✅     | ✅        | ✅         |
| `/login`         | ✅     | ✅        | ✅         |
| `/register`      | ✅     | ✅        | ✅         |
| `/song-detail`   | ✅     | ✅        | ✅         |
| `/album-detail`  | ✅     | ✅        | ✅         |
| `/artist-detail` | ✅     | ✅        | ✅         |
| `/playlist*`     | ❌     | ✅        | ✅         |
| `/admin*`        | ❌     | ❌        | ✅         |

---

## 🔧 **Implementation Details**

### **Session Attributes**

```java
// Set in LoginController
session.setAttribute("user", user);
session.setAttribute("roleId", user.getRole().getId());

// Checked in Filter
Object roleId = session.getAttribute("roleId");
if (roleId == null || !roleId.equals(1L)) {
    // Not admin
}
```

### **Redirect Logic**

```java
// Not logged in → Login page
httpResponse.sendRedirect(contextPath + "/login");

// Not admin → Home page
httpResponse.sendRedirect(contextPath + "/home");
```

---

## ✅ **Features Implemented**

1. ✅ **Public Access Control**

   - Home, login, register accessible without login
   - Music features (song, album, artist) accessible without login
   - Static resources accessible without login

2. ✅ **Authentication Required**

   - Playlist pages require login
   - Admin pages require login

3. ✅ **Role-Based Access Control**

   - Admin pages require role_id = 1
   - Non-admin users redirected to home

4. ✅ **Session Management**

   - roleId stored in session on login
   - Session invalidated on logout

5. ✅ **Security**
   - All requests filtered
   - Proper redirects for unauthorized access
   - Session timeout handling

---

## 🚀 **Usage**

### **For Users**

- Browse music freely without login
- Must login to access playlists
- Admin users can access admin panel

### **For Developers**

- Filter automatically handles all requests
- No need to add authentication checks in controllers
- Easy to modify access rules in `isPublicPath()` method

---

## 📝 **Testing Scenarios**

### **Public Access**

- ✅ `/home` - Should work without login
- ✅ `/song-detail?id=1` - Should work without login
- ✅ `/album-detail?id=1` - Should work without login
- ✅ `/artist-detail?id=1` - Should work without login

### **Protected Access**

- ✅ `/playlist` - Should redirect to login if not logged in
- ✅ `/admin` - Should redirect to login if not logged in
- ✅ `/admin` - Should redirect to home if logged in but not admin

### **Admin Access**

- ✅ `/admin` - Should work if logged in as admin (role_id = 1)
- ✅ `/admin` - Should redirect to home if logged in as user (role_id ≠ 1)

---

**Perfect authentication system! 🔐✨**
