<%-- 
    Document   : loginform
    Created on : 26 thg 6, 2026, 20:37:52
    Author     : trung
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
                background: url('https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=1978&auto=format&fit=crop') no-repeat center center/cover;
                position: relative;
            }
            /* Lớp phủ mờ cho hậu cảnh */
            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.4);
                backdrop-filter: blur(4px);
                z-index: 1;
            }

            /* --- FORM CONTAINER --- */
            .login-card {
                position: relative;
                z-index: 2;
                width: 100%;
                max-width: 400px;
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
                background-color: #543d2b;
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
            .btn-submit:active {
                transform: scale(0.98);
            }

            /* --- ERROR MESSAGE --- */
            .error-message {
                color: #d32f2f;
                margin-bottom: 15px;
                font-weight: 600;
                text-align: center;
            }

            /* --- FOOTER GRAPHIC --- */
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
            
            <%-- Thông báo lỗi an toàn chống XSS với c:out --%>
            <c:if test="${not empty error}">
                <p class="error-message"><c:out value="${error}" /></p>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                <div class="input-group">
                    <label>Mã nhân viên</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-user prefix-icon"></i>
                        <input
                            type="text"
                            name="maNV"
                            value="<c:out value='${param.maNV}'/>"
                            placeholder="Nhập mã nhân viên"
                            autocomplete="username"
                            required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Mật khẩu</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock prefix-icon"></i>
                        <input
                            type="password"
                            name="matKhau"
                            id="password"
                            class="pass-input"
                            placeholder="Nhập mật khẩu"
                            autocomplete="current-password"
                            required>
                        <%-- Icon mặc định ban đầu hiển thị mắt đóng (fa-eye-slash) --%>
                        <i class="fa-regular fa-eye-slash suffix-icon" id="togglePassword"></i>
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
            const togglePassword = document.querySelector("#togglePassword");
            const password = document.querySelector("#password");

            togglePassword.addEventListener("click", function () {
                if (password.type === "password") {
                    password.type = "text";
                    // Thay đổi class icon sang mắt mở khi hiển thị mật khẩu dạng text
                    this.classList.remove("fa-eye-slash");
                    this.classList.add("fa-eye");
                } else {
                    password.type = "password";
                    // Trả về icon mắt đóng khi ẩn mật khẩu
                    this.classList.remove("fa-eye");
                    this.classList.add("fa-eye-slash");
                }
            });
        </script>
    </body>
</html>