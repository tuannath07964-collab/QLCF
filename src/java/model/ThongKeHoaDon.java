package model;

import java.math.BigDecimal;

public class ThongKeHoaDon {

    private int maHD;
    private String ngayThanhToan;
    private String tenTaiKhoan;
    private String tenKhachHang;

    private BigDecimal tongTien =
            BigDecimal.ZERO;

    public ThongKeHoaDon() {
    }

    public int getMaHD() {
        return maHD;
    }

    public void setMaHD(int maHD) {
        this.maHD = maHD;
    }

    public String getMaHienThi() {
        return String.format(
                "HD%06d",
                maHD
        );
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

    public String getTenTaiKhoan() {
        return tenTaiKhoan;
    }

    public void setTenTaiKhoan(
            String tenTaiKhoan
    ) {
        this.tenTaiKhoan =
                tenTaiKhoan;
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

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(
            BigDecimal tongTien
    ) {
        this.tongTien =
                tongTien == null
                ? BigDecimal.ZERO
                : tongTien;
    }
}