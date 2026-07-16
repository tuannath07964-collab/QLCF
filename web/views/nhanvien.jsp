<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">

    <head>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Quản lý nhân viên</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <style>

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:"Segoe UI",Arial,sans-serif;
            }

            body{
                display:flex;
                background:#f4f6f9;
            }

            .sidebar{
                width:250px;
                height:100vh;
                background:#2d221d;
                color:white;
                position:fixed;
            }

            .logo{
                padding:25px;
                text-align:center;
                font-size:20px;
                font-weight:bold;
            }

            .menu{
                margin-top:20px;
            }

            .menu a{
                display:block;
                padding:15px 25px;
                color:#bbb;
                text-decoration:none;
                transition:.3s;
            }

            .menu a:hover,
            .menu a.active{
                background:#423630;
                color:white;
            }

            .main{
                margin-left:250px;
                width:calc(100% - 250px);
            }

            .header{
                height:60px;
                background:white;
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:0 30px;
                box-shadow:0 2px 5px rgba(0,0,0,.1);
            }

            .content{
                padding:30px;
            }

            .card{
                background:white;
                border-radius:10px;
                padding:25px;
                box-shadow:0 2px 10px rgba(0,0,0,.08);
            }

            .top{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }

            .search-form{
                display:flex;
                gap:10px;
            }

            .search-form input{
                width:250px;
                padding:8px;
                border:1px solid #ccc;
                border-radius:5px;
            }

            .search-form button{
                padding:8px 12px;
                border:none;
                background:#5d4037;
                color:white;
                border-radius:5px;
                cursor:pointer;
            }

            .btn-add{
                background:#28a745;
                color:white;
                padding:10px 16px;
                text-decoration:none;
                border-radius:5px;
            }

            .btn-edit{
                background:#ffc107;
                color:black;
                padding:6px 10px;
                text-decoration:none;
                border-radius:4px;
            }

            .btn-delete{
                background:#dc3545;
                color:white;
                padding:6px 10px;
                text-decoration:none;
                border-radius:4px;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            table th{
                background:#5d4037;
                color:white;
                padding:12px;
            }

            table td{
                border-bottom:1px solid #ddd;
                padding:10px;
                text-align:center;
            }

        </style>

    </head>

    <body>

        <div class="sidebar">

            <div class="logo">
                QUẢN LÝ QUÁN CAFE
            </div>

            <div class="menu">

                <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                    <i class="fa-solid fa-house"></i>
                    Trang chủ
                </a>

                <a href="${pageContext.request.contextPath}/ban">
                    <i class="fa-solid fa-chair"></i>
                    Quản lý bàn
                </a>

                <a href="#">
                    <i class="fa-solid fa-utensils"></i>
                    Thực đơn
                </a>

                <a href="#">
                    <i class="fa-solid fa-file-invoice"></i>
                    Hóa đơn
                </a>

                <a class="active"
                   href="${pageContext.request.contextPath}/nhanvien">

                    <i class="fa-solid fa-users"></i>
                    Quản lý nhân viên

                </a>

                <a href="#">
                    <i class="fa-solid fa-box"></i>
                    Kho
                </a>

            </div>

        </div>

        <div class="main">

            <div class="header">

                <h2>Quản lý nhân viên</h2>

                <div>
                    <i class="fa-solid fa-user"></i>
                    Admin
                </div>

            </div>

            <div class="content">

                <div class="card">

                    <div class="top">

                        <form class="search-form"
                              action="${pageContext.request.contextPath}/nhanvien"
                              method="get">

                            <input type="hidden"
                                   name="action"
                                   value="search">

                            <input type="text"
                                   name="keyword"
                                   placeholder="Nhập mã hoặc tên...">

                            <button type="submit">

                                <i class="fa-solid fa-search"></i>

                            </button>

                        </form>

                        <a class="btn-add"
                           href="${pageContext.request.contextPath}/views/themNhanVien.jsp">

                            <i class="fa-solid fa-plus"></i>
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
                            <th>Chức vụ</th>
                            <th>Thao tác</th>

                        </tr>

                        <c:forEach var="nv" items="${listNV}">

                            <tr>

                                <td>${nv.maNV}</td>

                                <td>${nv.hoTen}</td>

                                <td>${nv.gioiTinh}</td>

                                <td>${nv.ngaySinh}</td>

                                <td>${nv.sdt}</td>

                                <td>${nv.chucVu}</td>

                                <td>

                                    <a class="btn-edit"
                                       href="${pageContext.request.contextPath}/views/suaNhanVien.jsp?maNV=${nv.maNV}">

                                        <i class="fa-solid fa-pen"></i>

                                        Sửa

                                    </a>

                                    <a class="btn-delete"
                                       href="${pageContext.request.contextPath}/nhanvien?action=delete&maNV=${nv.maNV}"
                                       onclick="return confirm('Bạn có chắc muốn xóa nhân viên này?');">

                                        <i class="fa-solid fa-trash"></i>

                                        Xóa

                                    </a>

                                </td>

                            </tr>

                        </c:forEach>

                    </table>

                </div>

            </div>

        </div>

    </body>

</html>