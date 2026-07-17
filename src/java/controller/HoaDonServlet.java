package controller;

import dao.HoaDonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.HoaDon;

@WebServlet(name = "HoaDonServlet", urlPatterns = {"/hoadon"})
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO dao = new HoaDonDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                ArrayList<HoaDon> list = dao.getAll();
                // In ra console để kiểm tra xem có lấy được dữ liệu từ DB không
                System.out.println("DEBUG: So luong hoa don lay duoc la: " + (list != null ? list.size() : "null"));

                request.setAttribute("listHoaDon", list);
                request.getRequestDispatcher("/views/hoadon.jsp").forward(request, response);
                break;

            case "new":
                String today = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
                String nextMaHD = dao.getNextMaHD();

                HoaDon hdNew = new HoaDon();
                hdNew.setMaHD(nextMaHD);
                hdNew.setNgayTao(today);

                request.setAttribute("hoadon", hdNew);
                request.getRequestDispatcher("/views/hoadon1.jsp").forward(request, response);
                break;

            case "edit":
                String maHDEdit = request.getParameter("maHD");
                HoaDon hdEdit = dao.findById(maHDEdit);
                request.setAttribute("hoadon", hdEdit);
                request.getRequestDispatcher("/views/hoadon1.jsp").forward(request, response);
                break;

            case "delete":
                String maHDDelete = request.getParameter("maHD");
                dao.delete(maHDDelete);
                response.sendRedirect("hoadon?action=list"); // Redirect về danh sách
                break;

            default:
                response.sendRedirect("hoadon?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String maHD = request.getParameter("maHD");
        String maBan = request.getParameter("maBan");
        String maNV = request.getParameter("maNV");
        String ngayTao = request.getParameter("ngayTao");
        String trangThai = request.getParameter("trangThai");

        double tongTien = 0;
        try {
            if (request.getParameter("tongTien") != null) {
                tongTien = Double.parseDouble(request.getParameter("tongTien"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if ("insert".equals(action)) {
            HoaDon hd = new HoaDon(maHD, maBan, maNV, ngayTao, tongTien, trangThai);
            dao.insert(hd);
            // Khi tạo hóa đơn, bàn chuyển thành Đang phục vụ
            dao.updateBanStatus(maBan, "Đang phục vụ");
        } else if ("update".equals(action)) {
            HoaDon hd = new HoaDon(maHD, maBan, maNV, ngayTao, tongTien, trangThai);
            dao.update(hd);
        } else if ("updateStatus".equals(action)) {
            dao.updateStatus(maHD, trangThai);
            // Nếu chuyển sang Đã thanh toán, dọn bàn về Trống
            if ("Đã thanh toán".equals(trangThai)) {
                dao.updateBanStatus(maBan, "Trống");
            }
        }

        response.sendRedirect("hoadon");
    }
}
