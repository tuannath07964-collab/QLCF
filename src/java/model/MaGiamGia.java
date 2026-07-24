package model;

public class MaGiamGia {
    private int IDGiamGia;
    private String maCode;
    private double phanTramGiam;
    private double dieuKienDonToiTieu;
    private String ngayHetHan;
    private int trangThai;

    public MaGiamGia() {
    }

    public MaGiamGia(int IDGiamGia, String maCode, double phanTramGiam, double dieuKienDonToiTieu, String ngayHetHan, int trangThai) {
        this.IDGiamGia = IDGiamGia;
        this.maCode = maCode;
        this.phanTramGiam = phanTramGiam;
        this.dieuKienDonToiTieu = dieuKienDonToiTieu;
        this.ngayHetHan = ngayHetHan;
        this.trangThai = trangThai;
    }

    public int getIDGiamGia() {
        return IDGiamGia;
    }

    public void setIDGiamGia(int IDGiamGia) {
        this.IDGiamGia = IDGiamGia;
    }

    public String getMaCode() {
        return maCode;
    }

    public void setMaCode(String maCode) {
        this.maCode = maCode;
    }

    public double getPhanTramGiam() {
        return phanTramGiam;
    }

    public void setPhanTramGiam(double phanTramGiam) {
        this.phanTramGiam = phanTramGiam;
    }

    public double getDieuKienDonToiTieu() {
        return dieuKienDonToiTieu;
    }

    public void setDieuKienDonToiTieu(double dieuKienDonToiTieu) {
        this.dieuKienDonToiTieu = dieuKienDonToiTieu;
    }

    public String getNgayHetHan() {
        return ngayHetHan;
    }

    public void setNgayHetHan(String ngayHetHan) {
        this.ngayHetHan = ngayHetHan;
    }

    public int getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(int trangThai) {
        this.trangThai = trangThai;
    }
}