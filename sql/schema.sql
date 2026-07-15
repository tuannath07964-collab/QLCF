-- =====================================================
-- QLCF Database Schema
-- Coffee Shop Management System
-- Created: July 2026
-- =====================================================

USE QLCF;

-- =====================================================
-- TABLE: NhanVien (Employee)
-- =====================================================
IF OBJECT_ID('NhanVien', 'U') IS NOT NULL DROP TABLE NhanVien;

CREATE TABLE NhanVien (
    MaNV NVARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SDT NVARCHAR(15),
    DiaChi NVARCHAR(255),
    ChucVu NVARCHAR(50),
    Luong FLOAT,
    TrangThai NVARCHAR(20),
    MatKhau_Hash NVARCHAR(255),  -- For future BCrypt implementation
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE INDEX idx_NhanVien_MaNV ON NhanVien(MaNV);
CREATE INDEX idx_NhanVien_HoTen ON NhanVien(HoTen);

-- =====================================================
-- TABLE: Menu (Dishes)
-- =====================================================
IF OBJECT_ID('Menu', 'U') IS NOT NULL DROP TABLE Menu;

CREATE TABLE Menu (
    MaMon INT IDENTITY(1,1) PRIMARY KEY,
    TenMon NVARCHAR(100) NOT NULL,
    Loai NVARCHAR(50),
    Gia FLOAT NOT NULL,
    TrangThai NVARCHAR(20),
    HinhAnh NVARCHAR(255),
    MoTa NVARCHAR(500),
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE INDEX idx_Menu_Loai ON Menu(Loai);
CREATE INDEX idx_Menu_TrangThai ON Menu(TrangThai);

-- =====================================================
-- TABLE: BanAn (Dining Tables)
-- =====================================================
IF OBJECT_ID('BanAn', 'U') IS NOT NULL DROP TABLE BanAn;

CREATE TABLE BanAn (
    MaBan INT IDENTITY(1,1) PRIMARY KEY,
    TenBan NVARCHAR(50) NOT NULL,
    ViTri NVARCHAR(100),
    SoGhe INT,
    TrangThai NVARCHAR(20),  -- 'Trong', 'Dang dung', 'Bao tri'
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE INDEX idx_BanAn_TrangThai ON BanAn(TrangThai);

-- =====================================================
-- TABLE: KhachHang (Customers)
-- =====================================================
IF OBJECT_ID('KhachHang', 'U') IS NOT NULL DROP TABLE KhachHang;

CREATE TABLE KhachHang (
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    SDT NVARCHAR(15),
    DiaChi NVARCHAR(255),
    GioiTinh NVARCHAR(10),
    NgayLapThe DATETIME DEFAULT GETDATE(),
    DiemTichLuy INT DEFAULT 0,
    TrangThai NVARCHAR(20),
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE INDEX idx_KhachHang_SDT ON KhachHang(SDT);
CREATE INDEX idx_KhachHang_TrangThai ON KhachHang(TrangThai);

-- =====================================================
-- TABLE: NguyenLieu (Ingredients)
-- =====================================================
IF OBJECT_ID('NguyenLieu', 'U') IS NOT NULL DROP TABLE NguyenLieu;

CREATE TABLE NguyenLieu (
    MaNL INT IDENTITY(1,1) PRIMARY KEY,
    TenNL NVARCHAR(100) NOT NULL,
    DonViTinh NVARCHAR(20),
    SoLuong FLOAT,
    GiaNhap FLOAT,
    TrangThai NVARCHAR(20),
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE INDEX idx_NguyenLieu_TrangThai ON NguyenLieu(TrangThai);

-- =====================================================
-- TABLE: DonHang (Orders) - For future use
-- =====================================================
IF OBJECT_ID('DonHang', 'U') IS NOT NULL DROP TABLE DonHang;

CREATE TABLE DonHang (
    MaDon INT IDENTITY(1,1) PRIMARY KEY,
    MaBan INT,
    MaKH INT,
    MaNV NVARCHAR(10),
    NgayGio DATETIME DEFAULT GETDATE(),
    TongTien FLOAT,
    TrangThai NVARCHAR(20),
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaBan) REFERENCES BanAn(MaBan),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

CREATE INDEX idx_DonHang_MaBan ON DonHang(MaBan);
CREATE INDEX idx_DonHang_NgayGio ON DonHang(NgayGio);

-- =====================================================
-- Sample Data for Testing
-- =====================================================

-- Insert sample employees
INSERT INTO NhanVien (MaNV, HoTen, GioiTinh, NgaySinh, SDT, DiaChi, ChucVu, Luong, TrangThai)
VALUES 
('TH08922', N'Nguyễn Minh Đăng', N'Nam', '1998-05-15', '0912345678', N'123 Đường ABC, TP.HCM', N'Quản lý', 15000000, N'Hoạt động'),
('TH07964', N'Nguyễn Anh Tuấn', N'Nam', '1999-03-20', '0987654321', N'456 Đường XYZ, TP.HCM', N'Nhân viên', 8000000, N'Hoạt động'),
('TH07969', N'Phùng Chí Trung', N'Nam', '1998-07-12', '0945123456', N'789 Đường PQR, TP.HCM', N'Nhân viên', 8000000, N'Hoạt động'),
('TH08495', N'Trần Dương Phương Hiếu', N'Nữ', '2000-01-25', '0933456789', N'321 Đường DEF, TP.HCM', N'Nhân viên', 7500000, N'Hoạt động'),
('TH08860', N'Ngô Thanh Long', N'Nam', '1997-11-08', '0921111111', N'654 Đường GHI, TP.HCM', N'Phục vụ', 6000000, N'Hoạt động'),
('TH08199', N'Trịnh Bình Minh', N'Nữ', '2001-09-30', '0955555555', N'987 Đường JKL, TP.HCM', N'Phục vụ', 6000000, N'Hoạt động');

-- Insert sample menu items
INSERT INTO Menu (TenMon, Loai, Gia, TrangThai, HinhAnh, MoTa)
VALUES
(N'Cà phê đen', N'Cà phê', 25000, N'Còn', 'cafe-den.jpg', N'Cà phê đen đậm đà'),
(N'Cà phê sữa', N'Cà phê', 30000, N'Còn', 'cafe-sua.jpg', N'Cà phê sữa ngon lành'),
(N'Cappuccino', N'Cà phê', 45000, N'Còn', 'cappuccino.jpg', N'Cappuccino thơm ngon'),
(N'Latte', N'Cà phê', 50000, N'Còn', 'latte.jpg', N'Latte nhập khẩu'),
(N'Trà đen', N'Trà', 20000, N'Còn', 'tra-den.jpg', N'Trà đen tươi mát'),
(N'Trà xanh', N'Trà', 20000, N'Còn', 'tra-xanh.jpg', N'Trà xanh sạch');

-- Insert sample tables
INSERT INTO BanAn (TenBan, ViTri, SoGhe, TrangThai)
VALUES
(N'Bàn 1', N'Góc cửa sổ', 2, N'Trống'),
(N'Bàn 2', N'Giữa quán', 4, N'Trống'),
(N'Bàn 3', N'Góc yên tĩnh', 4, N'Trống'),
(N'Bàn 4', N'Khoảng cửa', 6, N'Trống'),
(N'Bàn 5', N'Tầng lầu', 8, N'Trống');

-- Insert sample customers
INSERT INTO KhachHang (TenKH, SDT, DiaChi, GioiTinh, DiemTichLuy, TrangThai)
VALUES
(N'Lê Văn A', '0901234567', N'Quận 1, TP.HCM', N'Nam', 0, N'Hoạt động'),
(N'Trương Thị B', '0912345678', N'Quận 2, TP.HCM', N'Nữ', 0, N'Hoạt động'),
(N'Phạm Văn C', '0923456789', N'Quận 3, TP.HCM', N'Nam', 0, N'Hoạt động');

PRINT 'Database schema created successfully!';
