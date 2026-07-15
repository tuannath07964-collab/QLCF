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
        .content { padding: 40px; }
        .card { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); max-width: 600px; margin: 0 auto; }
        .card h3 { color: #333; font-size: 22px; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 20px; text-align: center;}
        label { display:block; margin: 15px 0 8px; font-weight: 600; color: #444; font-size: 14px; }
        input, select { width:100%; padding: 12px; border:1px solid #ddd; border-radius:5px; font-size: 14px; background: #fafafa; }
        input:focus, select:focus { outline: none; border-color: #4a3831; background: #fff; }
        .button-group { display:flex; gap: 15px; margin-top: 30px; }
        .btn-save { background: #4a3831; color: white; border: none; padding: 12px 20px; border-radius: 5px; cursor: pointer; flex: 1; font-size: 15px; font-weight: bold; transition: 0.2s; }
        .btn-save:hover { background: #6a5349; }
        .btn-back { background: #e0e0e0; color: #333; padding: 12px 20px; border-radius: 5px; text-decoration: none; text-align: center; flex: 1; font-size: 15px; font-weight: bold; transition: 0.2s; }
        .btn-back:hover { background: #ccc; }
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
            <h3 style="color: #4a3831;"><%= isEdit ? "Sửa thông tin" : "Tạo Hóa đơn" %></h3>
            <div class="user-info">
                <i class="fa-solid fa-circle-user"></i>
                <span>TH08199 - Trịnh Bình Minh</span>
            </div>
        </div>

        <div class="content">
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
    </div>

</body>
</html>