const fmt = value =>
    Number(value || 0).toLocaleString("vi-VN") + "đ";

let cart = [];

/**
 * Đọc danh sách món đã lưu trong hóa đơn.
 */
function initCartFromSavedData(rawJson) {
    if (!rawJson || !rawJson.trim()) {
        cart = [];
        renderCart();
        return;
    }

    try {
        const saved = JSON.parse(rawJson);

        if (!Array.isArray(saved)) {
            cart = [];
            renderCart();
            return;
        }

        cart = saved
            .map(normalizeCartItem)
            .filter(item =>
                item.maMon
                && item.name
                && item.qty > 0
            );

    } catch (error) {
        console.error(
            "Không đọc được danh sách món cũ:",
            error
        );

        cart = [];
    }

    renderCart();
}

/**
 * Chuẩn hóa dữ liệu giỏ hàng cũ và mới.
 */
function normalizeCartItem(item) {
    if (!item || typeof item !== "object") {
        return {
            maMon: "",
            name: "",
            price: 0,
            qty: 0
        };
    }

    const maMon =
        item.maMon
        || item.maMonAn
        || item.id
        || "";

    const name =
        item.name
        || item.tenMon
        || item.ten
        || "";

    const price =
        Number(
            item.price
            ?? item.gia
            ?? item.donGia
            ?? 0
        );

    const qty =
        Number(
            item.qty
            ?? item.soLuong
            ?? item.quantity
            ?? 1
        );

    return {
        maMon: String(maMon),
        name: String(name),
        price: Number.isFinite(price)
            ? price
            : 0,
        qty: Number.isFinite(qty)
            ? qty
            : 1
    };
}

/**
 * Thêm một món vào hóa đơn.
 */
function addToReceipt(
    maMon,
    name,
    price
) {
    if (!maMon || !name) {
        alert("Thông tin món không hợp lệ.");
        return;
    }

    const numericPrice =
        Number(price);

    if (
        !Number.isFinite(numericPrice)
        || numericPrice < 0
    ) {
        alert("Giá món không hợp lệ.");
        return;
    }

    const existing = cart.find(
        item => item.maMon === maMon
    );

    if (existing) {
        existing.qty += 1;

    } else {
        cart.push({
            maMon,
            name,
            price: numericPrice,
            qty: 1
        });
    }

    renderCart();
}

/**
 * Tăng hoặc giảm số lượng món.
 */
function changeQty(
    index,
    delta
) {
    if (
        !Number.isInteger(index)
        || !cart[index]
    ) {
        return;
    }

    const numericDelta =
        Number(delta);

    if (!Number.isFinite(numericDelta)) {
        return;
    }

    cart[index].qty += numericDelta;

    if (cart[index].qty <= 0) {
        cart.splice(index, 1);
    }

    renderCart();
}

/**
 * Xóa món khỏi hóa đơn đang chỉnh sửa.
 */
function removeItem(index) {
    if (
        !Number.isInteger(index)
        || !cart[index]
    ) {
        return;
    }

    cart.splice(index, 1);
    renderCart();
}

/**
 * Hiển thị giỏ hàng và tính tổng tiền.
 */
function renderCart() {
    const box =
        document.getElementById(
            "receiptItems"
        );

    if (!box) {
        return;
    }

    if (cart.length === 0) {
        box.innerHTML = `
            <div class="empty-hint">
                Chưa có món nào được chọn
            </div>
        `;

    } else {
        box.innerHTML = cart
            .map(
                (item, index) => `
                    <div class="r-item"
                         style="
                         display:flex;
                         align-items:center;
                         gap:8px;
                         margin-bottom:10px;">

                        <div style="
                             flex:1;
                             min-width:0;">

                            <strong style="
                                    display:block;
                                    overflow:hidden;
                                    text-overflow:ellipsis;
                                    white-space:nowrap;">

                                ${escapeHtml(item.name)}
                            </strong>

                            <small>
                                ${fmt(item.price)}
                            </small>
                        </div>

                        <button type="button"
                                aria-label="Giảm số lượng"
                                onclick="changeQty(${index}, -1)">

                            −
                        </button>

                        <span style="
                              min-width:24px;
                              text-align:center;
                              font-weight:700;">

                            ${item.qty}
                        </span>

                        <button type="button"
                                aria-label="Tăng số lượng"
                                onclick="changeQty(${index}, 1)">

                            +
                        </button>

                        <strong style="
                                min-width:85px;
                                text-align:right;">

                            ${fmt(
                                item.price * item.qty
                            )}
                        </strong>

                        <button type="button"
                                aria-label="Xóa món"
                                onclick="removeItem(${index})"
                                style="
                                color:#c0392b;
                                font-weight:700;">

                            ×
                        </button>
                    </div>
                `
            )
            .join("");
    }

    const subtotal = cart.reduce(
        (sum, item) =>
            sum
            + Number(item.price)
            * Number(item.qty),
        0
    );

    const vat =
        Math.round(subtotal * 0.08);

    const total =
        subtotal + vat;

    const customerSelect =
        document.getElementById(
            "customerSel"
        );

    const saveNewCustomer =
        document.getElementById(
            "saveNewCustomer"
        );

    const hasCustomer =
        Boolean(
            customerSelect
            && customerSelect.value
        )
        || Boolean(
            saveNewCustomer
            && saveNewCustomer.checked
        );

    const points =
        hasCustomer
            ? Math.floor(total / 10000)
            : 0;

    setText(
        "subTotal",
        fmt(subtotal)
    );

    setText(
        "vatAmt",
        fmt(vat)
    );

    setText(
        "grandTotal",
        fmt(total)
    );

    setText(
        "pointPreview",
        points + " điểm"
    );

    const totalInput =
        document.getElementById(
            "inputTongTien"
        );

    if (totalInput) {
        totalInput.value = total;
    }

    syncCartFields();
}

