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
    * { margin:0; padding:0; box-sizing:border-box; font-family: 'Segoe UI', Arial, sans-serif; }
    body { display:flex; background:#f4f6f9; }

    /* SIDEBAR */
    .sidebar { width:250px; height:100vh; background:#2d221d; color:white; position:fixed; }
    .logo { padding:25px; text-align:center; font-size: 18px; font-weight: bold; }
    .menu { margin-top:20px; }
    .menu a { display:block; padding:15px 25px; color:#bbb; text-decoration:none; transition:.3s; }
    .menu a:hover, .menu a.active { background:#423630; color:white; }

    /* MAIN */
    .main { margin-left:250px; width:calc(100% - 250px); }
    
    /* HEADER MỚI */
    .header { height: 60px; background: white; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .user-info { display: flex; align-items: center; gap: 15px; font-weight: 500; font-size: 14px; }

    /* CONTENT */
    .content { padding: 30px; }
    .card { background: white; border-radius: 10px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    
    /* TABLE */
    table { width: 100%; border-collapse: collapse; }
    table th { background: #5d4037; color: white; padding: 15px; font-size: 14px; }
    table td { padding: 15px; border-bottom: 1px solid #eee; text-align: center; color: #333; }
    
    /* NÚT VÀ STATUS */
    .btn-add { background: #28a745; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-size: 14px; }
    .btn-edit { background: #ffc107; color: black; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 12px; }
    .btn-delete { background: #dc3545; color: white; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 12px; }
    button[type="submit"] { background: #007bff; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
    
    .trong { color: #28a745; font-weight: bold; }
    .dangphucvu { color: #ff9800; font-weight: bold; }
    .dathanhtoan { color: #2196f3; font-weight: bold; }
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
        <a href="#"><i class="fa-solid fa-utensils"></i> Thực đơn</a>
        <a href="#"><i class="fa-solid fa-receipt"></i> Hóa đơn</a>
        <a href="#"><i class="fa-solid fa-users"></i> Nhân viên</a>
        <a href="#"><i class="fa-solid fa-box"></i> Kho</a>
        <a href="#"><i class="fa-solid fa-chart-line"></i> Thống kê</a>
    </div>

    <div class="logout-section" style="position: absolute; bottom: 0; width: 100%;">
        <a href="${pageContext.request.contextPath}/LoginServlet" style="display:block; padding:20px 25px; color:white; text-decoration:none; border-top:1px solid #423630;">
        <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
    </div>

<div class="main">
    <div class="header">
        <h3>Quản lý bàn</h3>
        <div class="user-info">
            <span>TH08495 - Trần Dương Phương Hiếu</span>
            <i class="fa-solid fa-bell"></i>
        </div>
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
                            String cssClass = "";
                            if ("Trống".equals(ban.getTrangThai())) cssClass = "trong";
                            else if ("Đang phục vụ".equals(ban.getTrangThai())) cssClass = "dangphucvu";
                            else if ("Đã thanh toán".equals(ban.getTrangThai())) cssClass = "dathanhtoan";
                %>
                <tr>
                    <td><%= ban.getMaBan() %></td>
                    <td><%= ban.getTenBan() %></td>
                    <td class="<%= cssClass %>"><%= ban.getTrangThai() %></td>
                    <td>
                        <form action="ban" method="post" style="display:flex; justify-content:center; gap:5px;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="maBan" value="<%= ban.getMaBan() %>">
                            <select name="trangThai">
                                <option value="Trống" <%= "Trống".equals(ban.getTrangThai()) ? "selected" : "" %>>Trống</option>
                                <option value="Đang phục vụ" <%= "Đang phục vụ".equals(ban.getTrangThai()) ? "selected" : "" %>>Đang phục vụ</option>
                                <option value="Đã thanh toán" <%= "Đã thanh toán".equals(ban.getTrangThai()) ? "selected" : "" %>>Đã thanh toán</option>
                            </select>
                            <button type="submit"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
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