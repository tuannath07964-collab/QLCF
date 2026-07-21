<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${mode == 'edit' ? 'Cập nhật món ăn' : 'Thêm món ăn mới'}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* CSS bổ sung nhanh để form đẹp, các ô input tràn đều 100% */
            .form-container-box {
                max-width: 500px;
                margin: 0 auto;
                font-family: Arial, sans-serif;
            }
            .form-container-box h2 {
                font-size: 20px;
                margin-bottom: 20px;
                color: #333;
                border-bottom: 2px solid #007bff;
                padding-bottom: 8px;
            }
            .form-group-custom {
                margin-bottom: 15px;
            }
            .form-group-custom label {
                display: block;
                font-weight: 600;
                margin-bottom: 6px;
                color: #444;
            }
            .form-group-custom input[type="text"],
            .form-group-custom input[type="number"],
            .form-group-custom select {
                width: 100%;
                padding: 9px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
            }
            .form-group-custom input:focus,
            .form-group-custom select:focus {
                border-color: #007bff;
                outline: none;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.2);
            }
            .checkbox-label {
                display: flex;
                align-items: center;
                font-weight: 600;
                cursor: pointer;
                gap: 8px;
            }
            .form-actions-custom {
                margin-top: 25px;
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .btn-save {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
                font-size: 14px;
            }
            .btn-save:hover {
                background-color: #0056b3;
            }
            .btn-back {
                color: #666;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
            }
            .btn-back:hover {
                color: #000;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="form-container-box">
            <h2><i class="fa-solid fa-utensils"></i> ${mode == 'edit' ? 'CẬP NHẬT THÔNG TIN MÓN' : 'THÊM MÓN ĂN MỚI'}</h2>

            <form action="${pageContext.request.contextPath}/menu" method="post">
                <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">

                <div class="form-group-custom">
                    <label>Mã món:</label>
                    <input type="text" name="maMon" value="${menu.maMon}" ${mode == 'edit' ? 'readonly' : ''} required placeholder="Ví dụ: M01">
                </div>

                <div class="form-group-custom">
                    <label>Tên món:</label>
                    <input type="text" name="tenMon" value="${menu.tenMon}" required placeholder="Nhập tên món ăn...">
                </div>

                <div class="form-group-custom">
                    <label>Loại món:</label>
                    <select name="loaiMon" required>
                        <option value="coffee" ${menu.loaiMon == 'coffee' ? 'selected' : ''}>Cà phê</option>
                        <option value="tea" ${menu.loaiMon == 'tea' ? 'selected' : ''}>Trà</option>
                        <option value="juice" ${menu.loaiMon == 'juice' ? 'selected' : ''}>Sinh tố / Nước ép</option>
                        <option value="snack" ${menu.loaiMon == 'snack' ? 'selected' : ''}>Bánh / Ăn vặt</option>
                    </select>
                </div>

                <div class="form-group-custom">
                    <label>Giá tiền (VNĐ):</label>
                    <input type="number" step="1000" name="gia" value="${menu.gia}" required placeholder="Ví dụ: 25000">
                </div>

                <div class="form-group-custom">
                    <label class="checkbox-label">
                        <input type="checkbox" name="trangThai" value="true" ${empty menu || menu.trangThai ? 'checked' : ''} style="width: 18px; height: 18px;"> 
                        Còn hàng
                    </label>
                </div>   

                <div class="form-actions-custom">
                    <button type="submit" class="btn-save">
                        <i class="fa-solid fa-save"></i> ${mode == 'edit' ? 'Cập nhật' : 'Thêm mới'}
                    </button>
                    <a href="${pageContext.request.contextPath}/menu?action=list" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </form>
        </div>
    </body>
</html>