package model;

import java.math.BigDecimal;

public class DoanhThuNgay {

    private String ngay;
    private int soHoaDon;
    private BigDecimal doanhThu;

    public DoanhThuNgay() {
    }

    public DoanhThuNgay(
            String ngay,
            int soHoaDon,
            BigDecimal doanhThu
    ) {
        this.ngay = ngay;
        this.soHoaDon = soHoaDon;
        this.doanhThu = doanhThu;
    }

    public String getNgay() {
        return ngay;
    }

    public void setNgay(
            String ngay
    ) {
        this.ngay = ngay;
    }

    public int getSoHoaDon() {
        return soHoaDon;
    }

    public void setSoHoaDon(
            int soHoaDon
    ) {
        this.soHoaDon = soHoaDon;
    }

    public BigDecimal getDoanhThu() {
        return doanhThu;
    }

    public void setDoanhThu(
            BigDecimal doanhThu
    ) {
        this.doanhThu = doanhThu;
    }
}