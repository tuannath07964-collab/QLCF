# 🏪 QLCF - Quản Lý Quán Cafe

Hệ thống quản lý quán cafe toàn diện: quản lý menu, nhân viên, bàn, khách hàng, kho hàng và thống kê doanh thu.

## 🎯 Tính năng chính

- 👤 **Quản lý nhân viên** - Thêm/sửa/xóa thông tin nhân viên
- 🍽️ **Quản lý menu** - Quản lý danh sách món ăn, giá bán, hình ảnh
- 🪑 **Quản lý bàn** - Theo dõi trạng thái bàn (trống, đang dùng, bảo trì)
- 👥 **Quản lý khách hàng** - Lưu thông tin khách hàng thường xuyên
- 📦 **Quản lý kho** - Theo dõi nguyên liệu, tồn kho
- 📊 **Thống kê doanh thu** - Báo cáo doanh thu theo ngày/tháng/năm
- 🔐 **Xác thực nhân viên** - Đăng nhập với mã nhân viên

## 🛠️ Công nghệ sử dụng

- **Java 11+** (Jakarta EE 9+)
- **Servlet/JSP** (Web framework)
- **SQL Server 2019+** (Database)
- **HikariCP** (Connection pooling)
- **Bootstrap 5** (Frontend CSS)
- **JSTL** (JSP Standard Tag Library)
- **Apache Ant / Maven** (Build tools)

## 📋 Yêu cầu hệ thống

- Java JDK 11 hoặc cao hơn
- Apache Tomcat 9.0+
- SQL Server 2019 (hoặc Express Edition)
- Maven 3.6+ (nếu dùng Maven)

## 🚀 Hướng dẫn cài đặt

### 1. Chuẩn bị Database

```sql
-- Tạo database
CREATE DATABASE QLCF;
USE QLCF;

-- Chạy SQL script
-- Execute file: sql/schema.sql
```

### 2. Cấu hình kết nối Database

**Option A: Dùng environment variables (Recommended)**
```bash
# Linux/Mac
export DB_HOST=localhost
export DB_PORT=1433
export DB_NAME=QLCF
export DB_USER=sa
export DB_PASSWORD=your_password

# Windows (Command Prompt)
set DB_HOST=localhost
set DB_PORT=1433
set DB_NAME=QLCF
set DB_USER=sa
set DB_PASSWORD=your_password

# Windows (PowerShell)
\$env:DB_HOST="localhost"
\$env:DB_PORT="1433"
\$env:DB_NAME="QLCF"
\$env:DB_USER="sa"
\$env:DB_PASSWORD="your_password"
```

**Option B: Dùng file `application.properties`**
```properties
db.host=localhost
db.port=1433
db.name=QLCF
db.user=sa
db.password=your_password
```

### 3. Build & Deploy

**Sử dụng Maven:**
```bash
# Build project
mvn clean package

# Deploy file WAR lên Tomcat
cp target/qlcf.war $CATALINA_HOME/webapps/
```

**Sử dụng Apache Ant:**
```bash
# Build project
ant clean build

# Deploy
cp build/dist/qlcf.war $CATALINA_HOME/webapps/
```

### 4. Khởi động Tomcat

```bash
# Linux/Mac
$CATALINA_HOME/bin/startup.sh

# Windows
%CATALINA_HOME%\bin\startup.bat
```

### 5. Truy cập ứng dụng

- URL: `http://localhost:8080/qlcf`
- Màn hình đăng nhập sẽ hiển thị

## 👤 Tài khoản mặc định

| Mã NV | Mật khẩu | Tên |
|-------|----------|-----|
| TH08922 | 123 | Nguyễn Minh Đăng |
| TH07964 | 123 | Nguyễn Anh Tuấn |
| TH07969 | 123 | Phùng Chí Trung |
| TH08495 | 123 | Trần Dương Phương Hiếu |
| TH08860 | 123 | Ngô Thanh Long |
| TH08199 | 123 | Trịnh Bình Minh |

> ⚠️ **IMPORTANT:** Đây là tài khoản demo mặc định. Trước khi deploy lên production, hãy thay đổi tất cả mật khẩu và hash chúng bằng BCrypt.

## 📁 Cấu trúc dự án

```
QLCF/
├── src/
│   ├── java/
│   │   └── com/qlcf/
│   │       ├── controller/        # Servlet classes
│   │       ├── service/           # Business logic
│   │       ├── dao/               # Data Access Objects
│   │       ├── model/             # Entity classes
│   │       └── util/              # Utility classes
│   ├── resources/
│   │   └── application.properties  # Configuration
│   └── webapp/
│       ├── views/                 # JSP files
│       ├── css/                   # Stylesheets
│       ├── js/                    # JavaScript files
│       ├── images/                # Images & assets
│       └── WEB-INF/
│           └── web.xml            # Web app configuration
├── sql/
│   └── schema.sql                 # Database schema
├── pom.xml                        # Maven configuration
├── build.xml                      # Ant configuration
├── application.properties         # Default configuration
├── README.md                      # This file
└── .gitignore
```

## 🔐 Bảo mật

### Đã triển khai:
- ✅ Prepared Statements (SQL Injection prevention)
- ✅ XSS Protection (JSTL `<c:out>`)
- ✅ Session Management
- ✅ HTTP-only Cookies
- ✅ Input Validation

### Khuyến nghị bổ sung:
- 🔶 CSRF Token cho forms
- 🔶 HTTPS/SSL trong production
- 🔶 Password hashing với BCrypt
- 🔶 Rate limiting cho login attempts
- 🔶 Audit logging

## 📝 Hướng phát triển

- [ ] Implement password hashing (BCrypt/PBKDF2)
- [ ] Add CSRF protection tokens
- [ ] Create comprehensive API documentation
- [ ] Add unit & integration tests
- [ ] Implement role-based access control (RBAC)
- [ ] Add audit logging
- [ ] Performance optimization & caching
- [ ] Mobile-friendly responsive design

## 🐛 Báo cáo lỗi

Nếu bạn tìm thấy lỗi, vui lòng:
1. Tạo issue trên GitHub
2. Mô tả chi tiết lỗi và cách tái hiện
3. Kèm theo screenshot nếu có

## 📧 Liên hệ

- **Project Lead:** Phùng Chí Trung
- **Email:** trung@email.com
- **GitHub:** [@tuannath07964-collab](https://github.com/tuannath07964-collab)

## 📄 License

MIT License - Xem file LICENSE để chi tiết

---

**Last updated:** July 2026