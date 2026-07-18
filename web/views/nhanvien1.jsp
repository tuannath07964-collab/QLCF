<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    .form-container { width: 100%; max-width: 400px; margin: 0 auto; font-family: sans-serif; }
    label { display: block; margin-top: 10px; font-weight: bold; }
    input[type="text"], input[type="date"], input[type="number"], select { 
        width: 100%; padding: 10px; margin: 5px 0 15px 0; 
        border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; 
    }
    .radio-group { margin-bottom: 15px; }
    .btn-group { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
    .btn-group button { padding: 10px 20px; cursor: pointer; border: none; border-radius: 4px; }
    .btn-submit { background: #28a745; color: white; }
    .btn-cancel { background: #6c757d; color: white; }
</style>

<div class="form-container">
    <%-- Thay action="add" thành action="${mode}" để linh hoạt --%>
    <form action="${pageContext.request.contextPath}/nhanvien" method="post">
        <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">
        
        <label>Mã nhân viên</label> 
        <input type="text" name="maNV" value="${nv.maNV}" ${mode == 'edit' ? 'readonly' : 'required'}>
        
        <label>Họ tên</label> 
        <input type="text" name="hoTen" value="${nv.hoTen}" required>
        
        <label>Giới tính</label>
        <div class="radio-group">
            <input type="radio" name="gioiTinh" value="Nam" ${nv.gioiTinh == 'Nam' || mode != 'edit' ? 'checked' : ''}> Nam
            <input type="radio" name="gioiTinh" value="Nữ" ${nv.gioiTinh == 'Nữ' ? 'checked' : ''}> Nữ
        </div>
        
        <label>Ngày sinh</label> 
        <input type="date" name="ngaySinh" value="${nv.ngaySinh}" required>
        
        <label>SĐT</label> 
        <input type="text" name="sdt" value="${nv.sdt}" required>
        
        <label>Chức vụ</label>
        <select name="chucVu">
            <option value="Thu ngân" ${nv.chucVu == 'Thu ngân' ? 'selected' : ''}>Thu ngân</option>
            <option value="Phục vụ" ${nv.chucVu == 'Phục vụ' ? 'selected' : ''}>Phục vụ</option>
            <option value="Pha chế" ${nv.chucVu == 'Pha chế' ? 'selected' : ''}>Pha chế</option>
            <option value="Kế toán" ${nv.chucVu == 'Kế toán' ? 'selected' : ''}>Kế toán</option>
            <option value="Kho" ${nv.chucVu == 'Kho' ? 'selected' : ''}>Kho</option>
        </select>
        
        <div class="btn-group">
            <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
            <button type="submit" class="btn-submit">${mode == 'edit' ? 'Cập nhật' : 'Lưu nhân viên'}</button>
        </div>
    </form>
</div>