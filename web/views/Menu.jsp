<!DOCTYPE html>
<html lang="vi">
<head>
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <title>Quản lý Menu - Preview</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Roboto', sans-serif; }
        body { display:flex; min-height:100vh; background:#f4f6f8; }

        .sidebar { width:280px; background:#2c3e50; color:#fff; display:flex; flex-direction:column; min-height:100vh; }
        .sidebar-logo { display:flex; align-items:center; gap:12px; padding:22px 24px; background:#1c2833; font-family:'Playfair Display', serif; font-weight:700; font-size:19px; letter-spacing:0.5px; }
        .sidebar-nav { flex:1; padding-top:10px; }
        .sidebar-nav a { display:flex; align-items:center; gap:14px; padding:16px 26px; color:#dfe6ec; text-decoration:none; font-size:15.5px; transition:background .2s; }
        .sidebar-nav a:hover { background:#33495f; }
        .sidebar-nav a.active { background:#2e9bee; color:#fff; font-weight:500; }
        .logout { display:flex; align-items:center; justify-content:center; gap:10px; padding:20px; background:#e0503a; color:#fff; text-decoration:none; font-size:15.5px; font-weight:500; }
        .logout:hover { background:#c74631; }

        .main { flex:1; display:flex; flex-direction:column; }
        .topbar { display:flex; justify-content:space-between; align-items:center; padding:20px 40px; background:#fff; border-bottom:1px solid #e6e9ec; }
        .topbar h1 { font-family:'Playfair Display', serif; font-weight:700; font-size:30px; color:#1c2833; }
        .user-info { display:flex; align-items:center; gap:10px; font-family:'Playfair Display', serif; font-weight:600; color:#1c2833; font-size:16px; }

        .content { padding:36px 40px; }

        .toolbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:14px; }
        .search-box { display:flex; gap:8px; }
        .search-box input { width:280px; padding:9px 14px; border:1px solid #ccd2d8; border-radius:4px; font-size:14px; background:#fff; }
        .search-box button { width:42px; border:1px solid #ccd2d8; background:#fff; border-radius:4px; cursor:pointer; font-size:15px; }
        .search-box button:hover { background:#eef1f3; }

        .btn-add { background:#27ae60; color:#fff; border:none; padding:11px 20px; border-radius:4px; font-size:14.5px; font-weight:500; cursor:pointer; text-decoration:none; display:inline-flex; align-items:center; gap:8px; }
        .btn-add:hover { background:#219150; }

        .category-tabs { display:flex; gap:10px; margin-bottom:26px; flex-wrap:wrap; }
        .category-tabs a { padding:9px 18px; border-radius:20px; font-size:14px; font-weight:500; text-decoration:none; color:#5c6773; background:#fff; border:1px solid #e2e6ea; transition:.15s; }
        .category-tabs a:hover { border-color:#2e9bee; color:#2e9bee; }
        .category-tabs a.active { background:#2c3e50; border-color:#2c3e50; color:#fff; }

        .menu-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(240px, 1fr)); gap:22px; }
        .mon-card { background:#fff; border-radius:10px; overflow:hidden; box-shadow:0 1px 4px rgba(0,0,0,0.07); display:flex; flex-direction:column; transition:transform .15s, box-shadow .15s; }
        .mon-card:hover { transform:translateY(-3px); box-shadow:0 6px 16px rgba(0,0,0,0.1); }

        .mon-anh-wrap { position:relative; width:100%; height:150px; display:flex; align-items:center; justify-content:center; font-size:46px; }
        .mon-badge { position:absolute; top:10px; right:10px; padding:4px 10px; border-radius:12px; font-size:11.5px; font-weight:600; }
        .badge-con { background:#e3f9ec; color:#1f9d55; }
        .badge-het { background:#fdeceb; color:#e0503a; }

        .mon-info { padding:14px 16px 16px; display:flex; flex-direction:column; gap:6px; flex:1; }
        .mon-loai { font-size:12px; color:#8a94a0; text-transform:uppercase; letter-spacing:.4px; }
        .mon-ten { font-family:'Playfair Display', serif; font-weight:700; font-size:17px; color:#1c2833; line-height:1.25; }
        .mon-ma { font-size:12px; color:#b0b7bd; }
        .mon-gia { margin-top:auto; font-size:16px; font-weight:700; color:#c0392b; padding-top:8px; }

        .mon-actions { display:flex; border-top:1px solid #eef0f2; }
        .mon-actions a { flex:1; text-align:center; padding:10px 0; font-size:13px; font-weight:500; text-decoration:none; color:#5c6773; }
        .mon-actions a.btn-sua { color:#2e9bee; border-right:1px solid #eef0f2; }
        .mon-actions a.btn-sua:hover { background:#eaf3fc; }
        .mon-actions a.btn-xoa { color:#e0503a; }
        .mon-actions a.btn-xoa:hover { background:#fdeceb; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-logo">☕ QUẢN LÝ QUÁN CAFE</div>
        <div class="sidebar-nav">
            <a href="#">🏠 Trang chủ</a>
            <a href="#">👤 Nhân viên</a>
            <a href="#">🧾 Hóa đơn</a>
            <a href="#" class="active">☕ Menu</a>
            <a href="#">🪑 Bàn</a>
            <a href="#">📦 Kho</a>
            <a href="#">👥 Khách hàng</a>
            <a href="#">📊 Thống kê</a>
        </div>
        <a href="#" class="logout">⏻ Đăng xuất</a>
    </div>

    <div class="main">
        <div class="topbar">
            <h1>Quản lý Menu</h1>
            <div class="user-info">👤 TH08199 - Trịnh Bình Minh</div>
        </div>

        <div class="content">

            <div class="toolbar">
                <form class="search-box">
                    <input type="text" placeholder="Nhập tên món hoặc mã món...">
                    <button type="submit">🔍</button>
                </form>
                <a href="#" class="btn-add">＋ Thêm món</a>
            </div>

            <div class="category-tabs">
                <a href="#" class="active">Tất cả</a>
                <a href="#">Cà phê</a>
                <a href="#">Trà</a>
                <a href="#">Sinh tố / Nước ép</a>
                <a href="#">Bánh / Ăn vặt</a>
            </div>

            <div class="menu-grid">

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#e8dcc8;">☕</div>
                    <div class="mon-info">
                        <span class="mon-loai">Cà phê</span>
                        <span class="mon-ten">Cà phê sữa đá</span>
                        <span class="mon-ma">Mã: MON01</span>
                        <span class="mon-gia">29.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#3a2b22; color:#fff;">
                        <span class="mon-badge badge-con">Còn hàng</span>☕
                    </div>
                    <div class="mon-info">
                        <span class="mon-loai">Cà phê</span>
                        <span class="mon-ten">Bạc xỉu</span>
                        <span class="mon-ma">Mã: MON02</span>
                        <span class="mon-gia">32.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#d9ecd0;">
                        <span class="mon-badge badge-con">Còn hàng</span>🍵
                    </div>
                    <div class="mon-info">
                        <span class="mon-loai">Trà</span>
                        <span class="mon-ten">Trà đào cam sả</span>
                        <span class="mon-ma">Mã: MON03</span>
                        <span class="mon-gia">39.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#fbe4d5;">
                        <span class="mon-badge badge-het">Hết hàng</span>🍑
                    </div>
                    <div class="mon-info">
                        <span class="mon-loai">Trà</span>
                        <span class="mon-ten">Hồng trà kem cheese</span>
                        <span class="mon-ma">Mã: MON04</span>
                        <span class="mon-gia">42.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#fde3ec;">
                        <span class="mon-badge badge-con">Còn hàng</span>🍓
                    </div>
                    <div class="mon-info">
                        <span class="mon-loai">Sinh tố / Nước ép</span>
                        <span class="mon-ten">Sinh tố dâu tây</span>
                        <span class="mon-ma">Mã: MON05</span>
                        <span class="mon-gia">35.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#fff2c9;">
                        <span class="mon-badge badge-con">Còn hàng</span>🍋
                    </div>
                    <div class="mon-info">
                        <span class="mon-loai">Sinh tố / Nước ép</span>
                        <span class="mon-ten">Nước ép cam</span>
                        <span class="mon-ma">Mã: MON06</span>
                        <span class="mon-gia">30.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#f0e2d0;">
                        <span class="mon-badge badge-con">Còn hàng</span>🧁
                    </div>
                    <div class="mon-info">
                        <span class="mon-loai">Bánh / Ăn vặt</span>
                        <span class="mon-ten">Bánh tiramisu</span>
                        <span class="mon-ma">Mã: MON07</span>
                        <span class="mon-gia">45.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

                <div class="mon-card">
                    <div class="mon-anh-wrap" style="background:#e5d8c3;">
                        <span class="mon-badge badge-het">Hết hàng</span>🥐
                    </div>
                    <div class="mon-info">
                        <span class="mon-loai">Bánh / Ăn vặt</span>
                        <span class="mon-ten">Bánh croissant bơ</span>
                        <span class="mon-ma">Mã: MON08</span>
                        <span class="mon-gia">25.000 đ</span>
                    </div>
                    <div class="mon-actions">
                        <a class="btn-sua" href="#">Sửa</a>
                        <a class="btn-xoa" href="#">Xóa</a>
                    </div>
                </div>

            </div>

        </div>
    </div>

</body>
</html>