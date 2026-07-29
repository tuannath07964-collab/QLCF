<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<c:choose>

    <c:when test="${not empty menu}">

        <div class="menu-detail">

            <div class="menu-detail-icon">
                <i class="fa-solid fa-mug-saucer"></i>
            </div>

            <h3>${menu.tenMon}</h3>

            <span class="badge ${menu.trangThai
                                ? 'badge-success'
                                : 'badge-danger'}">

                ${menu.trangThai ? 'Còn hàng' : 'Hết hàng'}
            </span>

            <div class="menu-detail-price">

                <fmt:formatNumber
                    value="${menu.gia}"
                    pattern="#,##0"/>

                đ
            </div>

            <div class="form-grid">

                <div class="form-group">

                    <label class="form-label">
                        Mã món
                    </label>

                    <input class="form-control"
                           type="text"
                           value="${menu.maMon}"
                           readonly>
                </div>

                <div class="form-group">

                    <label class="form-label">
                        Loại món
                    </label>

                    <input class="form-control"
                           type="text"
                           value="${menu.loaiMon}"
                           readonly>
                </div>

                <div class="form-group full">

                    <label class="form-label">
                        Nguyên liệu cần
                    </label>

                    <textarea class="form-control"
                              readonly>${menu.nguyenLieuCan}</textarea>
                </div>

                <div class="form-group full">

                    <label class="form-label">
                        Khả năng phục vụ
                    </label>

                    <input class="form-control"
                           type="text"
                           value="${menu.trangThai
                                    ? 'Có thể pha khoảng '.concat(menu.soPhanCoThePha).concat(' phần')
                                    : 'Không đủ nguyên liệu'}"
                           readonly>
                </div>

            </div>

        </div>

    </c:when>

    <c:otherwise>

        <div class="empty-state">

            <i class="fa-solid fa-circle-exclamation"></i>

            <strong>
                Không tìm thấy món
            </strong>
        </div>

    </c:otherwise>

</c:choose>