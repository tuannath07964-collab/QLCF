<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.BanAn"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý bàn</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,Helvetica,sans-serif;
}

body{
    display:flex;
    background:#f4f6f9;
}

/*================ SIDEBAR ================*/

.sidebar{
    width:250px;
    height:100vh;
    background:#2d221d;
    color:white;
    position:fixed;
    left:0;
    top:0;
}

.logo{
    padding:25px;
    text-align:center;
    border-bottom:1px solid rgba(255,255,255,.15);
}

.logo i{
    font-size:35px;
    color:#ffb347;
    margin-bottom:10px;
}

.logo h2{
    font-size:24px;
}

.menu{
    margin-top:20px;
}

.menu a{
    display:block;
    padding:16px 25px;
    color:white;
    text-decoration:none;
    transition:.3s;
}

.menu a i{
    width:28px;
}

.menu a:hover{
    background:#4a372d;
    padding-left:35px;
}

.menu .active{
    background:#8b5e3c;
}

/*================ MAIN =================*/

.main{
    margin-left:250px;
    width:calc(100% - 250px);
}

/*================ HEADER ================*/

.header{
    height:75px;
    background:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:0 35px;
    box-shadow:0 2px 8px rgba(0,0,0,.08);
}

.header h1{
    color:#333;
    font-size:28px;
}

.user{
    font-weight:bold;
    color:#666;
}

/*================ CONTENT ================*/

.content{
    padding:35px;
}

/*================ CARD =================*/

.card{
    background:white;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,.08);
    padding:25px;
}

/*================ TOP =================*/

.top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
}

.top h2{
    color:#333;
}

.btn-add{
    text-decoration:none;
    background:#28a745;
    color:white;
    padding:12px 20px;
    border-radius:8px;
    font-weight:bold;
    transition:.3s;
}

.btn-add:hover{
    background:#218838;
}

/*================ TABLE =================*/

table{
    width:100%;
    border-collapse:collapse;
}

table th{
    background:#5d4037;
    color:white;
    padding:14px;
}

table td{
    padding:14px;
    border-bottom:1px solid #ddd;
    text-align:center;
}

table tr:hover{
    background:#fafafa;
}

/*================ BUTTON =================*/

button{
    background:#007bff;
    color:white;
    border:none;
    padding:8px 14px;
    border-radius:6px;
    cursor:pointer;
}

button:hover{
    background:#0056b3;
}

.btn-edit{
    display:inline-block;
    background:#ffc107;
    color:black;
    text-decoration:none;
    padding:8px 12px;
    border-radius:5px;
    margin-right:5px;
}

.btn-delete{
    display:inline-block;
    background:#dc3545;
    color:white;
    text-decoration:none;
    padding:8px 12px;
    border-radius:5px;
}

.btn-edit:hover{
    background:#e0a800;
}

.btn-delete:hover{
    background:#c82333;
}

/*================ STATUS =================*/

.trong{
    color:#28a745;
    font-weight:bold;
}

.dangphucvu{
    color:#ff9800;
    font-weight:bold;
}

.dathanhtoan{
    color:#2196f3;
    font-weight:bold;
}

select{
    padding:8px;
    border-radius:5px;
}

</style>

</head>

<body>

<div class="sidebar">

    <div class="logo">
        <i class="fa-solid fa-mug-hot"></i>
        <h2>Cafe Manager</h2>
    </div>

    <div class="menu">

        <a href="#">
            <i class="fa-solid fa-house"></i>
            Trang chủ
        </a>

        <a class="active" href="ban">
            <i class="fa-solid fa-chair"></i>
            Quản lý bàn
        </a>

        <a href="#">
            <i class="fa-solid fa-utensils"></i>
            Thực đơn
        </a>

        <a href="#">
            <i class="fa-solid fa-receipt"></i>
            Hóa đơn
        </a>

        <a href="#">
            <i class="fa-solid fa-users"></i>
            Nhân viên
        </a>

        <a href="#">
            <i class="fa-solid fa-box"></i>
            Kho
        </a>

        <a href="#">
            <i class="fa-solid fa-chart-line"></i>
            Thống kê
        </a>

    </div>

</div>

<div class="main">

    <div class="header">

        <h1>Quản lý bàn</h1>

        <div class="user">
            Xin chào Admin
        </div>

    </div>

    <div class="content">

        <div class="card">

            <div class="top">

                <h2>Danh sách bàn</h2>

                <a class="btn-add"
                   href="ban?action=new">
                    <i class="fa-solid fa-plus"></i>
                    Thêm bàn
                </a>

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

            if ("Trống".equals(ban.getTrangThai())) {
                cssClass = "trong";
            } else if ("Đang phục vụ".equals(ban.getTrangThai())) {
                cssClass = "dangphucvu";
            } else if ("Đã thanh toán".equals(ban.getTrangThai())) {
                cssClass = "dathanhtoan";
            }
%>

<tr>

    <td>
        <%= ban.getMaBan() %>
    </td>

    <td>
        <%= ban.getTenBan() %>
    </td>

    <td class="<%= cssClass %>">
        <%= ban.getTrangThai() %>
    </td>

    <td>

        <form action="ban" method="post">

            <input type="hidden"
                   name="action"
                   value="updateStatus">

            <input type="hidden"
                   name="maBan"
                   value="<%= ban.getMaBan() %>">

            <select name="trangThai">

                <option value="Trống"
                    <%= "Trống".equals(ban.getTrangThai()) ? "selected" : "" %>>
                    Trống
                </option>

                <option value="Đang phục vụ"
                    <%= "Đang phục vụ".equals(ban.getTrangThai()) ? "selected" : "" %>>
                    Đang phục vụ
                </option>

                <option value="Đã thanh toán"
                    <%= "Đã thanh toán".equals(ban.getTrangThai()) ? "selected" : "" %>>
                    Đã thanh toán
                </option>

            </select>

            <button type="submit">
                <i class="fa-solid fa-floppy-disk"></i>
                Lưu
            </button>

        </form>

    </td>

    <td>

        <a class="btn-edit"
           href="ban?action=edit&maBan=<%= ban.getMaBan() %>">

            <i class="fa-solid fa-pen-to-square"></i>
            Sửa

        </a>

        <a class="btn-delete"
           href="ban?action=delete&maBan=<%= ban.getMaBan() %>"
           onclick="return confirm('Bạn có chắc muốn xóa bàn này không?')">

            <i class="fa-solid fa-trash"></i>
            Xóa

        </a>

    </td>

</tr>

<%
        }
    }
%>

            </table>

        </div>

    </div>

</div>

</body>
</html>