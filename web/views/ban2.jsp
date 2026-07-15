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
        * { margin:0; padding:0; box-sizing:border-box; font-family: Arial, sans-serif; }
        body { display:flex; height:100vh; background:#f7f5f2; }

        /* Sidebar - Đã căn chỉnh flex */
        .sidebar { width: 250px; background: #4b3a2f; color: #fff; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
        .logo { padding: 22px; font-size: 20px; font-weight: bold; text-align: center; border-bottom: 1px solid rgba(255,255,255,.1); }
        .menu { margin-top: 20px; list-style: none; }
        .menu a { display: flex; align-items: center; gap: 15px; padding: 16px 25px; color: white; text-decoration: none; transition: .3s; }
        .menu a:hover, .menu a.active { background: #6b5648; }
        .logout-section { padding: 20px 25px; border-top: 1px solid #423630; }
        .logout-section a { color: white; text-decoration: none; display: flex; align-items: center; gap: 15px; }

        /* Main Content */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .header { height: 70px; background: white; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .user-info { display: flex; align-items: center; gap: 15px; font-weight: 600; }
        .content { padding: 30px; overflow-y: auto; display: flex; justify-content: center; }
        
        /* Card Form */
        .card { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); width: 100%; max-width: 500px; }
        label { display:block; margin: 15px 0 8px; font-weight: 600; color: #555; }
        input, select { width:100%; padding: 12px; border:1px solid #ddd; border-radius:6px; }
        .button-group { display:flex; gap: 10px; margin-top: 25px; }
        .btn-save { background: #1b9c5a; color: white; border: none; padding: 12px; border-radius: 6px; cursor: pointer; flex: 1; font-weight: bold; }
        .btn-back { background: #6c757d; color: white; padding: 12px; border-radius: 6px; text-decoration: none; text-align: center; flex: 1; font-weight: bold; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <div class="logo">QUẢN LÝ QUÁN CAFE</div>
            <div class="menu">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-house"></i> Trang chủ</a>
                <a class="active" href="ban"><i class="fa-solid fa-chair"></i> Quản lý bàn</a>
                <a href="${pageContext.request.contextPath}/views/menu.jsp"><i class="fa-solid fa-utensils"></i> Thực đơn</a>
                <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-receipt"></i> Hóa đơn</a>
                <a href="${pageContext.request.contextPath}/views/nhanvien.jsp"><i class="fa-solid fa-users"></i> Nhân viên</a>
                <a href="${pageContext.request.contextPath}/views/kho.jsp"><i class="fa-solid fa-box"></i> Kho</a>
                <a href="${pageContext.request.contextPath}/views/ThongKeDoanhThu.jsp"><i class="fa-solid fa-chart-line"></i> Thống kê</a>
            </div>
        </div>
        <div class="logout-section">
            <a href="${pageContext.request.contextPath}/LoginServlet">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
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