/**
 * Đồng bộ giỏ hàng sang dữ liệu gửi cho Servlet.
 */
function syncCartFields() {
    const jsonInput =
        document.getElementById(
            "inputDanhSachMon"
        );

    const container =
        document.getElementById(
            "cartFields"
        );

    if (jsonInput) {
        jsonInput.value =
            JSON.stringify(cart);
    }

    if (!container) {
        return;
    }

    container.innerHTML = "";

    cart.forEach(item => {
        const maMonInput =
            document.createElement(
                "input"
            );

        maMonInput.type = "hidden";
        maMonInput.name = "itemMaMon";
        maMonInput.value = item.maMon;

        const qtyInput =
            document.createElement(
                "input"
            );

        qtyInput.type = "hidden";
        qtyInput.name = "itemQty";
        qtyInput.value = item.qty;

        container.append(
            maMonInput,
            qtyInput
        );
    });
}

/**
 * Kiểm tra dữ liệu trước khi lưu hoặc thanh toán.
 */
function prepareInvoiceSubmit(action) {
    if (cart.length === 0) {
        alert(
            "Vui lòng chọn ít nhất một món."
        );

        return false;
    }

    const actionInput =
        document.getElementById(
            "formAction"
        );

    if (!actionInput) {
        alert(
            "Không tìm thấy hành động của hóa đơn."
        );

        return false;
    }

    actionInput.value = action;

    syncCartFields();

    if (action === "pay") {
        const customerSelect =
            document.getElementById(
                "customerSel"
            );

        const saveNewCustomer =
            document.getElementById(
                "saveNewCustomer"
            );

        const newCustomerName =
            document.getElementById(
                "newCustomerName"
            );

        if (
            saveNewCustomer
            && saveNewCustomer.checked
        ) {
            if (
                !newCustomerName
                || !newCustomerName.value.trim()
            ) {
                alert(
                    "Vui lòng nhập họ tên khách hàng cần lưu."
                );

                if (newCustomerName) {
                    newCustomerName.focus();
                }

                return false;
            }

            if (
                newCustomerName.value.trim().length
                > 100
            ) {
                alert(
                    "Họ tên khách hàng không được vượt quá 100 ký tự."
                );

                newCustomerName.focus();
                return false;
            }

            if (customerSelect) {
                customerSelect.value = "";
            }
        }

        return confirm(
            "Xác nhận thanh toán?\n\n"
            + "Sau khi thanh toán:\n"
            + "- Kho sẽ tự động trừ nguyên liệu.\n"
            + "- Khách hàng được cộng điểm.\n"
            + "- Bàn được chuyển về trạng thái trống."
        );
    }

    return true;
}

/**
 * Gán nội dung cho phần tử.
 */
function setText(
    id,
    value
) {
    const element =
        document.getElementById(id);

    if (element) {
        element.textContent = value;
    }
}

/**
 * Chống chèn HTML từ tên món.
 */
function escapeHtml(value) {
    return String(value ?? "")
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}

/**
 * Lọc món theo loại và khởi tạo hóa đơn.
 */
document.addEventListener(
    "DOMContentLoaded",
    function () {
        document
            .querySelectorAll(".tab")
            .forEach(function (tab) {
                tab.addEventListener(
                    "click",
                    function () {
                        document
                            .querySelectorAll(
                                ".tab"
                            )
                            .forEach(
                                function (item) {
                                    item.classList
                                        .remove(
                                            "active"
                                        );
                                }
                            );

                        tab.classList.add(
                            "active"
                        );

                        const category =
                            tab.dataset.cat;

                        document
                            .querySelectorAll(
                                ".menu-item"
                            )
                            .forEach(
                                function (item) {
                                    const matched =
                                        category === "all"
                                        || item.dataset.category
                                        === category;

                                    item.style.display =
                                        matched
                                            ? "flex"
                                            : "none";
                                }
                            );
                    }
                );
            });

        const table =
            document.getElementById(
                "tableSel"
            );

        if (table) {
            table.addEventListener(
                "change",
                function () {
                    const selectedOption =
                        table.options[
                            table.selectedIndex
                        ];

                    setText(
                        "metaTable",
                        table.value
                            ? selectedOption.textContent
                                .trim()
                            : "—"
                    );
                }
            );
        }

        const customerSelect =
            document.getElementById(
                "customerSel"
            );

        if (customerSelect) {
            customerSelect.addEventListener(
                "change",
                renderCart
            );
        }

        const saveNewCustomer =
            document.getElementById(
                "saveNewCustomer"
            );

        if (saveNewCustomer) {
            saveNewCustomer.addEventListener(
                "change",
                renderCart
            );
        }

        const oldCart =
            document.getElementById(
                "oldCartData"
            );

        initCartFromSavedData(
            oldCart
                ? oldCart.value
                : ""
        );

        const form =
            document.getElementById(
                "invoiceForm"
            );

        if (form) {
            form.addEventListener(
                "submit",
                syncCartFields
            );
        }
    }
);