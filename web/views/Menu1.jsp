<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${mode == 'edit' ? 'Cập nhật món ăn' : 'Thêm món ăn mới'}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <div class="form-container">
            <h2>${mode == 'edit' ? 'CẬP NHẬT THÔNG TIN MÓN' : 'THÊM MÓN ĂN MỚI'}</h2>

            <form action="${pageContext.request.contextPath}/menu" method="post">
                <!-- Action gửi về servlet: edit hoặc add -->
                <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">

                <div class="form-group">
                    <label>Mã món:</label>
                    <input type="text" name="maMon" value="${menu.maMon}" ${mode == 'edit' ? 'readonly' : ''} required 
                           placeholder="Ví dụ: M21">
                </div>

                <div class="form-group">
                    <label>Tên món:</label>
                    <input type="text" name="tenMon" value="${menu.tenMon}" required 
                           placeholder="Nhập tên món ăn/thức uống...">
                </div>

                <div class="form-group">
                    <label>Loại món:</label>
                    <select name="loaiMon" required>
                        <option value="coffee" ${menu.loaiMon == 'coffee' ? 'selected' : ''}>Cà phê</option>
                        <option value="tea" ${menu.loaiMon == 'tea' ? 'selected' : ''}>Trà</option>
                        <option value="juice" ${menu.loaiMon == 'juice' ? 'selected' : ''}>Sinh tố / Nước ép</option>
                        <option value="snack" ${menu.loaiMon == 'snack' ? 'selected' : ''}>Bánh / Ăn vặt</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Giá tiền (VNĐ):</label>
                    <input type="number" step="1000" name="gia" value="${menu.gia}" required 
                           placeholder="Ví dụ: 30000">
                </div>

                <!-- Ô checkbox Trạng thái (đã gộp làm một và đặt vị trí hợp lý ở đây) -->
                <div class="form-group checkbox-group" style="margin-bottom: 20px;">
                    <label style="cursor: pointer; font-weight: 600;">
                        <input type="checkbox" name="trangThai" value="true" 
                               ${empty menu || menu.trangThai ? 'checked' : ''}> 
                        Còn hàng
                    </label>
                </div>   

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-save"></i> ${mode == 'edit' ? 'Cập nhật' : 'Thêm mới'}
                    </button>
                    <a href="${pageContext.request.contextPath}/menu?action=list" class="btn-cancel">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </form>
        </div>
    </body>
</html>