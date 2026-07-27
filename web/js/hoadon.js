const fmt = value =>
    Number(value || 0)
        .toLocaleString('vi-VN') + 'đ';

let cart = [];

function initCartFromSavedData(rawJson) {
    if (!rawJson || !rawJson.trim()) {
        renderCart();
        return;
    }

    try {
        const saved = JSON.parse(rawJson);

        cart = Array.isArray(saved)
            ? saved
            : [];

    } catch (error) {
        console.error(
            'Không đọc được danh sách món cũ:',
            error
        );

        cart = [];
    }

    renderCart();
}

function addToReceipt(
    maMon,
    name,
    price
) {
    const existing = cart.find(
        item => item.maMon === maMon
    );

    if (existing) {
        existing.qty += 1;
    } else {
        cart.push({
            maMon,
            name,
            price: Number(price),
            qty: 1
        });
    }

    renderCart();
}

function changeQty(index, delta) {
    if (!cart[index]) {
        return;
    }

    cart[index].qty += delta;

    if (cart[index].qty <= 0) {
        cart.splice(index, 1);
    }

    renderCart();
}

function removeItem(index) {
    cart.splice(index, 1);
    renderCart();
}

function renderCart() {
    const box =
        document.getElementById(
            'receiptItems'
        );

    if (!box) {
        return;
    }

    if (cart.length === 0) {
        box.innerHTML =
            '<div class="empty-hint">'
            + 'Chưa có món nào được chọn'
            + '</div>';
    } else {
        box.innerHTML = cart.map(
            (item, index) => `
                <div class="r-item"
                     style="
                     display:flex;
                     align-items:center;
                     gap:8px;
                     margin-bottom:10px;">

                    <div style="flex:1;">
                        <strong>
                            ${escapeHtml(item.name)}
                        </strong>
                        <br>
                        <small>
                            ${fmt(item.price)}
                        </small>
                    </div>

                    <button type="button"
                            onclick="
                                changeQty(
                                    ${index},
                                    -1
                                )
                            ">
                        −
                    </button>

                    <span>${item.qty}</span>

                    <button type="button"
                            onclick="
                                changeQty(
                                    ${index},
                                    1
                                )
                            ">
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
                            onclick="
                                removeItem(${index})
                            "
                            style="color:#c0392b;">
                        ×
                    </button>
                </div>
            `
        ).join('');
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
            'customerSel'
        );

    const points =
        customerSelect
        && customerSelect.value
            ? Math.floor(total / 10000)
            : 0;

    setText(
        'subTotal',
        fmt(subtotal)
    );

    setText(
        'vatAmt',
        fmt(vat)
    );

    setText(
        'grandTotal',
        fmt(total)
    );

    setText(
        'pointPreview',
        points + ' điểm'
    );

    const totalInput =
        document.getElementById(
            'inputTongTien'
        );

    if (totalInput) {
        totalInput.value = total;
    }

    syncCartFields();
}

function syncCartFields() {
    const jsonInput =
        document.getElementById(
            'inputDanhSachMon'
        );

    const container =
        document.getElementById(
            'cartFields'
        );

    if (jsonInput) {
        jsonInput.value =
            JSON.stringify(cart);
    }

    if (!container) {
        return;
    }

    container.innerHTML = '';

    cart.forEach(item => {
        const maMon =
            document.createElement(
                'input'
            );

        maMon.type = 'hidden';
        maMon.name = 'itemMaMon';
        maMon.value = item.maMon;

        const qty =
            document.createElement(
                'input'
            );

        qty.type = 'hidden';
        qty.name = 'itemQty';
        qty.value = item.qty;

        container.append(
            maMon,
            qty
        );
    });
}

function prepareInvoiceSubmit(action) {
    if (cart.length === 0) {
        alert(
            'Vui lòng chọn ít nhất một món.'
        );

        return false;
    }

    const actionInput =
        document.getElementById(
            'formAction'
        );

    if (actionInput) {
        actionInput.value = action;
    }

    syncCartFields();

    return action !== 'pay'
        || confirm(
            'Xác nhận thanh toán? '
            + 'Kho sẽ tự động trừ '
            + 'nguyên liệu và cộng '
            + 'điểm khách hàng.'
        );
}

function setText(id, value) {
    const element =
        document.getElementById(id);

    if (element) {
        element.textContent = value;
    }
}

function escapeHtml(value) {
    return String(value)
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
}

document.addEventListener(
    'DOMContentLoaded',
    () => {
        document
            .querySelectorAll('.tab')
            .forEach(tab => {
                tab.addEventListener(
                    'click',
                    () => {
                        document
                            .querySelectorAll(
                                '.tab'
                            )
                            .forEach(item =>
                                item.classList
                                    .remove('active')
                            );

                        tab.classList.add(
                            'active'
                        );

                        const category =
                            tab.dataset.cat;

                        document
                            .querySelectorAll(
                                '.menu-item'
                            )
                            .forEach(item => {
                                item.style.display =
                                    category === 'all'
                                    || item.dataset
                                        .category
                                        === category
                                        ? 'flex'
                                        : 'none';
                            });
                    }
                );
            });

        const table =
            document.getElementById(
                'tableSel'
            );

        if (table) {
            table.addEventListener(
                'change',
                () => setText(
                    'metaTable',
                    table.value || '—'
                )
            );
        }

        const customerSelect =
            document.getElementById(
                'customerSel'
            );

        if (customerSelect) {
            customerSelect
                .addEventListener(
                    'change',
                    renderCart
                );
        }

        const oldCart =
            document.getElementById(
                'oldCartData'
            );

        initCartFromSavedData(
            oldCart
                ? oldCart.value
                : ''
        );

        const form =
            document.getElementById(
                'invoiceForm'
            );

        if (form) {
            form.addEventListener(
                'submit',
                syncCartFields
            );
        }
    }
);