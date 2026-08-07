package model;

import java.math.BigDecimal;

public class DoanhThuNgay {

    private String ngay;

    private BigDecimal doanhThu =
            BigDecimal.ZERO;

    public DoanhThuNgay() {
    }

    public String getNgay() {
        return ngay;
    }

    public void setNgay(String ngay) {
        this.ngay = ngay;
    }

    public BigDecimal getDoanhThu() {
        return doanhThu;
    }

    public void setDoanhThu(BigDecimal doanhThu) {
        this.doanhThu = doanhThu;
    }
}