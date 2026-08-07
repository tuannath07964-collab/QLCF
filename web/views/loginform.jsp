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

        <title>Đăng nhập - Cafe Manager</title>

        <link rel="icon"
              type="image/png"
              href="${pageContext.request.contextPath}/image/logo-cafe-manager-icon.png">

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/loginform.css?v=102">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/cafe-theme.css?v=2">
    </head>

    <body>

        <main class="login-page">

            <div class="background-left"></div>
            <div class="background-right"></div>

            <section class="login-card">

                <div class="brand">

                    <img class="brand-logo"
                         src="${pageContext.request.contextPath}/image/logo-cafe-manager.png?v=102"
                         width="60"
                         height="60"
                         alt="Cafe Manager">

                </div>

                <div class="decoration decoration-one">
                    <i class="fa-solid fa-seedling"></i>
                </div>

                <div class="decoration decoration-two">
                    <i class="fa-solid fa-seedling"></i>
                </div>

                <section class="introduction">

                    <div class="introduction-content">

                        <span class="introduction-label">
                            HỆ THỐNG QUẢN LÝ QUÁN CAFE
                        </span>

                        <h1>
                            Quản lý quán cafe
                            <span>đơn giản và hiện đại</span>
                        </h1>

                    </div>

                    <div class="coffee-image">

                        <img src="${pageContext.request.contextPath}/image/coffee.jpg"
                             alt="Không gian quán cafe">

                    </div>

                </section>

                <section class="login-content">

                    <div class="login-header">

                        <div class="welcome-icon">
                            <i class="fa-solid fa-hand"></i>
                        </div>

                        <h2>Chào mừng trở lại!</h2>

                        <p>
                            Đăng nhập để tiếp tục quản lý cửa hàng.
                        </p>

                    </div>

                    <c:if test="${not empty error}">

                        <div class="error-message">

                            <i class="fa-solid fa-circle-exclamation"></i>

                            <div>
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

                                <i class="fa-regular fa-user input-icon"></i>

                                <input type="text"
                                       id="employeeId"
                                       name="maNV"
                                       value="<c:out value='${param.maNV}'/>"
                                       placeholder="Nhập mã nhân viên"
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

                                <i class="fa-solid fa-lock input-icon"></i>

                                <input type="password"
                                       id="passwordField"
                                       name="matKhau"
                                       placeholder="Nhập mật khẩu"
                                       autocomplete="current-password"
                                       required>

                                <button type="button"
                                        id="togglePassword"
                                        class="password-toggle"
                                        title="Hiển thị mật khẩu"
                                        aria-label="Hiển thị mật khẩu">

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

                                <span>Ghi nhớ mã nhân viên</span>

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

            </section>

        </main>

        <script src="${pageContext.request.contextPath}/js/loginform.js?v=30"></script>

    </body>
</html>