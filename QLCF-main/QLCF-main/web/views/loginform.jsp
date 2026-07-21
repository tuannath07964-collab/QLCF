<%-- 
    Document   : loginform
    Created on : 26 thg 6, 2026, 20:37:52
    Author     : trung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Quản Lý Quán Cafe</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Cơ bản & Căn giữa màn hình */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            /* Thay URL này bằng ảnh nền quán cafe của bạn nếu có */
            background: url('https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=1978&auto=format&fit=crop') no-repeat center center/cover;
            position: relative;
        }
        /* Lớp phủ mờ cho hậu cảnh giống trong ảnh */
        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(4px);
            z-index: 1;
        }

        /* --- FORM CONTAINER --- */
        .login-card {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 400px; /* Kích thước chuẩn form trên localhost */
            background-color: #fdfaf6; /* Màu kem sáng */
            border-radius: 24px;
            padding: 40px 30px 20px 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            text-align: center;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* Header Form */
        .logo-area {
            color: #543d2b;
            font-size: 45px;
            margin-bottom: 15px;
        }
        .login-card h2 {
            color: #543d2b;
            font-size: 24px;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        .login-card .subtitle {
            color: #7a7067;
            font-size: 14px;
            margin-bottom: 30px;
        }

        /* --- INPUT FIELDS --- */
        .input-group {
            text-align: left;
            margin-bottom: 20px;
        }
        .input-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .input-wrapper i {
            position: absolute;
            color: #8a7e74;
            font-size: 16px;
        }
        .input-wrapper i.prefix-icon {
            left: 15px;
        }
        .input-wrapper i.suffix-icon {
            right: 15px;
            cursor: pointer;
            transition: 0.2s;
        }
        .input-wrapper i.suffix-icon:hover {
            color: #543d2b;
        }
        .input-wrapper input {
            width: 100%;
            padding: 13px 15px 13px 45px;
            border: 1px solid #ded7cc;
            border-radius: 12px;
            background-color: #fff;
            font-size: 15px;
            color: #333;
            outline: none;
            transition: 0.3s;
        }
        /* Style riêng cho ô password để chừa khoảng trống cho icon mắt bên phải */
        .input-wrapper input[type="password"], 
        .input-wrapper input[type="text"].pass-input {
            padding-right: 45px;
        }
        .input-wrapper input:focus {
            border-color: #543d2b;
            box-shadow: 0 0 5px rgba(84, 61, 43, 0.2);
        }

        /* --- BUTTON --- */
        .btn-submit {
            background-color: #543d2b; /* Màu nâu đậm đặc trưng */
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 20px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            margin-top: 15px;
            margin-bottom: 35px;
            letter-spacing: 1px;
            transition: background-color 0.3s;
        }
        .btn-submit:hover {
            background-color: #3d2b1f;
        }

        /* --- FOOTER GRAPHIC PLACEHOLDER --- */
        /* Vì hình ảnh vẽ nét bàn ghế ở đáy là ảnh tùy biến, đoạn này tạo layout chờ sẵn */
        .footer-graphic {
            margin-top: auto;
            border-top: 1px solid #f2ede4;
            padding-top: 15px;
            display: flex;
            justify-content: center;
            align-items: center;
            opacity: 0.5;
        }
        .footer-graphic i {
            font-size: 24px;
            color: #543d2b;
            margin: 0 15px;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="logo-area">
            <i class="fa-solid fa-mug-hot"></i>
        </div>
        <h2>QUẢN LÝ QUÁN CAFE</h2>
        <p class="subtitle">Đăng nhập để tiếp tục</p>
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <p style="color: red; margin-bottom: 15px; font-weight: 600;">
            <%= error %>
        </p>
        <%
            }
        %>
        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
            <div class="input-group">
                <label>Mã nhân viên</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-user prefix-icon"></i>
                    <input type="text" name="maNV" placeholder="Nhập mã nhân viên" required>
                </div>
            </div>

            <div class="input-group">
                <label>Mật khẩu</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock prefix-icon"></i>
                    <input type="password" name="matKhau" id="password" class="pass-input" placeholder="Nhập mật khẩu" required>
                    <i class="fa-regular fa-eye suffix-icon" id="togglePassword"></i>
                </div>
            </div>

            <button type="submit" class="btn-submit">ĐĂNG NHẬP</button>
        </form>

        <div class="footer-graphic">
            <i class="fa-solid fa-chair"></i>
            <i class="fa-solid fa-table"></i>
            <i class="fa-solid fa-seedling"></i>
        </div>
    </div>

    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');

        togglePassword.addEventListener('click', function () {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.classList.toggle('fa-eye-slash');
        });
    </script>
</body>
</html> 
