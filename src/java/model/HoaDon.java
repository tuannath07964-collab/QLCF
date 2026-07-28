package model;

public class HoaDon {

    private String maHD;
    private String maBan;
    private String maNV;
    private String maKH;
    private String tenKhachHang;
    private String ngayTao;

    private double tamTinh;
    private double thueVAT;
    private double tongTien;
    private int diemCong;

    private String trangThai;
    private String danhSachMon;
    private String phuongThucThanhToan;
    private String ngayThanhToan;
    private String hinhThuc;
    private String lyDoHuy;

    public HoaDon() {
    }

    public String getMaHD() {
        return maHD;
    }

    public void setMaHD(String maHD) {
        this.maHD = maHD;
    }

    public String getMaHienThi() {
        if (maHD == null || maHD.isBlank()) {
            return "Tự động khi lưu";
        }

        try {
            return String.format(
                    "HD%06d",
                    Integer.parseInt(maHD)
            );
        } catch (NumberFormatException e) {
            return maHD.startsWith("HD")
                    ? maHD
                    : "HD" + maHD;
        }
    }

    public String getMaBan() {
        return maBan;
    }

    public void setMaBan(String maBan) {
        this.maBan = maBan;
    }

    public String getMaNV() {
        return maNV;
    }

    public void setMaNV(String maNV) {
        this.maNV = maNV;
    }

    public String getMaKH() {
        return maKH;
    }

    public void setMaKH(String maKH) {
        this.maKH = maKH;
    }

    public String getTenKhachHang() {
        return tenKhachHang;
    }

    public void setTenKhachHang(String tenKhachHang) {
        this.tenKhachHang = tenKhachHang;
    }

    public String getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(String ngayTao) {
        this.ngayTao = ngayTao;
    }

    public double getTamTinh() {
        return tamTinh;
    }

    public void setTamTinh(double tamTinh) {
        this.tamTinh = tamTinh;
    }

    public double getThueVAT() {
        return thueVAT;
    }

    public void setThueVAT(double thueVAT) {
        this.thueVAT = thueVAT;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public int getDiemCong() {
        return diemCong;
    }

    public void setDiemCong(int diemCong) {
        this.diemCong = diemCong;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getDanhSachMon() {
        return danhSachMon;
    }

    public void setDanhSachMon(String danhSachMon) {
        this.danhSachMon = danhSachMon;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(
            String phuongThucThanhToan
    ) {
        this.phuongThucThanhToan =
                phuongThucThanhToan;
    }

    public String getNgayThanhToan() {
        return ngayThanhToan;
    }

    public void setNgayThanhToan(String ngayThanhToan) {
        this.ngayThanhToan = ngayThanhToan;
    }

    public String getHinhThuc() {
        return hinhThuc;
    }

    public void setHinhThuc(String hinhThuc) {
        this.hinhThuc = hinhThuc;
    }

    public String getLyDoHuy() {
        return lyDoHuy;
    }

    public void setLyDoHuy(String lyDoHuy) {
        this.lyDoHuy = lyDoHuy;
    }

    public boolean isMangVe() {
        return "Mang về".equalsIgnoreCase(hinhThuc);
    }
}