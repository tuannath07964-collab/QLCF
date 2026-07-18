<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>

<form action="${pageContext.request.contextPath}/nhanvien" method="post">
    <!-- Input hidden để chỉ định action cho Servlet -->
    <input type="hidden" name="action" value="updateCa">
    <input type="hidden" name="maNV" value="${nv.maNV}">

    <div style="margin-bottom: 10px;">
        <label>Chọn ca làm:</label><br>
        <input type="checkbox" name="caSang" value="true" ${nv.caSang ? 'checked' : ''}> Sáng
        <input type="checkbox" name="caChieu" value="true" ${nv.caChieu ? 'checked' : ''}> Chiều
        <input type="checkbox" name="caToi" value="true" ${nv.caToi ? 'checked' : ''}> Tối
    </div>

    <div style="margin-bottom: 10px;">
        <label>Giờ bắt đầu:</label>
        <input type="time" name="gioBatDau" value="${nv.gioBatDau}" required>
    </div>

    <div style="margin-bottom: 10px;">
        <label>Giờ kết thúc:</label>
        <input type="time" name="gioKetThuc" value="${nv.gioKetThuc}" required>
    </div>

    <button type="submit" style="background: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;">
        Lưu thay đổi
    </button>
</form>