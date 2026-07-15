package controller;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Nếu bạn đã có class model HoaDon hoặc tương tự, hãy import vào đây. 
// Ví dụ: import model.HoaDon;

@WebServlet("/ThongKeServlet")
public class ThongKeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra quyền đăng nhập giống như hệ thống của bạn (bảo mật)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("maNV") == null) {
            // Nếu chưa đăng nhập, đá về trang login
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 2. Tạo dữ liệu mẫu cho danh sách hóa đơn doanh thu (tương tự cách bạn làm ở khoServlet)
        // Chú ý: Ở đây tôi dùng một Class giả lập Object[] để bạn dễ hiển thị dữ liệu lên bảng jsp trước.
        // Khi nào bạn có model HoaDon cụ thể, chỉ cần thay thế Object[] bằng tên model của bạn.
        ArrayList<Object[]> dsHoaDon = new ArrayList<>();

        // Thêm dữ liệu chạy thử nghiệm: { Mã HD, Ngày thanh toán, Phương thức, Tổng tiền }
        dsHoaDon.add(new Object[]{"HD001", "14/07/2026", "Tiền mặt", "150,000đ"});
        dsHoaDon.add(new Object[]{"HD002", "14/07/2026", "Chuyển khoản", "320,000đ"});
        dsHoaDon.add(new Object[]{"HD003", "13/07/2026", "Tiền mặt", "85,000đ"});
        dsHoaDon.add(new Object[]{"HD004", "12/07/2026", "Chuyển khoản", "450,000đ"});

        // 3. Đẩy danh sách này sang giao diện hiển thị
        request.setAttribute("dsThongKe", dsHoaDon);

        // 4. Chuyển hướng sang file JSP nằm trong thư mục views
        request.getRequestDispatcher("/views/ThongKeDoanhThu.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}