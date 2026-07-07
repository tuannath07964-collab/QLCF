package controller;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.NhanVien;

@WebServlet("/nhanvien") // Đảm bảo URL này khớp
public class NhanVienServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Giả lập dữ liệu
        ArrayList<NhanVien> listNV = new ArrayList<>();
        // Sửa thành (đủ 9 tham số và dùng java.sql.Date.valueOf để tạo ngày)
        listNV.add(new NhanVien("NV01", "Nguyễn Văn A", "Nam",
                java.sql.Date.valueOf("1998-05-20"),
                "0901234567", "Hà Nội", "Thu ngân", 8000000.0, "Đang làm"));

        request.setAttribute("listNV", listNV);

        // Đảm bảo đường dẫn này đúng với vị trí file JSP của bạn
        request.getRequestDispatcher("/views/nhanvien.jsp").forward(request, response);
    }
}
