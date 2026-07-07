<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.NguyenLieu"%>

<%
    ArrayList<NguyenLieu> ds =
            (ArrayList<NguyenLieu>) request.getAttribute("dsKho");

    String maNV = (String) session.getAttribute("maNV");
    String tenNV = (String) session.getAttribute("tenNV");

    if(maNV == null){
        response.sendRedirect(request.getContextPath()+"/LoginServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">

    <head>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Quản lý kho</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

        <style>

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:'Segoe UI',sans-serif;
            }

            body{
                background:#f4f6f9;
            }

            .container{
                display:flex;
                min-height:100vh;
            }

            /* ================= SIDEBAR ================= */

            .sidebar{
                width:260px;
                background:#543d2b;
                color:white;
                display:flex;
                flex-direction:column;
                justify-content:space-between;
                position:fixed;
                left:0;
                top:0;
                height:100vh;
            }

            .logo{
                padding:25px;
                text-align:center;
                border-bottom:1px solid rgba(255,255,255,.15);
            }

            .logo i{
                font-size:35px;
                margin-bottom:10px;
                display:block;
            }

            .logo span{
                font-size:15px;
                font-weight:bold;
            }

            .menu{
                list-style:none;
                padding:20px 0;
            }

            .menu li{
                margin:5px 15px;
            }

            .menu li a{
                text-decoration:none;
                color:white;
                padding:14px 18px;
                border-radius:12px;
                display:flex;
                align-items:center;
                gap:12px;
                transition:.3s;
            }

            .menu li a:hover{
                background:#6a4d38;
            }

            .menu li.active a{
                background:white;
                color:#543d2b;
                font-weight:600;
            }

            .logout{
                padding:20px;
            }

            .logout a{
                text-decoration:none;
                color:white;
                display:block;
                text-align:center;
                padding:12px;
                border-radius:10px;
                background:#6a4d38;
                transition:.3s;
            }

            .logout a:hover{
                background:#7d5b42;
            }

            /* ================= MAIN ================= */

            .main-content{
                flex:1;
                margin-left:260px;
                padding:30px;
            }

            /* ================= TOPBAR ================= */

            .topbar{
                display:flex;
                justify-content:flex-end;
                margin-bottom:30px;
            }

            .top-right{
                display:flex;
                align-items:center;
                gap:25px;
            }

            .notification{
                position:relative;
                font-size:22px;
                cursor:pointer;
            }

            .badge{
                position:absolute;
                top:-8px;
                right:-10px;
                background:red;
                color:white;
                width:18px;
                height:18px;
                border-radius:50%;
                font-size:11px;
                display:flex;
                justify-content:center;
                align-items:center;
            }

            .user{
                display:flex;
                align-items:center;
                gap:10px;
                background:white;
                padding:10px 18px;
                border-radius:12px;
                box-shadow:0 2px 10px rgba(0,0,0,.08);
            }

            .user i:first-child{
                font-size:24px;
                color:#543d2b;
            }

            /* ================= HEADER ================= */

            .page-header{
                margin-bottom:30px;
            }

            .page-header h1{
                font-size:32px;
                color:#222;
                margin-bottom:8px;
            }

            .page-header p{
                color:#666;
                margin-bottom:15px;
            }

            .back-btn{
                text-decoration:none;
                background:#543d2b;
                color:white;
                padding:10px 18px;
                border-radius:10px;
                display:inline-block;
                transition:.3s;
            }

            .back-btn:hover{
                background:#3d2b1f;
            }

            /* ================= TOOLBAR ================= */

            .toolbar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:25px;
            }

            .search-box{
                background:white;
                width:350px;
                padding:12px 18px;
                border-radius:12px;
                display:flex;
                align-items:center;
                gap:10px;
                box-shadow:0 2px 10px rgba(0,0,0,.08);
            }

            .search-box input{
                border:none;
                outline:none;
                width:100%;
                font-size:15px;
            }

            .add-btn{
                border:none;
                background:#543d2b;
                color:white;
                padding:12px 22px;
                border-radius:12px;
                cursor:pointer;
                font-weight:600;
                transition:.3s;
            }

            .add-btn:hover{
                background:#3d2b1f;
            }

            /* ================= DASHBOARD ================= */

            .dashboard{
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:20px;
                margin-bottom:30px;
            }

            .card{
                background:white;
                border-radius:18px;
                padding:20px;
                display:flex;
                align-items:center;
                gap:15px;
                box-shadow:0 2px 12px rgba(0,0,0,.08);
            }

            .card-icon{
                width:60px;
                height:60px;
                border-radius:15px;
                display:flex;
                justify-content:center;
                align-items:center;
                font-size:24px;
                color:white;
            }

            .brown{
                background:#543d2b;
            }

            .green{
                background:#27ae60;
            }

            .orange{
                background:#f39c12;
            }
            .red{
                background:#e74c3c;
            }
            .card-content p{
                color:#666;
                font-size:14px;
            }
            .card-content h2{
                margin:5px 0;
                font-size:28px;
            }
            .card-content span{
                color:#888;
                font-size:13px;
            }
            /* ================= TABLE ================= */
            .table-container{
                background:white;
                border-radius:20px;
                overflow:hidden;
                box-shadow:0 2px 12px rgba(0,0,0,.08);
            }
            table{
                width:100%;
                border-collapse:collapse;
            }
            thead{
                background:#543d2b;
                color:white;
            }
            th{
                padding:18px;
                text-align:left;
            }
            td{
                padding:16px 18px;
                border-bottom:1px solid #eee;
            }
            tbody tr:hover{
                background:#f9f9f9;
            }
            .action{
                display:flex;
                gap:10px;
            }
            .edit-btn{
                border:none;
                background:#3498db;
                color:white;
                width:38px;
                height:38px;
                border-radius:8px;
                cursor:pointer;
            }
            .delete-btn{
                border:none;
                background:#e74c3c;
                color:white;
                width:38px;
                height:38px;
                border-radius:8px;
                cursor:pointer;
            }
            .edit-btn:hover,
            .delete-btn:hover{
                opacity:.85;
            }
            .empty{
                text-align:center;
                padding:25px;
                color:#999;
            }
            /* ================= FOOTER TABLE ================= */
            .table-footer{
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:18px;
            }
            .table-info{
                color:#666;
            }
            .pagination{
                display:flex;
                gap:8px;
            }
            .page-btn{
                border:none;
                background:#eee;
                width:38px;
                height:38px;
                border-radius:8px;
                cursor:pointer;
            }
            .active-page{
                background:#543d2b;
                color:white;
            }
            /* ================= RESPONSIVE ================= */
            @media(max-width:1200px){

                .dashboard{
                    grid-template-columns:repeat(2,1fr);
                }
            }
            @media(max-width:768px){
                .sidebar{
                    display:none;
                }
                .main-content{
                    margin-left:0;
                }
                .dashboard{
                    grid-template-columns:1fr;
                }
                .toolbar{
                    flex-direction:column;
                    gap:15px;
                }
                .search-box{
                    width:100%;
                }
            }

        </style>

    </head>

    <body>

        <div class="container">

            <!-- ===========================
                    SIDEBAR
            ============================ -->

            <aside class="sidebar">

                <div class="logo">

                    <i class="fa-solid fa-mug-hot"></i>

                    <span>QUẢN LÝ QUÁN CAFE</span>

                </div>

                <ul class="menu">

                    <li>
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                            <i class="fa-solid fa-house"></i>
                            <span>Trang chủ</span>
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            <i class="fa-solid fa-user"></i>
                            <span>Nhân viên</span>
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            <i class="fa-solid fa-file-invoice-dollar"></i>
                            <span>Hóa đơn</span>
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            <i class="fa-solid fa-mug-hot"></i>
                            <span>Menu</span>
                        </a>
                    </li>

                    <li>
                        <a href="#">
                            <i class="fa-solid fa-chair"></i>
                            <span>Bàn</span>
                        </a>
                    </li>

                    <li class="active">
                        <a href="${pageContext.request.contextPath}/KhoServlet">
                            <i class="fa-solid fa-box"></i>
                            <span>Kho</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <i class="fa-solid fa-users"></i>
                            <span>Khách hàng</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <i class="fa-solid fa-chart-simple"></i>
                            <span>Thống kê doanh thu</span>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <i class="fa-solid fa-gear"></i>
                            <span>Cài đặt</span>
                        </a>
                    </li>
                </ul>
                <div class="logout">
                    <a href="${pageContext.request.contextPath}/LogoutServlet">
                        <i class="fa-solid fa-right-from-bracket"></i>
                        Đăng xuất
                    </a>
                </div>
            </aside>

            <!-- ===========================
                    MAIN
            ============================ -->

            <main class="main-content">

                <!-- HEADER -->
                <header class="topbar">
                    <div class="top-right">
                        <div class="notification">
                            <i class="fa-regular fa-bell"></i>
                            <span class="badge">3</span>
                        </div>
                        <div class="user">
                            <i class="fa-solid fa-circle-user"></i>
                            <span>
                                <%= maNV %> - <%= tenNV %>
                            </span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                    </div>
                </header>

                <!-- ===========================
                        PAGE TITLE
                ============================ -->

                <section class="page-header">
                    <div>
                        <h1>Quản lý kho</h1>
                        <p>Quản lý nguyên liệu, nhập xuất kho</p>
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp"
                           class="back-btn">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại Trang chủ
                        </a>
                    </div>
                </section>

                <!--
                    PHẦN 2
                    sẽ bắt đầu từ đây
                    (Card thống kê + Search + Button)
                -->
                <!-- ===========================
                THANH CHỨC NĂNG
        ============================ -->
                <div class="toolbar">
                    <div class="search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input
                            type="text"
                            placeholder="Tìm kiếm nguyên liệu..."
                            >
                    </div>
                    <button class="add-btn">
                        <i class="fa-solid fa-plus"></i>
                        Thêm nguyên liệu
                    </button>
                </div>


                <!-- ===========================
                        THỐNG KÊ
                ============================ -->
                <div class="dashboard">
                    <!-- Card 1 -->
                    <div class="card">
                        <div class="card-icon brown">
                            <i class="fa-solid fa-box"></i>
                        </div>
                        <div class="card-content">
                            <p>Tổng nguyên liệu</p>
                            <h2>
                                <%= ds.size() %>
                            </h2>
                            <span>Loại nguyên liệu</span>
                        </div>
                    </div>
                    <!-- Cad 2 -->
                    <%
                        int tong = 0;
                        for(NguyenLieu nl : ds){
                            tong += nl.getSoLuong();
                        }
                    %>

                    <div class="card">
                        <div class="card-icon green">
                            <i class="fa-solid fa-basket-shopping"></i>
                        </div>
                        <div class="card-content">
                            <p>Tổng số lượng</p>
                            <h2>
                                <%= tong %>
                            </h2>
                            <span>Đơn vị</span>
                        </div>
                    </div>
                    <!-- Card 3 -->
                    <%
                        int sapHet = 0;
                        for(NguyenLieu nl : ds){
                            if(nl.getSoLuong() <= 10){
                                sapHet++;
                            }
                        }
                    %>

                    <div class="card">
                        <div class="card-icon orange">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>
                        <div class="card-content">
                            <p>Sắp hết hàng</p>
                            <h2>
                                <%= sapHet %>
                            </h2>
                            <span>Loại nguyên liệu</span>
                        </div>
                    </div>

                    <!-- Card 4 -->

                    <%
                        int hetHang = 0;

                        for(NguyenLieu nl : ds){

                            if(nl.getSoLuong()==0){

                                hetHang++;

                            }

                        }
                    %>

                    <div class="card">

                        <div class="card-icon red">

                            <i class="fa-solid fa-circle-xmark"></i>

                        </div>

                        <div class="card-content">

                            <p>Hết hàng</p>

                            <h2>

                                <%= hetHang %>

                            </h2>

                            <span>Loại nguyên liệu</span>

                        </div>

                    </div>

                </div>


                <!-- ===========================
                        BẢNG DỮ LIỆU
                        PHẦN 3 bắt đầu tại đây
                ============================ -->
                <!-- ======================= BẢNG DỮ LIỆU ======================= -->

                <div class="table-container">

                    <table>

                        <thead>
                            <tr>
                                <th>Mã nguyên liệu</th>
                                <th>Tên nguyên liệu</th>
                                <th>Số lượng</th>
                                <th>Đơn vị</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>

                        <tbody>

                            <%
                                if (ds != null && !ds.isEmpty()) {
                                    for (NguyenLieu nl : ds) {
                            %>

                            <tr>
                                <td><%= nl.getMaNL() %></td>
                                <td><%= nl.getTenNL() %></td>
                                <td><%= nl.getSoLuong() %></td>
                                <td><%= nl.getDonVi() %></td>

                                <td>
                                    <div class="action">
                                        <button class="edit-btn" title="Sửa">
                                            <i class="fa-solid fa-pen"></i>
                                        </button>

                                        <button class="delete-btn" title="Xóa">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>

                            <%
                                    }
                                } else {
                            %>

                            <tr>
                                <td colspan="5" class="empty">
                                    Không có nguyên liệu nào.
                                </td>
                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                    <div class="table-footer">

                        <div class="table-info">
                            Hiển thị 1 đến <%= ds.size() %> của <%= ds.size() %> nguyên liệu
                        </div>

                        <div class="pagination">
                            <button class="page-btn">
                                <i class="fa-solid fa-chevron-left"></i>
                            </button>

                            <button class="page-btn active-page">1</button>

                            <button class="page-btn">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </div>

                    </div>

                </div>

            </main>

        </div>

    </body>
</html>