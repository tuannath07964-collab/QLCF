package model;

import java.time.LocalDateTime;

public class VoucherKhachHang {

    private int maVoucher;
    private String maCode;
    private String maKH;
    private int menhGia;
    private int soDiemDaDoi;
    private LocalDateTime ngayDoi;
    private LocalDateTime ngayHetHan;
    private String trangThai;

    public VoucherKhachHang() {
    }

    public int getMaVoucher() {
        return maVoucher;
    }

    public void setMaVoucher(int maVoucher) {
        this.maVoucher = maVoucher;
    }

    public String getMaCode() {
        return maCode;
    }

    public void setMaCode(String maCode) {
        this.maCode = maCode;
    }

    public String getMaKH() {
        return maKH;
    }

    public void setMaKH(String maKH) {
        this.maKH = maKH;
    }

    public int getMenhGia() {
        return menhGia;
    }

    public void setMenhGia(int menhGia) {
        this.menhGia = menhGia;
    }

    public int getSoDiemDaDoi() {
        return soDiemDaDoi;
    }

    public void setSoDiemDaDoi(int soDiemDaDoi) {
        this.soDiemDaDoi = soDiemDaDoi;
    }

    public LocalDateTime getNgayDoi() {
        return ngayDoi;
    }

    public void setNgayDoi(LocalDateTime ngayDoi) {
        this.ngayDoi = ngayDoi;
    }

    public LocalDateTime getNgayHetHan() {
        return ngayHetHan;
    }

    public void setNgayHetHan(LocalDateTime ngayHetHan) {
        this.ngayHetHan = ngayHetHan;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getMenhGiaHienThi() {
        return String.format("%,dđ", menhGia)
                .replace(",", ".");
    }

    public String getNgayDoiHienThi() {
        if (ngayDoi == null) {
            return "";
        }

        return String.format(
                "%02d/%02d/%04d %02d:%02d",
                ngayDoi.getDayOfMonth(),
                ngayDoi.getMonthValue(),
                ngayDoi.getYear(),
                ngayDoi.getHour(),
                ngayDoi.getMinute()
        );
    }

    public String getNgayHetHanHienThi() {
        if (ngayHetHan == null) {
            return "";
        }

        return String.format(
                "%02d/%02d/%04d",
                ngayHetHan.getDayOfMonth(),
                ngayHetHan.getMonthValue(),
                ngayHetHan.getYear()
        );
    }

    public boolean isConHan() {
        return "Chưa sử dụng".equalsIgnoreCase(trangThai)
                && ngayHetHan != null
                && ngayHetHan.isAfter(LocalDateTime.now());
    }
}