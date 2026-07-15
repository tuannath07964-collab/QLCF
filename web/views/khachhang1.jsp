<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${action == 'edit' ? 'Sửa thông tin khách hàng' : 'Thêm khách hàng mới'}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        /* CSS đồng bộ hoàn toàn với trang Quản lý bàn */
        * { margin:0; padding:0; box-sizing:border-box; font-family: Arial, sans-serif; }
        body { display:flex; height:100vh; background:#f7f5f2; }

        /* Sidebar */
        .sidebar { width: 250px; background: #4b3a2f; color: #fff; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
        .logo { padding: 22px; font-size: 20px; font-weight: bold; text-align: center; border-bottom: 1px solid rgba(255,255,255,.1); }
        .menu { margin-top: 20px; list-style: none; }
        .menu a { display: flex; align-items: center; gap: 15px; padding: 16px 25px; color: white; text-decoration: none; transition: .3s; }
        .menu a:hover, .menu a.active { background: #6b5648; }
        .logout-section { padding: 20px 25px; border-top: 1px solid #423630; }
        .logout-section a { color: white; text-decoration: none; display: flex; align-items: center; gap: 15px; }

        /* Main Content */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .header { height: 70px; background: white; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .user-info { display: flex; align-items: center; gap: 15px; font-weight: 600; font-size: 14px; }
        .content { padding: 30px; overflow-y: auto; display: flex; justify-content: center; }
        .card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); width: 100%; max-width: 500px; }
        
        /* Form elements */
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; }
        .btn-submit { background: #1b9c5a; color: white; padding: 12px; border: none; border-radius: 6px; cursor: pointer; width: 100%; font-weight: bold; font-size: 16px; }
        .btn-submit:hover { background: #168a4e; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <div class="logo"><i class="fa-solid fa-mug-hot"></i> QUẢN LÝ CAFE</div>
            <div class="menu">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-house"></i> Trang chủ</a>
                <a href="ban"><i class="fa-solid fa-chair"></i> Quản lý bàn</a>
                <a href="${pageContext.request.contextPath}/views/menu.jsp"><i class="fa-solid fa-utensils"></i> Thực đơn</a>
                <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-receipt"></i> Hóa đơn</a>
                <a href="khachhang" class="active"><i class="fa-solid fa-users"></i> Khách hàng</a>
                <a href="${pageContext.request.contextPath}/views/kho.jsp"><i class="fa-solid fa-box"></i> Kho</a>
                <a href="${pageContext.request.contextPath}/views/ThongKeDoanhThu.jsp"><i class="fa-solid fa-chart-line"></i> Thống kê</a>
            </div>
        </div>
        <div class="logout-section">
            <a href="${pageContext.request.contextPath}/LoginServlet">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
    </div>

    <div class="main">
        <div class="header">
            <h3>${action == 'edit' ? 'Cập nhật thông tin khách hàng' : 'Thêm khách hàng mới'}</h3>
            <div class="user-info">
                <span>TH08495 - Trần Dương Phương Hiếu</span>
                <i class="fa-solid fa-bell"></i>
            </div>
        </div>

        <div class="content">
            <div class="card">
                <form action="khachhang" method="post">
                    <input type="hidden" name="action" value="${action == 'edit' ? 'update' : 'insert'}">

                    <div class="form-group">
                        <label>Mã KH:</label>
                        <input type="text" name="maKH" value="${kh.maKH}" ${action == 'edit' ? 'readonly' : ''} required>
                    </div>
                    <div class="form-group">
                        <label>Tên khách hàng:</label>
                        <input type="text" name="tenKH" value="${kh.tenKH}" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại:</label>
                        <input type="text" name="sdt" value="${kh.sdt}" required>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-floppy-disk"></i> ${action == 'edit' ? 'Cập nhật' : 'Lưu thông tin'}
                    </button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>