// ================= KHỞI TẠO BIẾN =================
const fmt = n => n.toLocaleString('vi-VN') + 'đ';
let cart = []; // Lưu giỏ hàng: {maMon, name, price, qty}

let appliedPromoCode = "";
let appliedPercent = 0;
let appliedMinAmount = 0;

// ================= KHÔI PHỤC GIỎ HÀNG TỪ DỮ LIỆU ĐÃ LƯU (KHI SỬA HÓA ĐƠN CŨ) =================
// Gọi hàm này từ JSP, truyền vào chuỗi JSON lấy từ hoadon.danhSachMon (nếu có).
// Ví dụ trong JSP:
//   <input type="hidden" id="oldCartData" value='${hoadon.danhSachMon}'>
//   <script> initCartFromSavedData(document.getElementById('oldCartData').value); </script>
function initCartFromSavedData(rawJson) {
    if (!rawJson)
        return;
    try {
        const savedCart = JSON.parse(rawJson);
        if (Array.isArray(savedCart) && savedCart.length > 0) {
            cart = savedCart;
        }
    } catch (e) {
        console.error("Không parse được dữ liệu giỏ hàng cũ (danhSachMon):", e);
    }
    renderCart();
}

// ================= XỬ LÝ GIỎ HÀNG (RECEIPT) =================
function addToReceipt(maMon, name, price) {
    const existing = cart.find(i => i.maMon === maMon);
    if (existing) {
        existing.qty++;
    } else {
        cart.push({maMon, name, price, qty: 1});
    }
    renderCart();
}

function changeQty(idx, delta) {
    cart[idx].qty += delta;
    if (cart[idx].qty <= 0) {
        cart.splice(idx, 1);
    }
    renderCart();
}

function removeItem(idx) {
    cart.splice(idx, 1);
    renderCart();
}

function renderCart() {
    var box = document.getElementById('receiptItems');
    if (!box)
        return;

    if (cart.length === 0) {
        box.innerHTML = '<div class="empty-hint">Chưa có món nào được chọn</div>';
    } else {
        var html = "";
        cart.forEach(function (i, idx) {
            html += '<div class="r-item" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; font-size: 13px;">'
                    + '<div style="flex: 2;"><div class="rname" style="font-weight: 600;">' + i.name + '</div><span class="u" style="font-size: 11px; color: #666;">' + fmt(i.price) + '</span></div>'
                    + '<div class="r-qty" style="display: flex; align-items: center; gap: 5px; flex: 1; justify-content: center;">'
                    + '<button type="button" onclick="changeQty(' + idx + ',-1)" style="padding: 2px 6px;">\u2212</button>'
                    + '<span>' + i.qty + '</span>'
                    + '<button type="button" onclick="changeQty(' + idx + ',1)" style="padding: 2px 6px;">+</button>'
                    + '</div>'
                    + '<div class="r-sub" style="flex: 1; text-align: right; font-weight: 600;">' + fmt(i.price * i.qty) + '</div>'
                    + '<div class="r-rm" onclick="removeItem(' + idx + ')" style="cursor: pointer; color: red; margin-left: 8px;">\u2715</div>'
                    + '</div>';
        });
        box.innerHTML = html;
    }

    // 1. Tính Tạm tính (subtotal)
    var sub = cart.reduce(function (s, i) {
        return s + i.price * i.qty;
    }, 0);

    // 2. Kiểm tra điều kiện mã giảm giá theo đơn tối thiểu
    var disc = 0;
    var msgDiv = document.getElementById('promoMsg');

    if (appliedPromoCode !== "") {
        if (sub < appliedMinAmount) {
            disc = 0;
            if (msgDiv) {
                msgDiv.style.color = 'red';
                msgDiv.innerText = 'Đơn hàng chưa đạt mức tối thiểu (' + appliedMinAmount.toLocaleString('vi-VN') + 'đ) để dùng mã này!';
            }
        } else {
            disc = Math.round(sub * (appliedPercent / 100));
            if (msgDiv) {
                msgDiv.style.color = 'green';
                msgDiv.innerText = 'Đã áp dụng mã giảm ' + appliedPercent + '%';
            }
        }
    } else {
        if (msgDiv)
            msgDiv.innerText = '';
    }

    // 3. Tính toán chính xác tiền sau giảm, VAT và tổng cộng
    var sauGiam = sub - disc;
    var vat = Math.round(sauGiam * 0.08);
    var total = sauGiam + vat;

    // Hiển thị lên giao diện biên lai
    document.getElementById('subTotal').textContent = fmt(sub);
    document.getElementById('discLabel').textContent = appliedPercent > 0
            ? ("Giảm giá (" + appliedPercent + "%)")
            : "Giảm giá";
    document.getElementById('discAmt').textContent = '\u2212' + fmt(disc);
    document.getElementById('vatAmt').textContent = fmt(vat);
    document.getElementById('grandTotal').textContent = fmt(total);

    // Gán giá trị số thực vào ô input ẩn để truyền tổng tiền về Servlet khi bấm Lưu
    let inputTongTien = document.getElementById('inputTongTien');
    if (inputTongTien) {
        inputTongTien.value = total;
    }
}

