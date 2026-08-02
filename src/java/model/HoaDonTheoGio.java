package model;

public class HoaDonTheoGio {

    private int gio;
    private int soHoaDon;

    public HoaDonTheoGio() {
    }

    public HoaDonTheoGio(
            int gio,
            int soHoaDon
    ) {
        this.gio = gio;
        this.soHoaDon = soHoaDon;
    }

    public int getGio() {
        return gio;
    }

    public void setGio(int gio) {
        this.gio = gio;
    }

    public int getSoHoaDon() {
        return soHoaDon;
    }

    public void setSoHoaDon(int soHoaDon) {
        this.soHoaDon = soHoaDon;
    }

    public String getGioHienThi() {
        return String.format(
                "%02d:00",
                gio
        );
    }
}