    package dao;

    import java.sql.Connection;
    import java.sql.PreparedStatement;
    import java.sql.ResultSet;
    import java.util.ArrayList;
    import model.Menu;

    public class MenuDAO {

        //===================== HIỂN THỊ =====================
        public ArrayList<Menu> getAll() {

            ArrayList<Menu> list = new ArrayList<>();

            String sql = "SELECT * FROM Menu";

            try {

                Connection con = DBConnect.getConnection();

                PreparedStatement ps = con.prepareStatement(sql);

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {

                    Menu m = new Menu();

                    m.setMaMon(rs.getInt("MaMon"));
                    m.setTenMon(rs.getString("TenMon"));
                    m.setLoai(rs.getString("Loai"));
                    m.setGia(rs.getDouble("Gia"));
                    m.setTrangThai(rs.getString("TrangThai"));
                    m.setHinhAnh(rs.getString("HinhAnh"));

                    list.add(m);

                }

                con.close();

            } catch (Exception e) {

                e.printStackTrace();

            }

            return list;

        }

        //===================== TÌM THEO ID =====================
        public Menu findById(int id) {

            String sql = "SELECT * FROM Menu WHERE MaMon=?";

            try {

                Connection con = DBConnect.getConnection();

                PreparedStatement ps = con.prepareStatement(sql);

                ps.setInt(1, id);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {

                    Menu m = new Menu();

                    m.setMaMon(rs.getInt("MaMon"));
                    m.setTenMon(rs.getString("TenMon"));
                    m.setLoai(rs.getString("Loai"));
                    m.setGia(rs.getDouble("Gia"));
                    m.setTrangThai(rs.getString("TrangThai"));
                    m.setHinhAnh(rs.getString("HinhAnh"));

                    return m;

                }

                con.close();

            } catch (Exception e) {

                e.printStackTrace();

            }

            return null;

        }
        //===================== THÊM MÓN =====================

        public boolean insert(Menu m) {

            String sql = "INSERT INTO Menu(TenMon,Loai,Gia,TrangThai,HinhAnh) VALUES(?,?,?,?,?)";

            try {

                Connection con = DBConnect.getConnection();

                PreparedStatement ps = con.prepareStatement(sql);

                ps.setString(1, m.getTenMon());
                ps.setString(2, m.getLoai());
                ps.setDouble(3, m.getGia());
                ps.setString(4, m.getTrangThai());
                ps.setString(5, m.getHinhAnh());

                int row = ps.executeUpdate();

                con.close();

                return row > 0;

            } catch (Exception e) {

                e.printStackTrace();

            }

            return false;

        }

        //===================== SỬA MÓN =====================
        public boolean update(Menu m) {

            String sql = "UPDATE Menu SET TenMon=?,Loai=?,Gia=?,TrangThai=?,HinhAnh=? WHERE MaMon=?";

            try {

                Connection con = DBConnect.getConnection();

                PreparedStatement ps = con.prepareStatement(sql);

                ps.setString(1, m.getTenMon());
                ps.setString(2, m.getLoai());
                ps.setDouble(3, m.getGia());
                ps.setString(4, m.getTrangThai());
                ps.setString(5, m.getHinhAnh());
                ps.setInt(6, m.getMaMon());

                int row = ps.executeUpdate();

                con.close();

                return row > 0;

            } catch (Exception e) {

                e.printStackTrace();

            }

            return false;

        }

        //===================== XÓA MÓN =====================
        public boolean delete(int id) {

            String sql = "DELETE FROM Menu WHERE MaMon=?";

            try {

                Connection con = DBConnect.getConnection();

                PreparedStatement ps = con.prepareStatement(sql);

                ps.setInt(1, id);

                int row = ps.executeUpdate();

                con.close();

                return row > 0;

            } catch (Exception e) {

                e.printStackTrace();

            }

            return false;

        }

    }
