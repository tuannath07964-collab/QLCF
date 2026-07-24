package model;

public class BanAn {

    private int maBan;
    private String tenBan;
    private int soCho;
    private String khuVuc;
    private int trangThai; // 0: Trống, 1: Đang phục vụ, 2: Đã đặt trước, 3: Đang dọn dẹp
    private String maDonHang;

    public BanAn() {
    }

    public BanAn(int maBan, String tenBan, int soCho, String khuVuc, int trangThai, String maDonHang) {
        this.maBan = maBan;
        this.tenBan = tenBan;
        this.soCho = soCho;
        this.khuVuc = khuVuc;
        this.trangThai = trangThai;
        this.maDonHang = maDonHang;
    }

    // Getters and Setters
    public int getMaBan() {
        return maBan;
    }

    public void setMaBan(int maBan) {
        this.maBan = maBan;
    }

    public String getTenBan() {
        return tenBan;
    }

    public void setTenBan(String tenBan) {
        this.tenBan = tenBan;
    }

    public int getSoCho() {
        return soCho;
    }

    public void setSoCho(int soCho) {
        this.soCho = soCho;
    }

    public String getKhuVuc() {
        return khuVuc;
    }

    public void setKhuVuc(String khuVuc) {
        this.khuVuc = khuVuc;
    }

    public int getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(int trangThai) {
        this.trangThai = trangThai;
    }

    public String getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(String maDonHang) {
        this.maDonHang = maDonHang;
    }
}
