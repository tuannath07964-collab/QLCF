package model;

public class KhachHang {

    private String maKH;
    private String hoTen;
    private String sdt;
    private String maGiamGia;

    // Constructor mặc định
    public KhachHang() {
    }

    // Constructor đầy đủ
    public KhachHang(String maKH, String hoTen, String sdt, String maGiamGia) {
        this.maKH = maKH;
        this.hoTen = hoTen;
        this.sdt = sdt;
        this.maGiamGia = maGiamGia;
    }

    // Các phương thức Getter và Setter
    public String getMaKH() {
        return maKH;
    }

    public void setMaKH(String maKH) {
        this.maKH = maKH;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getMaGiamGia() {
        return maGiamGia;
    }

    public void setMaGiamGia(String maGiamGia) {
        this.maGiamGia = maGiamGia;
    }
}
