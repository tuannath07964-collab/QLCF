<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.HoaDon"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Hóa đơn</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    body { display:flex; background:#f4f6f9; }
    
    /* === CSS SIDEBAR CHUẨN THEO ẢNH === */
    .sidebar { width: 260px; height: 100vh; background: #4a3831; color: white; position: fixed; display: flex; flex-direction: column; }
    .logo { padding: 25px 20px; font-size: 18px; font-weight: 800; display: flex; align-items: center; justify-content: center; gap: 12px; line-height: 1.3; }
    .logo i { font-size: 24px; }
    .menu { flex: 1; margin-top: 10px; overflow-y: auto; }
    .menu a { display: flex; align-items: center; gap: 18px; padding: 15px 25px; color: #fdfdfd; text-decoration: none; font-size: 16px; border-left: 5px solid transparent; transition: 0.2s; }
    .menu a i { width: 22px; text-align: center; font-size: 18px; }
    .menu a:hover { background: #5c473f; }
    .menu a.active { background: #6a5349; border-left: 5px solid white; font-weight: 500; }
    .logout-section { border-top: 1px solid #3c2d27; }
    .logout-section a { display: flex; align-items: center; gap: 18px; padding: 20px 25px; color: white; text-decoration: none; font-size: 16px; transition: 0.2s; border-left: 5px solid transparent; }
    .logout-section a:hover { background: #5c473f; }
    .logout-section a i { width: 22px; text-align: center; font-size: 18px; }
    
    /* === CSS MAIN CONTENT === */
    .main { margin-left:260px; width:calc(100% - 260px); }
    .header { height: 70px; background: white; display: flex; justify-content: space-between; align-items: center; padding: 0 40px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    .user-info { display: flex; align-items: center; gap: 10px; font-weight: 500; font-size: 15px; color: #333; }
    .user-info i { font-size: 20px; color: #666; }
    .content { padding: 30px 40px; }
    .card { background: white; border-radius: 8px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .top h3 { color: #333; font-size: 20px; }
    table { width: 100%; border-collapse: collapse; }
    table th { background: #f8f9fa; color: #333; padding: 15px; font-size: 14px; border-bottom: 2px solid #dee2e6; text-align: center; }
    table td { padding: 15px; border-bottom: 1px solid #eee; text-align: center; color: #444; font-size: 14px; }
    .btn-add { background: #4a3831; color: white; padding: 10px 18px; border-radius: 5px; text-decoration: none; font-size: 14px; font-weight: 500; }
    .btn-add:hover { background: #6a5349; }
    .btn-edit { background: #ffc107; color: #000; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 500; }
    .btn-delete { background: #dc3545; color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 500; }
    button[type="submit"] { background: #28a745; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: 500; }
    select { padding: 5px; border-radius: 4px; border: 1px solid #ccc; }
    .chuathanhtoan { color: #dc3545; font-weight: bold; }
    .dathanhtoan { color: #28a745; font-weight: bold; }
    .dahuy { color: #6c757d; font-weight: bold; text-decoration: line-through; }
</style>
</head>
<body>

<!-- SIDEBAR GIỐNG 100% ẢNH MỚI NHẤT -->
<div class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-mug-hot"></i>
        <div style="text-align: left;">QUẢN LÝ QUÁN<br>CAFE</div>
    </div>
    
    <div class="menu">
        <a href="${pageContext.request.contextPath}/views/homepage.jsp">
            <i class="fa-solid fa-house"></i> Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/views/nhanvien.jsp">
            <i class="fa-solid fa-user"></i> Nhân viên
        </a>
        <a class="active" href="${pageContext.request.contextPath}/hoadon">
            <i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn
        </a>
        <a href="${pageContext.request.contextPath}/views/menu.jsp">
            <i class="fa-solid fa-coffee"></i> Menu
        </a>
        <a href="${pageContext.request.contextPath}/ban">
            <i class="fa-solid fa-chair"></i> Bàn
        </a>
        <a href="${pageContext.request.contextPath}/views/kho.jsp">
            <i class="fa-solid fa-box"></i> Kho
        </a>
        <a href="${pageContext.request.contextPath}/views/khachhang.jsp">
            <i class="fa-solid fa-users"></i> Khách hàng
        </a>
        <a href="${pageContext.request.contextPath}/views/ThongKeDoanhThu.jsp">
            <i class="fa-solid fa-chart-column"></i> Thống kê
        </a>
        <a href="${pageContext.request.contextPath}/views/caidat.jsp">
            <i class="fa-solid fa-gear"></i> Cài đặt
        </a>
    </div>

    <div class="logout-section">
        <a href="${pageContext.request.contextPath}/LoginServlet">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<div class="main">
    <div class="header">
        <h3 style="color: #4a3831;">Quản lý Hóa đơn</h3>
        <div class="user-info">
            <i class="fa-solid fa-circle-user"></i>
            <span>TH08199 - Trịnh Bình Minh</span>
        </div>
    </div>

    <div class="content">
        <div class="card">
            <div class="top">
                <h3>Danh sách Hóa đơn</h3>
                <a class="btn-add" href="hoadon?action=new"><i class="fa-solid fa-plus"></i> Thêm hóa đơn mới</a>
            </div>

            <table>
                <tr>
                    <th>Mã HĐ</th>
                    <th>Mã Bàn</th>
                    <th>Thu ngân</th>
                    <th>Ngày tạo</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Cập nhật</th>
                    <th>Thao tác</th>
                </tr>
                <%
                    ArrayList<HoaDon> list = (ArrayList<HoaDon>) request.getAttribute("listHoaDon");
                    if (list != null) {
                        for (HoaDon hd : list) {
                            String cssClass = "";
                            if ("Chưa thanh toán".equals(hd.getTrangThai())) cssClass = "chuathanhtoan";
                            else if ("Đã thanh toán".equals(hd.getTrangThai())) cssClass = "dathanhtoan";
                            else if ("Đã hủy".equals(hd.getTrangThai())) cssClass = "dahuy";
                %>
                <tr>
                    <td><%= hd.getMaHD() %></td>
                    <td><strong><%= hd.getMaBan() %></strong></td>
                    <td><%= hd.getMaNV() %></td>
                    <td><%= hd.getNgayTao() %></td>
                    <td style="font-weight: bold; color: #d32f2f;"><%= String.format("%,.0f", hd.getTongTien()) %> đ</td>
                    <td class="<%= cssClass %>"><%= hd.getTrangThai() %></td>
                    <td>
                        <form action="hoadon" method="post" style="display:flex; justify-content:center; gap:5px;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="maHD" value="<%= hd.getMaHD() %>">
                            <select name="trangThai">
                                <option value="Chưa thanh toán" <%= "Chưa thanh toán".equals(hd.getTrangThai()) ? "selected" : "" %>>Chưa TT</option>
                                <option value="Đã thanh toán" <%= "Đã thanh toán".equals(hd.getTrangThai()) ? "selected" : "" %>>Đã TT</option>
                                <option value="Đã hủy" <%= "Đã hủy".equals(hd.getTrangThai()) ? "selected" : "" %>>Đã hủy</option>
                            </select>
                            <button type="submit"><i class="fa-solid fa-check"></i> Lưu</button>
                        </form>
                    </td>
                    <td>
                        <a class="btn-edit" href="hoadon?action=edit&maHD=<%= hd.getMaHD() %>"><i class="fa-solid fa-pen"></i></a>
                        <a class="btn-delete" href="hoadon?action=delete&maHD=<%= hd.getMaHD() %>" onclick="return confirm('Xóa hóa đơn này?')"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
                <% } } %>
            </table>
        </div>
    </div>
</div>

</body>
</html>