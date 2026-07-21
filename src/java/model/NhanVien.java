package model;

import java.math.BigDecimal;
import java.sql.Date;

public class NhanVien {

    private String maNV;
    private String hoTen;
    private String gioiTinh;
    private Date ngaySinh;
    private String sdt;
    private String chucVu;
    private BigDecimal luongCoBan;
    private String matKhau; // Thêm trường mật khẩu phục vụ đăng nhập

    // Thuộc tính ca làm việc
    private boolean caSang;
    private boolean caChieu;
    private boolean caToi;
    private String gioBatDau;
    private String gioKetThuc;

    // Constructor mặc định
    public NhanVien() {
    }

    // Getters và Setters
    public String getMaNV() {
        return maNV;
    }

    public void setMaNV(String maNV) {
        this.maNV = maNV;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getGioiTinh() {
        return gioiTinh;
    }

    public void setGioiTinh(String gioiTinh) {
        this.gioiTinh = gioiTinh;
    }

    public Date getNgaySinh() {
        return ngaySinh;
    }

    public void setNgaySinh(Date ngaySinh) {
        this.ngaySinh = ngaySinh;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getChucVu() {
        return chucVu;
    }

    public void setChucVu(String chucVu) {
        this.chucVu = chucVu;
    }

    public BigDecimal getLuongCoBan() {
        return luongCoBan;
    }

    public void setLuongCoBan(BigDecimal luongCoBan) {
        this.luongCoBan = luongCoBan;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public boolean isCaSang() {
        return caSang;
    }

    public void setCaSang(boolean caSang) {
        this.caSang = caSang;
    }

    public boolean isCaChieu() {
        return caChieu;
    }

    public void setCaChieu(boolean caChieu) {
        this.caChieu = caChieu;
    }

    public boolean isCaToi() {
        return caToi;
    }

    public void setCaToi(boolean caToi) {
        this.caToi = caToi;
    }

    public String getGioBatDau() {
        return gioBatDau;
    }

    public void setGioBatDau(String gioBatDau) {
        this.gioBatDau = gioBatDau;
    }

    public String getGioKetThuc() {
        return gioKetThuc;
    }

    public void setGioKetThuc(String gioKetThuc) {
        this.gioKetThuc = gioKetThuc;
    }
}