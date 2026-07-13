<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.BanAn"%>
<%
    BanAn ban = (BanAn) request.getAttribute("ban");
    boolean isEdit = ban != null;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= isEdit ? "Sửa bàn" : "Thêm bàn" %></title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            * {
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family: 'Segoe UI', Arial, sans-serif;
            }
            body {
                display:flex;
                background:#f4f6f9;
            }

            /* Sidebar */
            .sidebar {
                width:250px;
                height:100vh;
                background:#2d221d;
                color:white;
                position:fixed;
            }
            .logo {
                padding:25px;
                text-align:center;
                font-size: 18px;
                font-weight: bold;
            }
            .menu {
                margin-top:20px;
            }
            .menu a {
                display:block;
                padding:15px 25px;
                color:#bbb;
                text-decoration:none;
                transition:.3s;
            }
            .menu a:hover, .menu a.active {
                background:#423630;
                color:white;
            }
            .logout-section {
                position: absolute;
                bottom: 0;
                width: 100%;
            }

            /* Main */
            .main {
                margin-left:250px;
                width:calc(100% - 250px);
            }
            .header {
                height: 60px;
                background: white;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 30px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 15px;
                font-weight: 500;
                font-size: 14px;
            }

            /* Content */
            .content {
                padding: 30px;
            }
            .card {
                background: white;
                border-radius: 10px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                max-width: 600px;
                margin: 0 auto;
            }
            .card h3 {
                margin-bottom: 20px;
                color: #333;
            }
            label {
                display:block;
                margin: 15px 0 8px;
                font-weight: 600;
                color: #555;
                font-size: 14px;
            }
            input, select {
                width:100%;
                padding: 10px;
                border:1px solid #ddd;
                border-radius:5px;
                font-size: 14px;
            }
            .button-group {
                display:flex;
                gap: 10px;
                margin-top: 25px;
            }
            .btn-save {
                background: #28a745;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                flex: 1;
            }
            .btn-back {
                background: #6c757d;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                font-size: 14px;
                text-align: center;
                flex: 1;
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
    <div class="logo">QUẢN LÝ QUÁN CAFE</div>
    <div class="menu">
        <a href="${pageContext.request.contextPath}/views/homepage.jsp">
        <i class="fa-solid fa-house"></i> Trang chủ
        </a>
        <a class="active" href="ban"><i class="fa-solid fa-chair"></i> Quản lý bàn</a>
        <a href="${pageContext.request.contextPath}/views/menu.jsp">
        <i class="fa-solid fa-utensils"></i> Thực đơn
        </a>
        <a href="${pageContext.request.contextPath}/views/homepage.jsp">
            <i class="fa-solid fa-receipt"></i> Hóa đơn
        </a>
        <a href="${pageContext.request.contextPath}/views/nhanvien.jsp">
            <i class="fa-solid fa-users"></i> Nhân viên
        </a>
        <a href="${pageContext.request.contextPath}/views/kho.jsp">
            <i class="fa-solid fa-box"></i> Kho
        </a>
        <a href="${pageContext.request.contextPath}/views/ThongKeDoanhThu.jsp">
            <i class="fa-solid fa-chart-line"></i> Thống kê
        </a>
    </div>

        <div class="main">
            <div class="header">
                <h3><%= isEdit ? "Sửa bàn" : "Thêm bàn" %></h3>
                <div class="user-info">
                    <span>TH08495 - Trần Dương Phương Hiếu</span>
                    <i class="fa-solid fa-bell"></i>
                </div>
            </div>

            <div class="content">
                <div class="card">
                    <h3>Thông tin bàn</h3>
                    <form action="ban" method="post">
                        <input type="hidden" name="action" value="<%= isEdit ? "update" : "insert" %>">

                        <label>Mã bàn</label>
                        <input type="text" name="maBan" value="<%= isEdit ? ban.getMaBan() : "" %>" <%= isEdit ? "readonly" : "" %> required>

                        <label>Tên bàn</label>
                        <input type="text" name="tenBan" value="<%= isEdit ? ban.getTenBan() : "" %>" required>

                        <label>Trạng thái</label>
                        <select name="trangThai">
                            <option value="Trống" <%= isEdit && "Trống".equals(ban.getTrangThai()) ? "selected" : "" %>>Trống</option>
                            <option value="Đang phục vụ" <%= isEdit && "Đang phục vụ".equals(ban.getTrangThai()) ? "selected" : "" %>>Đang phục vụ</option>
                            <option value="Đã thanh toán" <%= isEdit && "Đã thanh toán".equals(ban.getTrangThai()) ? "selected" : "" %>>Đã thanh toán</option>
                        </select>

                        <div class="button-group">
                            <button class="btn-save" type="submit"><i class="fa-solid fa-floppy-disk"></i> <%= isEdit ? "Cập nhật" : "Lưu" %></button>
                            <a class="btn-back" href="ban"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>