// ================= XỬ LÝ MÃ GIẢM GIÁ TỪ DROPDOWN (SELECT) =================
function applySelectedPromo() {
    var select = document.getElementById('promoSelect');
    if (!select)
        return;

    var selectedOption = select.options[select.selectedIndex];

    if (!select.value) {
        appliedPromoCode = "";
        appliedPercent = 0;
        appliedMinAmount = 0;
    } else {
        appliedPromoCode = select.value;
        appliedPercent = parseFloat(selectedOption.getAttribute('data-percent')) || 0;
        appliedMinAmount = parseFloat(selectedOption.getAttribute('data-min')) || 0;
    }

    renderCart();
}

// ================= SỰ KIỆN TABS, BÀN & SUBMIT FORM =================
document.addEventListener("DOMContentLoaded", function () {
    // Lọc danh mục món ăn khi bấm các tab
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', () => {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            const selectedCat = tab.dataset.cat;

            document.querySelectorAll('.menu-item').forEach(item => {
                const itemCat = item.getAttribute('data-category');
                if (selectedCat === 'all' || itemCat === selectedCat) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    });

    // Cập nhật tên bàn lên hóa đơn khi chọn bàn
    const tableSel = document.getElementById('tableSel');
    const metaTable = document.getElementById('metaTable');
    if (tableSel && metaTable) {
        tableSel.addEventListener('change', e => {
            metaTable.textContent = e.target.value || '\u2014';
        });
    }

    // Bắt sự kiện dropdown mã giảm giá thay đổi
    const promoSelect = document.getElementById('promoSelect');
    if (promoSelect) {
        promoSelect.addEventListener('change', function () {
            applySelectedPromo();
        });
    }

    // Bắt sự kiện submit form để đóng gói chuỗi JSON giỏ hàng trước khi gửi về Servlet
    const formElement = document.querySelector("form.content");
    if (formElement) {
        formElement.addEventListener("submit", function (e) {
            const jsonString = JSON.stringify(cart);
            const inputDanhSachMon = document.getElementById("inputDanhSachMon");
            if (inputDanhSachMon) {
                inputDanhSachMon.value = jsonString;
            }
            console.log("JSON giỏ hàng gửi lên:", jsonString);
        });
    }

    // Khôi phục giỏ hàng cũ nếu đang sửa hóa đơn đã có sẵn (input ẩn #oldCartData do JSP render)
    const oldCartInput = document.getElementById('oldCartData');
    if (oldCartInput && oldCartInput.value) {
        initCartFromSavedData(oldCartInput.value);
    }

    // Tự động quét và áp dụng mã giảm giá đang được chọn sẵn trên giao diện (nếu có) khi load trang
    applySelectedPromo();
});