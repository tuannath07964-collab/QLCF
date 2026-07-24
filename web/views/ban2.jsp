<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>

<c:choose>
    <%-- Nếu không tìm thấy bàn --%>
    <c:when test="${empty banDetail}">
        <p>Không tìm thấy thông tin bàn.</p>
    </c:when>
    
    <%-- Nếu tìm thấy bàn, in ra HTML --%>
    <c:otherwise>
        <div style="font-size: 14px; line-height: 1.6;">
            <p><b>Mã bàn:</b> ${banDetail.maBan}</p>
            <p><b>Tên bàn:</b> ${banDetail.tenBan}</p>
            <p><b>Số chỗ ngồi:</b> ${banDetail.soCho}</p>
            <p><b>Khu vực:</b> ${banDetail.khuVuc}</p>
            <p><b>Trạng thái:</b> ${banDetail.trangThai == 0 ? 'Trống' : 'Đang phục vụ'}</p>
        </div>
    </c:otherwise>
</c:choose>