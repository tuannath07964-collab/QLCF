package model;

public class HoaDon {
    private String maHD;
    private String maBan;
    private String maNV;
    private String ngayTao;
    private double tongTien;
    private String trangThai;
    private String danhSachMon;
    private String maGiamGia;

    public HoaDon() {
    }

    public HoaDon(String maHD, String maBan, String maNV, String ngayTao, double tongTien, String trangThai) {
        this.maHD = maHD;
        this.maBan = maBan;
        this.maNV = maNV;
        this.ngayTao = ngayTao;
        this.tongTien = tongTien;
        this.trangThai = trangThai;
    }

    public String getMaHD() { return maHD; }
    public void setMaHD(String maHD) { this.maHD = maHD; }

    public String getMaBan() { return maBan; }
    public void setMaBan(String maBan) { this.maBan = maBan; }

    public String getMaNV() { return maNV; }
    public void setMaNV(String maNV) { this.maNV = maNV; }

    public String getNgayTao() { return ngayTao; }
    public void setNgayTao(String ngayTao) { this.ngayTao = ngayTao; }

    public double getTongTien() { return tongTien; }
    public void setTongTien(double tongTien) { this.tongTien = tongTien; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public String getDanhSachMon() {return danhSachMon;}
    public void setDanhSachMon(String danhSachMon) {this.danhSachMon = danhSachMon; }

    public String getMaGiamGia() {return maGiamGia;  }
    public void setMaGiamGia(String maGiamGia) {this.maGiamGia = maGiamGia;     }
    
}