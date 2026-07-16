<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.HoaDon"%>
<%
    HoaDon hd = (HoaDon) request.getAttribute("hoadon");
    boolean isEdit = hd != null;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= isEdit ? "Sửa Hóa Đơn" : "Thêm Hóa Đơn" %></title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nhanvien.css">
        <style>
            /* Chỉ giữ lại style cho form thôi, còn sidebar/main đã ăn theo css file ngoài */
            .card-form {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.05);
                max-width: 600px;
                margin: 20px auto;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            input, select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 6px;
            }
            .button-group {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }
            .btn-save {
                background: #27ae60;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }
            .btn-back {
                background: #7f8c8d;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 6px;
            }
        </style>
    </head>
    <body>

        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-mug-hot"></i> 
                <span class="logo-text">QUẢN LÝ QUÁN CAFE</span>
                <button id="toggleBtn" type="button"><i class="fa-solid fa-bars"></i></button>
            </div>
            <ul class="menu">
                <li onclick="location.href = 'homepage.jsp'"> <i class="fa-solid fa-house"></i> Trang chủ</li>
                <li onclick="location.href = 'nhanvien'"> <i class="fa-solid fa-user"></i> Nhân viên</li>
                <li class="active"> <i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn</li>
                <li onclick="location.href = 'menu'"> <i class="fa-solid fa-mug-saucer"></i> Menu</li>
                <li onclick="location.href = 'ban'"> <i class="fa-solid fa-chair"></i> Bàn</li>
                <li onclick="location.href = 'KhoServlet'"> <i class="fa-solid fa-box"></i> Kho</li>
                <li onclick="location.href = 'khachhang'"> <i class="fa-solid fa-users"></i> Khách hàng</li>
                <li onclick="location.href = 'ThongKeServlet'"> <i class="fa-solid fa-chart-column"></i> Thống kê</li>
            </ul>
            <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span></a>
        </aside>

        <div class="main">
            <div class="header">
                <h2><%= isEdit ? "Sửa Hóa Đơn" : "Thêm Hóa Đơn" %></h2>
                <div>Trịnh Bình Minh</div>
            </div>

            <div class="card">
                <h3><i class="fa-solid fa-receipt"></i> <%= isEdit ? "SỬA HÓA ĐƠN" : "THÔNG TIN HÓA ĐƠN MỚI" %></h3>
                <form action="hoadon" method="post">
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "insert" %>">

                    <label>Mã hóa đơn</label>
                    <input type="text" name="maHD" value="<%= isEdit ? hd.getMaHD() : "" %>" <%= isEdit ? "readonly" : "" %> required placeholder="Nhập mã HĐ (VD: HD008)">

                    <label>Mã bàn</label>
                    <input type="text" name="maBan" value="<%= isEdit ? hd.getMaBan() : "" %>" required placeholder="Nhập mã bàn (VD: B01)">

                    <label>Mã nhân viên (Thu ngân)</label>
                    <input type="text" name="maNV" value="<%= isEdit ? hd.getMaNV() : "" %>" required placeholder="Nhập mã nhân viên">

                    <label>Ngày tạo (DD/MM/YYYY)</label>
                    <input type="text" name="ngayTao" value="<%= isEdit ? hd.getNgayTao() : "" %>" required placeholder="Ví dụ: 16/07/2026">

                    <label>Tổng tiền (VNĐ)</label>
                    <input type="number" name="tongTien" value="<%= isEdit ? String.format("%.0f", hd.getTongTien()) : "0" %>" min="0" required>

                    <label>Trạng thái</label>
                    <select name="trangThai">
                        <option value="Chưa thanh toán" <%= isEdit && "Chưa thanh toán".equals(hd.getTrangThai()) ? "selected" : "" %>>Chưa thanh toán</option>
                        <option value="Đã thanh toán" <%= isEdit && "Đã thanh toán".equals(hd.getTrangThai()) ? "selected" : "" %>>Đã thanh toán</option>
                        <option value="Đã hủy" <%= isEdit && "Đã hủy".equals(hd.getTrangThai()) ? "selected" : "" %>>Đã hủy</option>
                    </select>

                    <div class="button-group">
                        <button class="btn-save" type="submit"><i class="fa-solid fa-floppy-disk"></i> <%= isEdit ? "Cập nhật" : "Tạo mới" %></button>
                        <a class="btn-back" href="hoadon"><i class="fa-solid fa-arrow-left"></i> Hủy</a>
                    </div>
                </form>
            </div>
        </div>

    </body>
</html>