package model;

public class Menu {

    private int maMon;
    private String tenMon;
    private String loai;
    private double gia;
    private String trangThai;
    private String hinhAnh;

    public Menu() {
    }

    public Menu(int maMon, String tenMon, String loai,
                double gia, String trangThai, String hinhAnh) {
        this.maMon = maMon;
        this.tenMon = tenMon;
        this.loai = loai;
        this.gia = gia;
        this.trangThai = trangThai;
        this.hinhAnh = hinhAnh;
    }

    public int getMaMon() {
        return maMon;
    }

    public void setMaMon(int maMon) {
        this.maMon = maMon;
    }

    public String getTenMon() {
        return tenMon;
    }

    public void setTenMon(String tenMon) {
        this.tenMon = tenMon;
    }

    public String getLoai() {
        return loai;
    }

    public void setLoai(String loai) {
        this.loai = loai;
    }

    public double getGia() {
        return gia;
    }

    public void setGia(double gia) {
        this.gia = gia;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    @Override
    public String toString() {
        return "Menu{" +
                "maMon=" + maMon +
                ", tenMon='" + tenMon + '\'' +
                ", loai='" + loai + '\'' +
                ", gia=" + gia +
                ", trangThai='" + trangThai + '\'' +
                ", hinhAnh='" + hinhAnh + '\'' +
                '}';
    }
}