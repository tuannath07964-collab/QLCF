<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<form action="${pageContext.request.contextPath}/khachhang" method="post" class="p-3">
    <!-- Xác định hành động -->
    <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">

    <div class="mb-3">
        <label class="form-label fw-bold">Mã khách hàng:</label>
        <input type="text" name="maKH" value="${kh.maKH}" 
               ${mode == 'edit' ? 'readonly' : ''} 
               class="form-control" required>
        <small class="text-muted">${mode == 'edit' ? '(Không thể thay đổi mã)' : ''}</small>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Tên khách hàng:</label>
        <input type="text" name="hoTen" value="${kh.hoTen}" class="form-control" required>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">Số điện thoại:</label>
        <input type="text" name="sdt" value="${kh.sdt}" class="form-control" required>
    </div>

    <div class="mb-4">
        <label class="form-label fw-bold">Mã giảm giá:</label>
        <select name="maGiamGia" class="form-select" required>
            <option value="">-- Chọn mã giảm giá --</option>
            <c:forEach var="gg" items="${listGiamGia}">
                <option value="${gg}" ${kh.maGiamGia == gg ? 'selected' : ''}>${gg}</option>
            </c:forEach>
        </select>
    </div>

    <div class="d-flex justify-content-end gap-2">
        <button type="button" onclick="closeModal()" class="btn btn-secondary">Hủy</button>
        <button type="submit" class="btn btn-primary">${mode == 'edit' ? 'Cập nhật' : 'Thêm mới'}</button>
    </div>
</form>