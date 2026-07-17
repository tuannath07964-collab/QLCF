package model;

public class BanAn {
    private String maBan;
    private String tenBan;
    private String trangThai;

    public BanAn() {
    }

    public BanAn(String tenBan, String trangThai) {
        this.tenBan = tenBan;
        this.trangThai = trangThai;
    }

    public BanAn(String maBan, String tenBan, String trangThai) {
        this.maBan = maBan;
        this.tenBan = tenBan;
        this.trangThai = trangThai;
    }

    public String getMaBan() {
        return maBan;
    }

    public void setMaBan(String maBan) {
        this.maBan = maBan;
    }

    public String getTenBan() {
        return tenBan;
    }

    public void setTenBan(String tenBan) {
        this.tenBan = tenBan;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}