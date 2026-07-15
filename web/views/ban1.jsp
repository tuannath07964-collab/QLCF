<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.BanAn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý bàn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        body { display: flex; height: 100vh; background: #f7f5f2; }

        /* Sidebar */
        .sidebar { width: 250px; background: #4b3a2f; color: #fff; display: flex; flex-direction: column; justify-content: space-between; }
        .logo { padding: 22px; font-size: 20px; font-weight: bold; text-align: center; border-bottom: 1px solid rgba(255,255,255,.1); }
        .menu { list-style: none; }
        .menu li { padding: 16px 22px; cursor: pointer; display: flex; align-items: center; gap: 15px; transition: .3s; }
        .menu li:hover, .menu li.active { background: #6b5648; }
        .logout { padding: 20px; color: white; text-decoration: none; border-top: 1px solid rgba(255,255,255,.1); display: flex; gap: 15px; align-items: center; }
        .logout:hover { background: #6b5648; }

        /* Main Content */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .header { padding: 20px 30px; background: white; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .content { padding: 30px; overflow-y: auto; }
        .card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        
        /* Table */
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
        th { color: #555; background: #fcfcfc; }
        .btn-add { background: #1b9c5a; color: white; padding: 8px 15px; text-decoration: none; border-radius: 6px; }
        .btn-edit { color: #1976d2; text-decoration: none; margin-right: 15px; }
        .btn-delete { color: #d81b60; text-decoration: none; }
        table form { display: flex; gap: 10px; align-items: center; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div>
        <div class="logo"><i class="fa-solid fa-mug-hot"></i> QUẢN LÝ CAFE</div>
        <ul class="menu">
            <li onclick="location.href='UI.jsp'"><i class="fa-solid fa-house"></i> Trang chủ</li>
            <li onclick="location.href='nhanvien'"><i class="fa-solid fa-user"></i> Nhân viên</li>
            <li onclick="location.href='hoadon'"><i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn</li>
            <li onclick="location.href='menu'"><i class="fa-solid fa-mug-saucer"></i> Menu</li>
            <li class="active" onclick="location.href='ban'"><i class="fa-solid fa-chair"></i> Bàn</li>
            <li onclick="location.href='KhoServlet'"><i class="fa-solid fa-box"></i> Kho</li>
            <li onclick="location.href='khachhang'"><i class="fa-solid fa-users"></i> Khách hàng</li>
            <li onclick="location.href='ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> Thống kê</li>
        </ul>
    </div>
    <a class="logout" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
</aside>

<div class="main">
    <div class="header">
        <h3>Quản lý bàn</h3>
        <div class="user-info">TH08495 - Trần Dương Phương Hiếu <i class="fa-solid fa-bell"></i></div>
    </div>
    <div class="content">
        <div class="card">
            <div class="top">
                <h3>Danh sách bàn</h3>
                <a class="btn-add" href="ban?action=new"><i class="fa-solid fa-plus"></i> Thêm bàn</a>
            </div>
            <table>
                <tr>
                    <th>Mã bàn</th>
                    <th>Tên bàn</th>
                    <th>Trạng thái</th>
                    <th>Cập nhật</th>
                    <th>Thao tác</th>
                </tr>
                <%
                    ArrayList<BanAn> list = (ArrayList<BanAn>) request.getAttribute("listBan");
                    if (list != null) {
                        for (BanAn ban : list) {
                %>
                <tr>
                    <td><%= ban.getMaBan() %></td>
                    <td><%= ban.getTenBan() %></td>
                    <td><%= ban.getTrangThai() %></td>
                    <td>
                        <form action="ban" method="post">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="maBan" value="<%= ban.getMaBan() %>">
                            <select name="trangThai">
                                <option value="Trống" <%= "Trống".equals(ban.getTrangThai()) ? "selected" : "" %>>Trống</option>
                                <option value="Đang phục vụ" <%= "Đang phục vụ".equals(ban.getTrangThai()) ? "selected" : "" %>>Đang phục vụ</option>
                                <option value="Đã thanh toán" <%= "Đã thanh toán".equals(ban.getTrangThai()) ? "selected" : "" %>>Đã thanh toán</option>
                            </select>
                            <button type="submit">Lưu</button>
                        </form>
                    </td>
                    <td>
                        <a class="btn-edit" href="ban?action=edit&maBan=<%= ban.getMaBan() %>"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                        <a class="btn-delete" href="ban?action=delete&maBan=<%= ban.getMaBan() %>" onclick="return confirm('Xóa?')"><i class="fa-solid fa-trash"></i> Xóa</a>
                    </td>
                </tr>
                <% } } %>
            </table>
        </div>
    </div>
</div>

</body>
</html>