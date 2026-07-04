<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thống kê doanh thu</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <style>

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:Segoe UI,sans-serif;
            }

            body{
                background:#f8f5f1;
            }

            /*================= Layout =================*/

            .wrapper{
                display:flex;
            }

            /*================ Sidebar =================*/

            .sidebar{

                width:285px;
                background:#4d3b31;
                min-height:100vh;
                color:white;
            }

            .logo{

                height:80px;
                display:flex;
                align-items:center;
                padding-left:22px;
                font-size:30px;
                font-weight:bold;
                border-bottom:1px solid rgba(255,255,255,.1);

            }

            .logo i{

                margin-right:12px;

            }

            .menu{

                margin-top:10px;

            }

            .menu a{

                display:flex;
                align-items:center;
                padding:18px 25px;
                color:white;
                text-decoration:none;
                font-size:21px;
                transition:.25s;

            }

            .menu a:hover{

                background:#70594b;

            }

            .menu i{

                width:35px;

            }

            .active{

                background:#746052;

            }

            /*================ Main =================*/

            .main{

                flex:1;

            }

            /*=============== Top Bar =================*/

            .topbar{

                height:70px;
                background:white;
                border-bottom:1px solid #eee;
                display:flex;
                justify-content:flex-end;
                align-items:center;
                padding-right:35px;

            }

            .topbar i{

                font-size:23px;
                color:#4d3b31;

            }

            .user{

                font-size:20px;
                margin-left:10px;
                color:#333;

            }

            /*============== Content =================*/

            .content{

                padding:35px;

            }

            .title{

                font-size:42px;
                font-weight:bold;
                color:#222;

            }

            .sub{

                color:#777;
                margin-top:10px;
                margin-bottom:30px;
                font-size:20px;

            }

            /*============ Card =================*/

            .card{

                background:white;
                border-radius:18px;
                padding:30px;
                box-shadow:0 4px 18px rgba(0,0,0,.08);

            }

            /*=========== Filter =================*/

            .filter{

                display:flex;
                gap:20px;
                margin-bottom:30px;
                flex-wrap:wrap;

            }

            .filter input,
            .filter select{

                padding:12px;
                border:1px solid #ddd;
                border-radius:8px;
                font-size:16px;

            }

            .btn{

                background:#6d4c41;
                color:white;
                border:none;
                padding:12px 28px;
                border-radius:8px;
                cursor:pointer;
                font-size:16px;

            }

            .btn:hover{

                background:#5a3f35;

            }

            /*============== Table =================*/

            table{

                width:100%;
                border-collapse:collapse;

            }

            th{

                background:#6d4c41;
                color:white;
                padding:15px;

            }

            td{

                padding:15px;
                border-bottom:1px solid #eee;
                text-align:center;

            }

            tr:hover{

                background:#faf6f3;

            }

            /*============ Summary ==============*/

            .summary{

                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:20px;
                margin-bottom:30px;

            }

            .box{

                text-decoration:none;
                color:#333;
                transition:.3s;
            }

            .box:hover{

                transform:translateY(-5px);
                box-shadow:0 8px 20px rgba(0,0,0,.15);

            }

            .box h3{

                color:#777;
                margin-bottom:15px;

            }

            .box p{

                font-size:32px;
                font-weight:bold;
                color:#6d4c41;

            }

        </style>

    </head>

    <body>

        <div class="wrapper">

            <div class="sidebar">

                <div class="logo">
                    <i class="fa-solid fa-mug-hot"></i>
                    QUẢN LÝ QUÁN CAFE
                </div>

                <div class="menu">

                    <a href="TrangChuServlet">Trang chủ</a>

                    <a href="NhanVienServlet">Nhân viên</a>

                    <a href="HoaDonServlet">Hóa đơn</a>

                    <a href="MenuServlet">Menu</a>

                    <a href="BanServlet">Bàn</a>

                    <a href="KhoServlet">Kho</a>

                    <a href="KhachHangServlet">Khách hàng</a>

                    <a href="ThongKeServlet" class="active">
                        Thống kê doanh thu
                    </a>

                    <a href="DangXuatServlet">Đăng xuất</a>

                </div>

            </div>

            <div class="main">

                <div class="topbar">

                    <i class="fa-solid fa-circle-user"></i>

                    <div class="user">
                        TH07964 - Nguyễn Anh Tuấn
                    </div>

                </div>

                <div class="content">

                    <div class="title">
                        Thống kê doanh thu
                    </div>

                    <div class="sub">
                        Xem doanh thu theo ngày, tháng hoặc năm
                    </div>

                    <div class="summary">

                        <a href="ThongKeServlet?type=day" class="box">

                            <h3>Doanh thu hôm nay</h3>

                            <p>${doanhThuNgay}</p>

                        </a>

                        <a href="ThongKeServlet?type=month" class="box">

                            <h3>Doanh thu tháng</h3>

                            <p>${doanhThuThang}</p>

                        </a>

                        <a href="ThongKeServlet?type=year" class="box">

                            <h3>Doanh thu năm</h3>

                            <p>${doanhThuNam}</p>

                        </a>

                        <a href="HoaDonServlet" class="box">

                            <h3>Số hóa đơn</h3>

                            <p>${tongHoaDon}</p>

                        </a>

                    </div>

                    <div class="card">

                        <div class="filter">

                            <input type="date">

                            <input type="date">

                            <select>

                                <option>Theo ngày</option>
                                <option>Theo tháng</option>
                                <option>Theo năm</option>

                            </select>

                            <button class="btn">
                                <i class="fa fa-search"></i>
                                Thống kê
                            </button>

                        </div>

                        <table>

                            <tr>

                                <th>Ngày</th>

                                <th>Số hóa đơn</th>

                                <th>Khách hàng</th>

                                <th>Doanh thu</th>

                                <th>Lợi nhuận</th>

                            </tr>

                            <tr>

                                <td>01/07/2026</td>

                                <td>45</td>

                                <td>38</td>

                                <td>6.500.000đ</td>

                                <td>2.400.000đ</td>

                            </tr>

                            <tr>

                                <td>02/07/2026</td>

                                <td>52</td>

                                <td>44</td>

                                <td>7.200.000đ</td>

                                <td>2.900.000đ</td>

                            </tr>

                            <tr>

                                <td>03/07/2026</td>

                                <td>60</td>

                                <td>49</td>

                                <td>8.350.000đ</td>

                                <td>3.250.000đ</td>

                            </tr>

                            <tr>

                                <td>04/07/2026</td>

                                <td>48</td>

                                <td>41</td>

                                <td>6.850.000đ</td>

                                <td>2.600.000đ</td>

                            </tr>

                        </table>

                    </div>

                </div>

            </div>

        </div>

    </body>
</html>