<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${mode == 'edit' ? 'Cập nhật nguyên liệu' : 'Thêm nguyên liệu mới'}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/kho.css">
</head>
<body>
    <div class="content" style="max-width: 600px; margin: 40px auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
        <h2 style="margin-bottom: 20px; color: #2c3e50;">
            ${mode == 'edit' ? 'Cập nhật thông tin nguyên liệu' : 'Thêm nguyên liệu mới'}
        </h2>
        
        <form action="${pageContext.request.contextPath}/KhoServlet" method="post">
            <!-- Xác định action gửi về servlet là add hay edit -->
            <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">
            
            <div style="margin-bottom: 15px;">
                <label style="display: block; font-weight: 600; margin-bottom: 5px;">Mã nguyên liệu:</label>
                <input type="text" name="maNL" value="${nl.maNL}" ${mode == 'edit' ? 'readonly style="background:#e9ecef;"' : ''} required 
                       style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label style="display: block; font-weight: 600; margin-bottom: 5px;">Tên nguyên liệu:</label>
                <input type="text" name="tenNL" value="${nl.tenNL}" required 
                       style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label style="display: block; font-weight: 600; margin-bottom: 5px;">Số lượng:</label>
                <input type="number" name="soLuong" value="${nl.soLuong}" required min="0" 
                       style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
            </div>
            
            <div style="margin-bottom: 25px;">
                <label style="display: block; font-weight: 600; margin-bottom: 5px;">Đơn vị tính:</label>
                <input type="text" name="donVi" value="${nl.donVi}" required 
                       style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
            </div>
            
            <div style="display: flex; gap: 10px;">
                <button type="submit" style="background: #27ae60; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                    Lưu thông tin
                </button>
                <a href="${pageContext.request.contextPath}/KhoServlet" style="background: #95a5a6; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; display: inline-block; font-weight: 600;">
                    Hủy bỏ
                </a>
            </div>
        </form>
    </div>
</body>
</html>