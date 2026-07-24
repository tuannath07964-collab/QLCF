<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<form action="${pageContext.request.contextPath}/ban/them" method="POST" style="display: flex; flex-direction: column; gap: 15px;">

    <div>
        <label style="font-weight: bold; margin-bottom: 5px; display: block;">Tên bàn:</label>
        <input type="text" name="tenBan" required placeholder="VD: 01, VIP1" 
               style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
    </div>

    <div>
        <label style="font-weight: bold; margin-bottom: 5px; display: block;">Số chỗ ngồi:</label>
        <input type="number" name="soCho" required min="1" value="4" 
               style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
    </div>

    <div>
        <label style="font-weight: bold; margin-bottom: 5px; display: block;">Khu vực:</label>
        <select name="khuVuc" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
            <option value="Tầng 1">Tầng 1</option>
            <option value="Tầng 2">Tầng 2</option>
            <option value="Sân vườn">Sân vườn</option>
        </select>
    </div>

    <div style="text-align: right; margin-top: 10px;">
        <button type="button" onclick="closeModal()" style="padding: 8px 15px; border: none; background: #ddd; border-radius: 4px; cursor: pointer; margin-right: 10px;">Hủy</button>
        <button type="submit" style="padding: 8px 15px; border: none; background: #2e9bee; color: white; border-radius: 4px; cursor: pointer;">Lưu bàn</button>
    </div>

</form>

