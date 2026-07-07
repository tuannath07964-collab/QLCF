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

<title>
<%= isEdit ? "Sửa bàn" : "Thêm bàn" %>
</title>

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
    width:240px;
    height:100vh;
    background:#3e2723;
    color:white;
    position:fixed;
    left:0;
    top:0;
}

.logo{
    text-align:center;
    padding:25px;
    border-bottom:1px solid rgba(255,255,255,.15);
}

.logo i{
    font-size:40px;
    color:#ffb74d;
    margin-bottom:10px;
}

.logo h2{
    font-size:25px;
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

.menu a:hover{
    background:#5d4037;
    padding-left:35px;
}

.menu a i{
    width:28px;
}

.active{
    background:#795548;
}

/*================ MAIN ================*/

.main{

    margin-left:240px;
    width:calc(100% - 240px);

}

/*================ HEADER ================*/

.header{

    background:white;
    height:70px;

    display:flex;
    justify-content:space-between;
    align-items:center;

    padding:0 35px;

    box-shadow:0 2px 8px rgba(0,0,0,.08);

}

.header h1{

    color:#444;

}

.admin{

    font-weight:bold;
    color:#666;

}

/*================ CONTENT ================*/

.content{

    padding:35px;

}

.card{

    background:white;

    border-radius:15px;

    padding:30px;

    box-shadow:0 6px 18px rgba(0,0,0,.08);

}

.card h2{

    margin-bottom:25px;

    color:#444;

}

label{

    display:block;

    margin-top:18px;

    margin-bottom:8px;

    font-weight:bold;

    color:#555;

}

input,
select{

    width:100%;

    padding:12px;

    border:1px solid #ddd;

    border-radius:8px;

    font-size:15px;

    transition:.3s;

}

input:focus,
select:focus{

    outline:none;

    border-color:#795548;

}

.button-group{

    display:flex;

    justify-content:space-between;

    margin-top:30px;

}

.btn-save{

    width:48%;

    background:#28a745;

    color:white;

    border:none;

    padding:12px;

    border-radius:8px;

    cursor:pointer;

    font-size:16px;

}

.btn-save:hover{

    background:#218838;

}

.btn-back{

    width:48%;

    background:#6c757d;

    color:white;

    text-decoration:none;

    text-align:center;

    padding:12px;

    border-radius:8px;

}

.btn-back:hover{

    background:#5a6268;

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

            <i class="fa-solid fa-users"></i>

            Nhân viên

        </a>

        <a href="#">

            <i class="fa-solid fa-chart-line"></i>

            Thống kê

        </a>

    </div>

</div>

<div class="main">

<div class="header">

<h1>

<%= isEdit ? "Sửa bàn" : "Thêm bàn mới" %>

</h1>

<div class="admin">

Admin

</div>

</div>

<div class="content">

<div class="card">

<h2>

Thông tin bàn

</h2>
    <form action="ban" method="post">

    <input type="hidden"
           name="action"
           value="<%= isEdit ? "update" : "insert" %>">

    <label>
        <i class="fa-solid fa-hashtag"></i>
        Mã bàn
    </label>

    <input
        type="text"
        name="maBan"
        value="<%= isEdit ? ban.getMaBan() : "" %>"
        <%= isEdit ? "readonly" : "" %>
        required>

    <label>
        <i class="fa-solid fa-chair"></i>
        Tên bàn
    </label>

    <input
        type="text"
        name="tenBan"
        value="<%= isEdit ? ban.getTenBan() : "" %>"
        required>

    <label>
        <i class="fa-solid fa-circle-info"></i>
        Trạng thái
    </label>

    <select name="trangThai">

        <option value="Trống"
            <%= isEdit && "Trống".equals(ban.getTrangThai()) ? "selected" : "" %>>
            Trống
        </option>

        <option value="Đang phục vụ"
            <%= isEdit && "Đang phục vụ".equals(ban.getTrangThai()) ? "selected" : "" %>>
            Đang phục vụ
        </option>

        <option value="Đã thanh toán"
            <%= isEdit && "Đã thanh toán".equals(ban.getTrangThai()) ? "selected" : "" %>>
            Đã thanh toán
        </option>

    </select>

    <div class="button-group">

        <button class="btn-save" type="submit">

            <i class="fa-solid fa-floppy-disk"></i>

            <%= isEdit ? "Cập nhật" : "Thêm mới" %>

        </button>

        <a class="btn-back" href="ban">

            <i class="fa-solid fa-arrow-left"></i>

            Quay lại

        </a>

    </div>

</form>

</div>

</div>

</div>

</body>

</html>