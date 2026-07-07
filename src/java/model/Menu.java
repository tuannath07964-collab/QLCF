package model;

public class Menu {
    private String maMon;
    private String tenMon;
    private String loai;
    private double gia;
    private String hinhAnh;

    public Menu(String maMon, String tenMon, String loai, double gia, String hinhAnh) {
        this.maMon = maMon;
        this.tenMon = tenMon;
        this.loai = loai;
        this.gia = gia;
        this.hinhAnh = hinhAnh;
    }

    // Getters
    public String getMaMon() { return maMon; }
    public String getTenMon() { return tenMon; }
    public String getLoai() { return loai; }
    public double getGia() { return gia; }
    public String getHinhAnh() { return hinhAnh; }
}