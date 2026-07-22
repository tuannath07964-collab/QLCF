// ================= KHỞI TẠO BIẾN =================
const fmt = n => n.toLocaleString('vi-VN') + 'đ';
let cart = []; // Lưu giỏ hàng: {maMon, name, price, qty}

// Mã giảm giá hợp lệ: mã -> % giảm
const PROMO_CODES = {
    "WELCOME10": 10,
    "SALE5": 5,
    "VIP15": 15,
    "CAFE20": 20
};
let appliedPromo = null;   
let appliedPercent = 0;    

// ================= XỬ LÝ GIỎ HÀNG (RECEIPT) =================
function addToReceipt(maMon, name, price) {
    const existing = cart.find(i => i.maMon === maMon);
    if (existing) {
        existing.qty++;
    } else {
        cart.push({ maMon, name, price, qty: 1 });
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
    if (!box) return;

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

    var sub = cart.reduce(function (s, i) {
        return s + i.price * i.qty;
    }, 0);
    var disc = Math.round(sub * (appliedPercent / 100));
    var vat = Math.round((sub - disc) * 0.08);
    var total = sub - disc + vat;

    document.getElementById('subTotal').textContent = fmt(sub);
    document.getElementById('discLabel').textContent = appliedPercent > 0
            ? ("Giảm giá (" + appliedPercent + "%)")
            : "Giảm giá";
    document.getElementById('discAmt').textContent = '\u2212' + fmt(disc);
    document.getElementById('vatAmt').textContent = fmt(vat);
    document.getElementById('grandTotal').textContent = fmt(total);
}

// ================= MÃ GIẢM GIÁ =================
function applyPromo() {
    var input = document.getElementById('promoInput');
    var msg = document.getElementById('promoMsg');
    if (!input || !msg) return;
    
    var code = input.value.trim().toUpperCase();

    if (!code) {
        msg.textContent = "Vui lòng nhập mã giảm giá.";
        msg.className = "promo-msg err";
        return;
    }
    if (PROMO_CODES.hasOwnProperty(code)) {
        appliedPromo = code;
        appliedPercent = PROMO_CODES[code];
        msg.textContent = "Áp dụng mã \"" + code + "\" thành công — giảm " + appliedPercent + "%.";
        msg.className = "promo-msg ok";
    } else {
        appliedPromo = null;
        appliedPercent = 0;
        msg.textContent = "Mã giảm giá không hợp lệ hoặc đã hết hạn.";
        msg.className = "promo-msg err";
    }
    renderCart();
}

// ================= SỰ KIỆN TABS & BÀN =================
document.addEventListener("DOMContentLoaded", function () {
    // Lọc danh mục món ăn khi bấm các tab
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', () => {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            const selectedCat = tab.dataset.cat; // all, coffee, tea, juice, snack...
            
            document.querySelectorAll('.menu-item').forEach(item => {
                const itemCat = item.getAttribute('data-category');
                if (selectedCat === 'all' || itemCat === selectedCat) {
                    item.style.display = 'flex'; // Hiện món khớp danh mục
                } else {
                    item.style.display = 'none'; // Ẩn món không khớp
                }
            });
        });
    });

    // Cập nhật tên bàn lên hóa đơn khi chọn bàn
    const tableSel = document.getElementById('tableSel');
    const metaTable = document.getElementById('metaTable');
    if (tableSel && metaTable) {
        tableSel.addEventListener('change', e => {
            metaTable.textContent = e.target.value || '—';
        });
    }

    // Khởi chạy render giỏ hàng rỗng ban đầu
    renderCart();
});

// Ví dụ đoạn code tính tổng trong file hoadon.js của bạn:
function updateTotals() {
    let subTotal = 0;
    // ... logic tính tổng tiền các món ăn trong giỏ hàng ...

    let vat = subTotal * 0.08;
    let grandTotal = subTotal + vat; // Giả sử 48600

    // Cập nhật hiển thị lên giao diện biên lai
    document.getElementById('subTotal').innerText = subTotal.toLocaleString() + 'đ';
    document.getElementById('vatAmt').innerText = vat.toLocaleString() + 'đ';
    document.getElementById('grandTotal').innerText = grandTotal.toLocaleString() + 'đ';

    // *** QUAN TRỌNG: Gán giá trị số thực vào ô input ẩn để truyền về Servlet khi bấm Lưu ***
    let inputTongTien = document.getElementById('inputTongTien');
    if (inputTongTien) {
        inputTongTien.value = grandTotal; 
    }
}