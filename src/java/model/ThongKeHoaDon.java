package model;

import java.math.BigDecimal;

public class ThongKeHoaDon {

    private String maHD;
    private String ngayThanhToan;
    private String phuongThucThanhToan;
    private BigDecimal tongTien;
    private String hinhThuc;
    private String maBan;
    private String maNV;
    private String tenKhachHang;

    public ThongKeHoaDon() {
    }

    public String getMaHD() {
        return maHD;
    }

    public void setMaHD(String maHD) {
        this.maHD = maHD;
    }

    public String getMaHienThi() {
        if (
            maHD == null
            || maHD.isBlank()
        ) {
            return "";
        }

        try {
            return String.format(
                    "HD%06d",
                    Integer.parseInt(maHD)
            );

        } catch (NumberFormatException e) {
            return maHD.startsWith("HD")
                    ? maHD
                    : "HD" + maHD;
        }
    }

    public String getNgayThanhToan() {
        return ngayThanhToan;
    }

    public void setNgayThanhToan(
            String ngayThanhToan
    ) {
        this.ngayThanhToan =
                ngayThanhToan;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(
            String phuongThucThanhToan
    ) {
        this.phuongThucThanhToan =
                phuongThucThanhToan;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(
            BigDecimal tongTien
    ) {
        this.tongTien = tongTien;
    }

    public String getHinhThuc() {
        return hinhThuc;
    }

    public void setHinhThuc(
            String hinhThuc
    ) {
        this.hinhThuc = hinhThuc;
    }

    public String getMaBan() {
        return maBan;
    }

    public void setMaBan(
            String maBan
    ) {
        this.maBan = maBan;
    }

    public String getMaNV() {
        return maNV;
    }

    public void setMaNV(
            String maNV
    ) {
        this.maNV = maNV;
    }

    public String getTenKhachHang() {
        return tenKhachHang;
    }

    public void setTenKhachHang(
            String tenKhachHang
    ) {
        this.tenKhachHang =
                tenKhachHang;
    }
}