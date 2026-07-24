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
import model.MaGiamGia;

@WebServlet(name = "HoaDonServlet", urlPatterns = {"/hoadon"})
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO dao = new HoaDonDAO();
    private MenuDAO menuDao = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                request.setAttribute("listHoaDon", dao.getAll());
                request.setAttribute("discountList", dao.getAllMaGiamGia()); // Lấy danh sách mã giảm giá truyền sang giao diện
                request.getRequestDispatcher("/views/hoadon.jsp").forward(request, response);
                break;

            case "new":
                String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                HoaDon hdNew = new HoaDon();
                hdNew.setNgayTao(today);

                request.setAttribute("hoadon", hdNew);
                request.setAttribute("menuList", menuDao.getAllMenu());
                request.setAttribute("discountList", dao.getAllMaGiamGia());
                request.getRequestDispatcher("/views/hoadon1.jsp").forward(request, response);
                break;

            case "edit":
                String maHDEdit = request.getParameter("maHD");
                HoaDon hdEdit = dao.findById(maHDEdit);

                request.setAttribute("menuList", menuDao.getAllMenu());
                request.setAttribute("hoadon", hdEdit);
                request.setAttribute("discountList", dao.getAllMaGiamGia());
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

        // Xử lý thêm/sửa mã giảm giá nếu form modal gọi đến action này (ĐÃ ĐỒNG BỘ TIẾNG VIỆT)
        if ("addMaGiamGia".equals(action)) {
            MaGiamGia m = new MaGiamGia();
            m.setMaCode(request.getParameter("code"));
            m.setPhanTramGiam(Double.parseDouble(request.getParameter("percent")));
            m.setDieuKienDonToiTieu(Double.parseDouble(request.getParameter("minAmount")));
            m.setNgayHetHan(request.getParameter("endDate"));
            m.setTrangThai(Integer.parseInt(request.getParameter("status")));
            
            dao.insertMaGiamGia(m);
            response.sendRedirect("hoadon?action=list");
            return;
        } else if ("updateMaGiamGia".equals(action)) {
            MaGiamGia m = new MaGiamGia();
            m.setIDGiamGia(Integer.parseInt(request.getParameter("id")));
            m.setMaCode(request.getParameter("code"));
            m.setPhanTramGiam(Double.parseDouble(request.getParameter("percent")));
            m.setDieuKienDonToiTieu(Double.parseDouble(request.getParameter("minAmount")));
            m.setNgayHetHan(request.getParameter("endDate"));
            m.setTrangThai(Integer.parseInt(request.getParameter("status")));
            
            dao.updateMaGiamGia(m);
            response.sendRedirect("hoadon?action=list");
            return;
        }

        // Logic xử lý Hóa đơn mặc định của bạn
        String maHD = request.getParameter("maHD");
        String maBan = request.getParameter("maBan");
        String ngayTao = request.getParameter("ngayTao");
        String trangThai = request.getParameter("trangThai");
        
        String maNV = request.getParameter("maNV");
        if (maNV == null || maNV.isEmpty()) {
            maNV = (String) request.getSession().getAttribute("maNV");
        }

        String tongTienStr = request.getParameter("tongTien");
        double tongTien = 0;
        try {
            if (tongTienStr != null && !tongTienStr.isEmpty()) {
                tongTien = Double.parseDouble(tongTienStr);
            }
        } catch (NumberFormatException e) {
            tongTien = 0;
        }

        String danhSachMon = request.getParameter("danhSachMon");
        String maGiamGia = request.getParameter("maGiamGia");
        if (maGiamGia == null) {
            maGiamGia = "";
        }

        HoaDon hd = new HoaDon();
        hd.setMaHD(maHD);
        hd.setMaNV(maNV);
        hd.setMaBan(maBan);
        hd.setNgayTao(ngayTao);
        hd.setTrangThai(trangThai);
        hd.setTongTien(tongTien);
        hd.setDanhSachMon(danhSachMon);
        hd.setMaGiamGia(maGiamGia); 

        if ("insert".equals(action)) {
            dao.insertHoaDon(hd);
        } else if ("update".equals(action)) {
            dao.updateHoaDon(hd);
        }
        response.sendRedirect("hoadon?action=list");
    }
}