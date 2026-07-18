package model;

import java.sql.Date;

public class NhanVien {

    private String maNV;
    private String hoTen;
    private String gioiTinh;
    private String sdt;
    private String chucVu;
    private Date ngaySinh;
    private double luongCoBan;

    public NhanVien() {
    }

    // Constructor mới phải có đủ 7 tham số
    public NhanVien(String maNV, String hoTen, String gioiTinh, Date ngaySinh, String sdt, String chucVu, double luongCoBan) {
        this.maNV = maNV;
        this.hoTen = hoTen;
        this.gioiTinh = gioiTinh;
        this.ngaySinh = ngaySinh;
        this.sdt = sdt;
        this.chucVu = chucVu;
        this.luongCoBan = luongCoBan;
    }

    // --- CÁC GETTER VÀ SETTER ---
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

    public double getLuongCoBan() {
        return luongCoBan;
    }

    public void setLuongCoBan(double luongCoBan) {
        this.luongCoBan = luongCoBan;
    }
}
