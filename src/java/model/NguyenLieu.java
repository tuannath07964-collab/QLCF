package model;

public class NguyenLieu {

    private String maNguyenLieu;
    private String tenNguyenLieu;
    private int soLuongTon;
    private int mucNhapCoDinh;
    private String donVi;
    private boolean trangThai;
    private String sanPhamSuDung;

    public NguyenLieu() {
    }

    public String getMaNguyenLieu() {
        return maNguyenLieu;
    }

    public void setMaNguyenLieu(String maNguyenLieu) {
        this.maNguyenLieu = maNguyenLieu;
    }

    public String getTenNguyenLieu() {
        return tenNguyenLieu;
    }

    public void setTenNguyenLieu(String tenNguyenLieu) {
        this.tenNguyenLieu = tenNguyenLieu;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public int getMucNhapCoDinh() {
        return mucNhapCoDinh;
    }

    public void setMucNhapCoDinh(int mucNhapCoDinh) {
        this.mucNhapCoDinh = mucNhapCoDinh;
    }

    public String getDonVi() {
        return donVi;
    }

    public void setDonVi(String donVi) {
        this.donVi = donVi;
    }

    public boolean isTrangThai() {
        return trangThai;
    }

    public void setTrangThai(boolean trangThai) {
        this.trangThai = trangThai;
    }

    public String getSanPhamSuDung() {
        return sanPhamSuDung;
    }

    public void setSanPhamSuDung(String sanPhamSuDung) {
        this.sanPhamSuDung = sanPhamSuDung;
    }

    public boolean isHetHang() {
        return soLuongTon <= 0;
    }

    public boolean isSapHet() {
        return soLuongTon > 0
                && soLuongTon <= mucNhapCoDinh;
    }

    public String getTrangThaiKho() {
        if (!trangThai) {
            return "Ngừng sử dụng";
        }

        if (isHetHang()) {
            return "Hết hàng";
        }

        if (isSapHet()) {
            return "Sắp hết";
        }

        return "Còn hàng";
    }
}