<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý khách hàng</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<style>
    /* Bạn hãy để nguyên CSS cũ từ file Quản lý bàn vào đây */
    * { margin:0; padding:0; box-sizing:border-box; font-family: 'Segoe UI', Arial, sans-serif; }
    body { display:flex; background:#f4f6f9; }
    .sidebar { width:250px; height:100vh; background:#2d221d; color:white; position:fixed; }
    .logo { padding:25px; text-align:center; font-size: 18px; font-weight: bold; }
    .menu { margin-top:20px; }
    .menu a { display:block; padding:15px 25px; color:#bbb; text-decoration:none; transition:.3s; }
    .menu a:hover, .menu a.active { background:#423630; color:white; }
    .main { margin-left:250px; width:calc(100% - 250px); }
    .header { height: 60px; background: white; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .user-info { display: flex; align-items: center; gap: 15px; font-weight: 500; font-size: 14px; }
    .content { padding: 30px; }
    .card { background: white; border-radius: 10px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    table { width: 100%; border-collapse: collapse; }
    table th { background: #5d4037; color: white; padding: 15px; font-size: 14px; }
    table td { padding: 15px; border-bottom: 1px solid #eee; text-align: center; color: #333; }
    .btn-add { background: #28a745; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-size: 14px; }
    .btn-edit { background: #ffc107; color: black; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 12px; }
    .btn-delete { background: #dc3545; color: white; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 12px; }
</style>
</head>
<body>

<div class="sidebar">
    <div class="logo">QUẢN LÝ QUÁN CAFE</div>
    <div class="menu">
        <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-house"></i> Trang chủ</a>
        <a href="ban"><i class="fa-solid fa-chair"></i> Quản lý bàn</a>
        <a href="#"><i class="fa-solid fa-utensils"></i> Thực đơn</a>
        <a href="#"><i class="fa-solid fa-receipt"></i> Hóa đơn</a>
        <a class="active" href="khachhang"><i class="fa-solid fa-users"></i> Quản lý khách hàng</a>
        <a href="#"><i class="fa-solid fa-box"></i> Kho</a>
        <a href="#"><i class="fa-solid fa-chart-line"></i> Thống kê</a>
    </div>
</div>

<div class="main">
    <div class="header">
        <h3>Quản lý khách hàng</h3>
        <div class="user-info">
            <span>TH08495 - Trần Dương Phương Hiếu</span>
            <i class="fa-solid fa-bell"></i>
        </div>
    </div>

    <div class="content">
        <div class="card">
            <div class="top">
                <h3>Danh sách khách hàng</h3>
                <a class="btn-add" href="khachhang?action=new"><i class="fa-solid fa-plus"></i> Thêm khách hàng</a>
            </div>

            <table>
                <tr>
                    <th>Mã KH</th>
                    <th>Tên khách hàng</th>
                    <th>Số điện thoại</th>
                    <th>Thao tác</th>
                </tr>
                <c:forEach var="kh" items="${listKH}">
                <tr>
                    <td>${kh.maKH}</td>
                    <td>${kh.tenKH}</td>
                    <td>${kh.sdt}</td>
                    <td>
                        <a class="btn-edit" href="khachhang?action=edit&maKH=${kh.maKH}"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                        <a class="btn-delete" href="khachhang?action=delete&maKH=${kh.maKH}" onclick="return confirm('Xóa khách hàng này?')"><i class="fa-solid fa-trash"></i> Xóa</a>
                    </td>
                </tr>
                </c:forEach>
            </table>
        </div>
    </div>
</div>

</body>
</html>