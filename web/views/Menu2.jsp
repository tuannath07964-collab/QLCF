<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${mode == 'edit' ? 'Chỉnh sửa món ăn' : 'Thêm món mới'}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <div class="form-container" style="padding: 10px;">
            <h2><i class="fa-solid fa-utensils"></i> ${mode == 'edit' ? 'CHỈNH SỬA MÓN ĂN' : 'THÊM MÓN MỚI'}</h2>

            <!-- Form gửi dữ liệu về Servlet với action tương ứng (add hoặc edit) -->
            <form action="${pageContext.request.contextPath}/menu" method="post">
                <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">

                <div class="form-group" style="margin-bottom: 15px;">
                    <label style="display:block; font-weight:600; margin-bottom:5px;">Mã món:</label>
                    <!-- Nếu đang sửa thì khóa mã món lại bằng readonly -->
                    <input type="text" name="maMon" value="${menu.maMon}" ${mode == 'edit' ? 'readonly' : ''} required 
                           style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 6px;">
                </div>

                <div class="form-group" style="margin-bottom: 15px;">
                    <label style="display:block; font-weight:600; margin-bottom:5px;">Tên món:</label>
                    <input type="text" name="tenMon" value="${menu.tenMon}" required 
                           style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 6px;">
                </div>

                <div class="form-group" style="margin-bottom: 15px;">
                    <label style="display:block; font-weight:600; margin-bottom:5px;">Loại món:</label>
                    <select name="loaiMon" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 6px;">
                        <option value="coffee" ${menu.loaiMon == 'coffee' ? 'selected' : ''}>Cà phê</option>
                        <option value="tea" ${menu.loaiMon == 'tea' ? 'selected' : ''}>Trà</option>
                        <option value="juice" ${menu.loaiMon == 'juice' ? 'selected' : ''}>Sinh tố / Nước ép</option>
                        <option value="snack" ${menu.loaiMon == 'snack' ? 'selected' : ''}>Bánh / Ăn vặt</option>
                    </select>
                </div>
                <div class="form-group" style="margin-bottom: 15px;">
                    <label style="display:block; font-weight:600; margin-bottom:5px;">Giá tiền (VNĐ):</label>
                    <input type="number" step="0.01" name="gia" value="${menu.gia}" required 
                           style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 6px;">
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label style="font-weight:600; cursor:pointer;">
                        <input type="checkbox" name="trangThai" value="true" ${empty menu || menu.trangThai ? 'checked' : ''}> 
                        Còn hàng
                    </label>
                </div>

                <div class="form-actions" style="margin-top: 20px; text-align: right;">
                    <button type="button" onclick="closeModal()" class="btn-cancel" style="padding: 8px 15px; margin-right: 10px; border: none; background: #ccc; border-radius: 6px; cursor: pointer;">
                        <i class="fa-solid fa-arrow-left"></i> Hủy
                    </button>
                    <button type="submit" class="btn-submit" style="padding: 8px 20px; border: none; background: #2e9bee; color: white; font-weight: bold; border-radius: 6px; cursor: pointer;">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu lại
                    </button>
                </div>
            </form>
        </div>
    </body>
</html>