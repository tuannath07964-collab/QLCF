<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.NhanVien"%>

<%
    ArrayList<NhanVien> list =
            (ArrayList<NhanVien>) request.getAttribute("listNV");

    if (list == null) {
        list = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="vi">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Quản lý nhân viên</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{

    background:#f5f5f5;

}

.container{

    width:95%;

    margin:30px auto;

    background:#fff;

    border-radius:10px;

    box-shadow:0 2px 8px rgba(0,0,0,.15);

    padding:20px;

}

.title{

    font-size:28px;

    font-weight:bold;

    color:#4b3a2f;

    margin-bottom:20px;

}

.toolbar{

    display:flex;

    justify-content:space-between;

    margin-bottom:20px;

}

.search{

    display:flex;

    gap:10px;

}

.search input{

    width:300px;

    padding:10px;

    border:1px solid #ccc;

    border-radius:6px;

}

.search button{

    background:#4b3a2f;

    color:white;

    border:none;

    padding:10px 18px;

    border-radius:6px;

    cursor:pointer;

}

.add-btn{

    background:#2ecc71;

    color:white;

    text-decoration:none;

    padding:10px 20px;

    border-radius:6px;

    font-weight:bold;

}

.add-btn:hover{

    background:#27ae60;

}

table{

    width:100%;

    border-collapse:collapse;

}

table th{

    background:#4b3a2f;

    color:white;

    padding:12px;

}

table td{

    padding:12px;

    border-bottom:1px solid #ddd;

    text-align:center;

}

.edit{

    background:#3498db;

    color:white;

    text-decoration:none;

    padding:6px 12px;

    border-radius:5px;

}

.delete{

    background:#e74c3c;

    color:white;

    text-decoration:none;

    padding:6px 12px;

    border-radius:5px;

}

.edit:hover{

    background:#2980b9;

}

.delete:hover{

    background:#c0392b;

}

</style>

</head>

<body>

<div class="container">

<div class="title">

Quản lý nhân viên

</div>

<div class="toolbar">

<form class="search"
      action="NhanVienServlet"
      method="get">

<input type="hidden"
       name="action"
       value="search">

<input
type="text"
name="keyword"
placeholder="Nhập tên hoặc mã nhân viên...">

<button type="submit">

<i class="fa fa-search"></i>

Tìm

</button>

</form>

<a
href="views/themNhanVien.jsp"
class="add-btn">

<i class="fa fa-plus"></i>

Thêm nhân viên

</a>

</div>

<table>

<tr>

<th>Mã NV</th>

<th>Họ tên</th>

<th>Giới tính</th>

<th>Ngày sinh</th>

<th>SĐT</th>

<th>Địa chỉ</th>

<th>Chức vụ</th>

<th>Lương</th>

<th>Trạng thái</th>

<th>Thao tác</th>

</tr>
<%
    for (NhanVien nv : list) {
%>

<tr>

    <td><%= nv.getMaNV() %></td>

    <td><%= nv.getHoTen() %></td>

    <td><%= nv.getGioiTinh() %></td>

    <td><%= nv.getNgaySinh() %></td>

    <td><%= nv.getSdt() %></td>

    <td><%= nv.getDiaChi() %></td>

    <td><%= nv.getChucVu() %></td>

    <td><%= String.format("%,.0f", nv.getLuong()) %> đ</td>

    <td><%= nv.getTrangThai() %></td>

    <td>

        <a class="edit"
           href="views/suaNhanVien.jsp?maNV=<%= nv.getMaNV() %>">

            <i class="fa fa-pen"></i>

            Sửa

        </a>

        &nbsp;

        <a class="delete"
           onclick="return confirm('Bạn có chắc muốn xóa nhân viên này?')"
           href="NhanVienServlet?action=delete&maNV=<%= nv.getMaNV() %>">

            <i class="fa fa-trash"></i>

            Xóa

        </a>

    </td>

</tr>

<%
    }
%>

</table>

</div>

</body>

</html>