<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Quản Lý Quán Cafe</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/loginform.css">
</head>
<body>
    <div class="login-card">
        <div class="logo-area"><i class="fa-solid fa-mug-hot"></i></div>
        <h2>QUẢN LÝ QUÁN CAFE</h2>
        <p class="subtitle">Đăng nhập để tiếp tục</p>
        
        <c:if test="${not empty error}">
            <p class="error-message"><c:out value="${error}" /></p>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
            <div class="input-group">
                <label>Mã nhân viên</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" name="maNV" value="<c:out value='${param.maNV}'/>" placeholder="Nhập mã nhân viên" required>
                </div>
            </div>

            <div class="input-group">
                <label>Mật khẩu</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" name="matKhau" id="passwordField" placeholder="Nhập mật khẩu" required>
                    <i class="fa-solid fa-eye-slash suffix-icon" id="toggleIcon"></i>
                </div>
            </div>

            <button type="submit" class="btn-submit">ĐĂNG NHẬP</button>
        </form>
    </div>
    <script src="${pageContext.request.contextPath}/js/loginform.js"></script>
</body>
</html>