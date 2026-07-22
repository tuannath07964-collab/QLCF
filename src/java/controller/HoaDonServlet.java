package controller;

import dao.HoaDonDAO;
import dao.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.HoaDon;

@WebServlet(name = "HoaDonServlet", urlPatterns = {"/hoadon"})
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO dao = new HoaDonDAO();
    private MenuDAO menuDao = new MenuDAO();

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
                request.setAttribute("listHoaDon", dao.getAll());
                request.getRequestDispatcher("/views/hoadon.jsp").forward(request, response);
                break;

            case "new":
                // Dùng định dạng yyyy-MM-dd cho chuẩn với kiểu Date/String trong database SQL
                String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

                HoaDon hdNew = new HoaDon();
                hdNew.setNgayTao(today);

                request.setAttribute("hoadon", hdNew);
                request.setAttribute("menuList", menuDao.getAllMenu());
                request.getRequestDispatcher("/views/hoadon1.jsp").forward(request, response);
                break;

            case "edit":
                String maHDEdit = request.getParameter("maHD");
                HoaDon hdEdit = dao.findById(maHDEdit);

                request.setAttribute("menuList", menuDao.getAllMenu());
                request.setAttribute("hoadon", hdEdit);
                request.getRequestDispatcher("/views/hoadon1.jsp").forward(request, response);
                break;

            case "delete":
                String maHDDelete = request.getParameter("maHD");
                dao.delete(maHDDelete);
                response.sendRedirect("hoadon?action=list");
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
            if (request.getParameter("tongTien") != null && !request.getParameter("tongTien").isEmpty()) {
                tongTien = Double.parseDouble(request.getParameter("tongTien"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if ("insert".equals(action)) {
            HoaDon hd = new HoaDon(maHD, maBan, maNV, ngayTao, tongTien, trangThai);
            dao.insert(hd);
            if (maBan != null && !maBan.isEmpty()) {
                dao.updateBanStatus(maBan, "Đang phục vụ");
            }
        } else if ("update".equals(action)) {
            HoaDon hd = new HoaDon(maHD, maBan, maNV, ngayTao, tongTien, trangThai);
            dao.update(hd);
        } else if ("updateStatus".equals(action)) {
            dao.updateStatus(maHD, trangThai);
            if ("Đã thanh toán".equals(trangThai) && maBan != null) {
                dao.updateBanStatus(maBan, "Trống");
            }
        }

        // Quan trọng: Thêm lệnh này để sau khi xử lý xong sẽ quay về trang danh sách hoadon.jsp
        response.sendRedirect("hoadon?action=list");
    }
}
