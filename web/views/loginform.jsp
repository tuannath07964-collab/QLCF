<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Đăng nhập - Quản lý quán Cafe</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/loginform.css?v=11">
</head>

<body>

    <main class="login-layout">

        <section class="login-intro">

            <div class="intro-brand">

                <span class="intro-logo">
                    <i class="fa-solid fa-mug-hot"></i>
                </span>

                <span>QLCF</span>
            </div>

            <div class="intro-content">

                <span class="intro-label">
                    HỆ THỐNG QUẢN LÝ QUÁN CAFE
                </span>

                <h1>
                    Quản lý cửa hàng
                    <span>nhanh chóng và hiệu quả.</span>
                </h1>

                <p class="intro-description">
                    Quản lý bàn, hóa đơn, menu, khách hàng,
                    kho nguyên liệu và nhân viên trên cùng một hệ thống.
                </p>

                <div class="feature-list">

                    <div class="feature-item">

                        <div class="feature-icon">
                            <i class="fa-solid fa-chair"></i>
                        </div>

                        <div class="feature-content">

                            <strong>Quản lý bàn</strong>

                            <span>
                                Theo dõi trạng thái bàn và phục vụ khách hàng.
                            </span>
                        </div>
                    </div>

                    <div class="feature-item">

                        <div class="feature-icon">
                            <i class="fa-solid fa-file-invoice-dollar"></i>
                        </div>

                        <div class="feature-content">

                            <strong>Bán hàng nhanh</strong>

                            <span>
                                Hỗ trợ khách tại bàn và khách mang về.
                            </span>
                        </div>
                    </div>

                    <div class="feature-item">

                        <div class="feature-icon">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>

                        <div class="feature-content">

                            <strong>Kiểm soát kho</strong>

                            <span>
                                Theo dõi tồn kho và nguyên liệu sắp hết.
                            </span>
                        </div>
                    </div>

                </div>

            </div>

            <div class="intro-footer">
                © 2026 Quản lý quán Cafe
            </div>

        </section>

        <section class="login-panel">

            <div class="mobile-brand">

                <span class="mobile-logo">
                    <i class="fa-solid fa-mug-hot"></i>
                </span>

                <strong>QLCF</strong>
            </div>

            <div class="login-header">

                <span class="welcome-label">
                    CHÀO MỪNG TRỞ LẠI
                </span>

                <h2>Đăng nhập hệ thống</h2>

                <p>
                    Nhập tài khoản nhân viên để tiếp tục sử dụng hệ thống.
                </p>

            </div>

            <c:if test="${not empty error}">

                <div class="error-message">

                    <div class="error-icon">
                        <i class="fa-solid fa-circle-exclamation"></i>
                    </div>

                    <div class="error-content">

                        <strong>Đăng nhập không thành công</strong>

                        <span>
                            <c:out value="${error}"/>
                        </span>
                    </div>

                </div>

            </c:if>

            <form id="loginForm"
                  action="${pageContext.request.contextPath}/LoginServlet"
                  method="post">

                <div class="form-group">

                    <label for="employeeId">
                        Mã nhân viên
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            <i class="fa-regular fa-user"></i>
                        </span>

                        <input type="text"
                               id="employeeId"
                               name="maNV"
                               value="<c:out value='${param.maNV}'/>"
                               placeholder="Ví dụ: NV001"
                               maxlength="20"
                               autocomplete="username"
                               autofocus
                               required>

                    </div>

                </div>

                <div class="form-group">

                    <div class="label-row">

                        <label for="passwordField">
                            Mật khẩu
                        </label>

                        <span id="capsLockWarning"
                              class="caps-lock-warning">

                            <i class="fa-solid fa-triangle-exclamation"></i>
                            Caps Lock đang bật
                        </span>

                    </div>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            <i class="fa-solid fa-lock"></i>
                        </span>

                        <input type="password"
                               id="passwordField"
                               name="matKhau"
                               placeholder="Nhập mật khẩu"
                               autocomplete="current-password"
                               required>

                        <button type="button"
                                id="togglePassword"
                                class="password-toggle"
                                title="Hiển thị mật khẩu">

                            <i id="toggleIcon"
                               class="fa-regular fa-eye"></i>
                        </button>

                    </div>

                </div>

                <div class="form-options">

                    <label class="remember-option">

                        <input type="checkbox"
                               id="rememberEmployee">

                        <span class="checkbox-design">
                            <i class="fa-solid fa-check"></i>
                        </span>

                        <span>
                            Ghi nhớ mã nhân viên
                        </span>

                    </label>

                </div>

                <button type="submit"
                        id="loginButton"
                        class="login-button">

                    <span id="loginButtonText">
                        Đăng nhập
                    </span>

                    <i id="loginButtonIcon"
                       class="fa-solid fa-arrow-right"></i>

                </button>

            </form>

            <div class="login-note">

                <i class="fa-regular fa-clock"></i>

                <span>
                    Nhân viên chỉ đăng nhập được trong ca làm
                    đã được phân công.
                </span>

            </div>

        </section>

    </main>

    <script src="${pageContext.request.contextPath}/js/loginform.js?v=11"></script>

</body>
</html>