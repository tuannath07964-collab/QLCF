package model;

import java.math.BigDecimal;

public class NguyenLieu {

    private String maNL;
    private String tenNL;
    private BigDecimal soLuong;
    private String donVi;
    private String congThucSuDung;

    public NguyenLieu() {
    }

    public NguyenLieu(
            String maNL,
            String tenNL,
            BigDecimal soLuong,
            String donVi
    ) {
        this.maNL = maNL;
        this.tenNL = tenNL;
        this.soLuong = soLuong;
        this.donVi = donVi;
    }

    public String getMaNL() {
        return maNL;
    }

    public void setMaNL(String maNL) {
        this.maNL = maNL;
    }

    public String getTenNL() {
        return tenNL;
    }

    public void setTenNL(String tenNL) {
        this.tenNL = tenNL;
    }

    public BigDecimal getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(BigDecimal soLuong) {
        this.soLuong = soLuong;
    }

    public String getDonVi() {
        return donVi;
    }

    public void setDonVi(String donVi) {
        this.donVi = donVi;
    }

    public String getCongThucSuDung() {
        return congThucSuDung;
    }

    public void setCongThucSuDung(
            String congThucSuDung
    ) {
        this.congThucSuDung =
                congThucSuDung;
    }

    public boolean isHetHang() {
        return soLuong == null
                || soLuong.compareTo(
                        BigDecimal.ZERO
                ) <= 0;
    }

    public boolean isSapHetHang() {
        return soLuong != null
                && soLuong.compareTo(
                        BigDecimal.ZERO
                ) > 0
                && soLuong.compareTo(
                        new BigDecimal("10")
                ) <= 0;
    }

    public String getTrangThaiKho() {
        if (isHetHang()) {
            return "Hết hàng";
        }

        if (isSapHetHang()) {
            return "Sắp hết";
        }

        return "Còn hàng";
    }
}