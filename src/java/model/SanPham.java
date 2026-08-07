package model;

import java.math.BigDecimal;

public class SanPham {

    private String maSanPham;
    private String tenSanPham;
    private String maDanhMuc;
    private String tenDanhMuc;
    private BigDecimal giaBan;
    private boolean trangThai;

    private int soLuongCoTheBan;
    private String congThucText;

    private boolean coHinhAnh;
    private long hinhAnhVersion;

    public SanPham() {
    }

    public String getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(
            String maSanPham
    ) {
        this.maSanPham = maSanPham;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(
            String tenSanPham
    ) {
        this.tenSanPham = tenSanPham;
    }

    public String getMaDanhMuc() {
        return maDanhMuc;
    }

    public void setMaDanhMuc(
            String maDanhMuc
    ) {
        this.maDanhMuc = maDanhMuc;
    }

    public String getTenDanhMuc() {
        return tenDanhMuc;
    }

    public void setTenDanhMuc(
            String tenDanhMuc
    ) {
        this.tenDanhMuc = tenDanhMuc;
    }

    public BigDecimal getGiaBan() {
        return giaBan;
    }

    public void setGiaBan(
            BigDecimal giaBan
    ) {
        this.giaBan = giaBan;
    }

    public boolean isTrangThai() {
        return trangThai;
    }

    public void setTrangThai(
            boolean trangThai
    ) {
        this.trangThai = trangThai;
    }

    public int getSoLuongCoTheBan() {
        return soLuongCoTheBan;
    }

    public void setSoLuongCoTheBan(
            int soLuongCoTheBan
    ) {
        this.soLuongCoTheBan =
                soLuongCoTheBan;
    }

    public String getCongThucText() {
        return congThucText;
    }

    public void setCongThucText(
            String congThucText
    ) {
        this.congThucText =
                congThucText;
    }

    public boolean isCoHinhAnh() {
        return coHinhAnh;
    }

    public void setCoHinhAnh(
            boolean coHinhAnh
    ) {
        this.coHinhAnh = coHinhAnh;
    }

    public long getHinhAnhVersion() {
        return hinhAnhVersion;
    }

    public void setHinhAnhVersion(
            long hinhAnhVersion
    ) {
        this.hinhAnhVersion =
                hinhAnhVersion;
    }

    public boolean isCoTheBan() {
        return trangThai
                && soLuongCoTheBan > 0;
    }
}