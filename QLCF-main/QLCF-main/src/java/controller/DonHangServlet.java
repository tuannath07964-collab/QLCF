package controller;


import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.DonHang;

@WebServlet("/donhang")
public class DonHangServlet extends HttpServlet {

    // CHÚ Ý: Đưa danh sách ra ngoài làm biến toàn cục để mô phỏng Database
    // Nếu để trong doGet, mỗi lần tải trang nó sẽ bị tạo mới lại từ đầu
    private ArrayList<DonHang> dsDonHang;

    @Override
    public void init() throws ServletException {
        // Khởi tạo dữ liệu 1 lần duy nhất khi server chạy
        dsDonHang = new ArrayList<>();
        dsDonHang.add(new DonHang("DH01", "B01", "Nguyễn Minh Đăng", "08:30 05/07/2026", 75000, "Đang phục vụ"));
        dsDonHang.add(new DonHang("DH02", "B02", "Nguyễn Anh Tuấn", "09:10 05/07/2026", 120000, "Chờ thanh toán"));
        dsDonHang.add(new DonHang("DH03", "B03", "Phùng Chí Trung", "09:45 05/07/2026", 45000, "Đã thanh toán"));
        dsDonHang.add(new DonHang("DH04", "B04", "Trịnh Bình Minh", "10:00 05/07/2026", 60000, "Đang phục vụ"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Lấy tham số từ URL khi người dùng bấm nút
        String action = request.getParameter("action");
        String maDon = request.getParameter("maDon");

        // NGHIỆP VỤ: Xử lý chuyển đổi trạng thái tuần tự
        if ("doiTrangThai".equals(action) && maDon != null) {
            for (DonHang dh : dsDonHang) {
                if (dh.getMaDonHang().equals(maDon)) {
                    String trangThaiHienTai = dh.getTrangThai();
                    
                    // Logic xoay vòng trạng thái
                    if (trangThaiHienTai.equals("Đang phục vụ")) {
                        dh.setTrangThai("Chờ thanh toán");
                    } else if (trangThaiHienTai.equals("Chờ thanh toán")) {
                        dh.setTrangThai("Đã thanh toán");
                    } else {
                        dh.setTrangThai("Đang phục vụ");
                    }
                    break;
                }
            }
            // Chuyển hướng lại trang danh sách để cập nhật giao diện (tránh lỗi F5)
            response.sendRedirect("donhang");
            return;
        }

        // Truyền dữ liệu sang JSP
        request.setAttribute("dsDonHang", dsDonHang);

        // Chuyển hướng sang giao diện
        request.getRequestDispatcher("/views/Donhang.jsp").forward(request, response);
    }
}