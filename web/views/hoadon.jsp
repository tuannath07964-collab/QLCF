<!DOCTYPE html>
<html lang="vi">
<head>
 <%@page contentType="text/html" pageEncoding="UTF-8"%>
<title>Hóa đơn — Quản lý quán Cafe</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&family=Inter:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
<style>
  :root{
    --navy:#1B2A3D;
    --navy-light:#233c56;
    --accent:#2F80ED;
    --coffee:#A9713F;
    --coffee-dark:#7A4F2B;
    --green:#27AE60;
    --red:#E5484D;
    --bg:#F3F5F8;
    --paper:#FFFDF8;
    --ink:#1F2733;
    --muted:#7A8494;
    --line:#E4E8EE;
    --radius:10px;
  }
  *{box-sizing:border-box;}
  body{margin:0;font-family:'Inter',sans-serif;background:var(--bg);color:var(--ink);}
  a{text-decoration:none;color:inherit;}

  /* ---------- Layout ---------- */
  .app{display:flex;min-height:100vh;}
  .sidebar{
    width:240px;background:var(--navy);color:#fff;
    display:flex;flex-direction:column;flex-shrink:0;
  }
  .brand{
    display:flex;align-items:center;gap:10px;padding:20px 18px;
    background:#101c29;font-family:'Playfair Display',serif;font-weight:700;
    font-size:15px;letter-spacing:.03em;text-transform:uppercase;
  }
  .brand svg{flex-shrink:0;}
  .nav{flex:1;padding:10px 0;}
  .nav a{
    display:flex;align-items:center;gap:12px;padding:12px 20px;
    font-size:14.5px;color:#c7d1de;transition:.15s;
  }
  .nav a:hover{background:rgba(255,255,255,.06);color:#fff;}
  .nav a.active{background:var(--accent);color:#fff;}
  .nav a svg{width:17px;height:17px;flex-shrink:0;}
  .logout{
    display:flex;align-items:center;gap:10px;justify-content:center;
    padding:16px;background:var(--red);font-weight:600;font-size:14.5px;
  }

  .main{flex:1;min-width:0;display:flex;flex-direction:column;}
  .topbar{
    display:flex;align-items:center;justify-content:space-between;
    padding:18px 32px;background:#fff;border-bottom:1px solid var(--line);
  }
  .topbar h1{
    font-family:'Playfair Display',serif;font-size:24px;margin:0;
    display:flex;align-items:center;gap:12px;
  }
  .topbar .sub{font-size:13px;color:var(--muted);font-weight:500;margin-top:2px;}
  .back{
    display:inline-flex;align-items:center;gap:6px;font-size:13.5px;color:var(--muted);
    margin-bottom:4px;
  }
  .user{display:flex;align-items:center;gap:8px;color:var(--ink);font-weight:600;font-size:14px;}

  .content{padding:26px 32px;display:flex;gap:24px;align-items:flex-start;flex:1;}

  /* ---------- Left: order info + menu picker ---------- */
  .left{flex:1;min-width:0;display:flex;flex-direction:column;gap:20px;}

  .info-card{
    background:#fff;border-radius:var(--radius);padding:18px 20px;
    border:1px solid var(--line);display:flex;gap:28px;flex-wrap:wrap;
  }
  .info-field{display:flex;flex-direction:column;gap:5px;min-width:130px;}
  .info-field label{font-size:11.5px;text-transform:uppercase;letter-spacing:.05em;color:var(--muted);font-weight:700;}
  .info-field select, .info-field input{
    border:1px solid var(--line);border-radius:7px;padding:8px 10px;font-size:14px;
    font-family:'Inter',sans-serif;color:var(--ink);background:#fbfcfd;
  }
  .status-pill{
    align-self:flex-start;margin-top:auto;display:inline-flex;align-items:center;gap:6px;
    background:#FFF4E8;color:var(--coffee-dark);font-weight:700;font-size:12.5px;
    padding:6px 12px;border-radius:999px;
  }
  .status-pill .dot{width:7px;height:7px;border-radius:50%;background:var(--coffee-dark);}

  .menu-header{display:flex;align-items:center;justify-content:space-between;}
  .menu-header h2{font-family:'Playfair Display',serif;font-size:18px;margin:0;}
  .tabs{display:flex;gap:6px;}
  .tab{
    padding:6px 14px;border-radius:999px;font-size:13px;font-weight:600;color:var(--muted);
    background:#fff;border:1px solid var(--line);cursor:pointer;
  }
  .tab.active{background:var(--navy);color:#fff;border-color:var(--navy);}

  .menu-grid{
    display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:14px;
  }
  .menu-item{
    background:#fff;border:1px solid var(--line);border-radius:var(--radius);
    padding:14px;cursor:pointer;transition:.15s;position:relative;overflow:hidden;
  }
  .menu-item:hover{border-color:var(--coffee);box-shadow:0 4px 14px rgba(169,113,63,.15);transform:translateY(-2px);}
  .menu-item .icon{
    width:38px;height:38px;border-radius:9px;background:#FFF4E8;color:var(--coffee-dark);
    display:flex;align-items:center;justify-content:center;margin-bottom:10px;font-size:18px;
  }
  .menu-item .name{font-weight:700;font-size:14px;margin-bottom:4px;}
  .menu-item .price{font-size:13px;color:var(--muted);font-weight:600;}
  .menu-item .add-badge{
    position:absolute;top:10px;right:10px;width:24px;height:24px;border-radius:50%;
    background:var(--green);color:#fff;display:flex;align-items:center;justify-content:center;
    font-size:15px;font-weight:700;opacity:0;transform:scale(.7);transition:.15s;
  }
  .menu-item:hover .add-badge{opacity:1;transform:scale(1);}

  /* ---------- Right: receipt ---------- */
  .right{width:380px;flex-shrink:0;}
  .receipt{
    background:var(--paper);border-radius:2px;
    box-shadow:0 10px 30px rgba(27,42,61,.12);
    position:relative;padding:26px 24px 20px;
    font-family:'Courier Prime',monospace;
  }
  .receipt::before, .receipt::after{
    content:"";position:absolute;left:0;right:0;height:10px;
    background-image:linear-gradient(135deg,var(--bg) 50%,transparent 50%),linear-gradient(45deg,var(--bg) 50%,transparent 50%);
    background-size:14px 14px;background-repeat:repeat-x;
  }
  .receipt::before{top:-1px;background-position:0 0;}
  .receipt::after{bottom:-1px;transform:rotate(180deg);}

  .receipt-head{text-align:center;border-bottom:1px dashed #c9c2b4;padding-bottom:14px;margin-bottom:14px;}
  .receipt-head .cup{font-size:22px;margin-bottom:4px;}
  .receipt-head .shop{font-family:'Playfair Display',serif;font-weight:800;font-size:17px;letter-spacing:.04em;color:var(--coffee-dark);}
  .receipt-head .addr{font-size:11px;color:var(--muted);margin-top:3px;}
  .receipt-meta{display:flex;justify-content:space-between;font-size:11.5px;color:var(--muted);margin-bottom:12px;}
  .receipt-meta b{color:var(--ink);}

  .receipt-items{border-bottom:1px dashed #c9c2b4;padding-bottom:10px;margin-bottom:10px;}
  .r-item{display:flex;align-items:center;gap:8px;padding:7px 0;font-size:12.5px;}
  .r-item .rname{flex:1;line-height:1.35;}
  .r-item .rname .u{display:block;color:var(--muted);font-size:11px;}
  .r-qty{display:flex;align-items:center;gap:5px;}
  .r-qty button{
    width:18px;height:18px;border:1px solid var(--line);background:#fff;border-radius:4px;
    font-size:11px;line-height:1;cursor:pointer;color:var(--ink);
  }
  .r-qty span{min-width:14px;text-align:center;font-weight:700;}
  .r-sub{width:64px;text-align:right;font-weight:700;}
  .r-rm{color:var(--red);cursor:pointer;font-size:14px;padding-left:2px;}
  .empty-hint{text-align:center;color:var(--muted);font-size:12px;padding:20px 0;}

  .promo-box{display:flex;gap:6px;margin-bottom:6px;}
  .promo-box input{
    flex:1;border:1px dashed #c9c2b4;border-radius:6px;padding:8px 10px;font-size:12.5px;
    font-family:'Courier Prime',monospace;text-transform:uppercase;background:#fff;color:var(--ink);
    letter-spacing:.03em;
  }
  .promo-box input:focus{outline:none;border-color:var(--coffee);}
  .promo-box button{
    border:none;border-radius:6px;padding:0 14px;background:var(--navy);color:#fff;
    font-family:'Inter',sans-serif;font-weight:700;font-size:12px;cursor:pointer;
  }
  .promo-box button:hover{background:var(--coffee-dark);}
  .promo-msg{font-size:11.5px;min-height:15px;margin-bottom:10px;font-weight:600;}
  .promo-msg.ok{color:var(--green);}
  .promo-msg.err{color:var(--red);}

  .receipt-totals{font-size:12.5px;display:flex;flex-direction:column;gap:6px;margin-bottom:14px;}
  .rt-row{display:flex;justify-content:space-between;color:var(--muted);}
  .rt-row.grand{
    color:var(--ink);font-weight:700;font-size:15.5px;border-top:1px dashed #c9c2b4;
    padding-top:10px;margin-top:2px;
  }
  .rt-row.grand .amt{color:var(--coffee-dark);}

  .pay-methods{display:flex;gap:8px;margin-bottom:14px;}
  .pay-methods label{
    flex:1;text-align:center;border:1px solid var(--line);border-radius:7px;padding:8px 4px;
    font-size:11.5px;font-weight:700;color:var(--muted);cursor:pointer;font-family:'Inter',sans-serif;
  }
  .pay-methods input{display:none;}
  .pay-methods input:checked + span{color:var(--coffee-dark);}
  .pay-methods label:has(input:checked){border-color:var(--coffee);background:#FFF7EE;}

  .receipt-actions{display:flex;gap:8px;}
  .btn{
    flex:1;padding:11px;border-radius:8px;border:none;font-weight:700;font-size:13.5px;
    cursor:pointer;font-family:'Inter',sans-serif;display:flex;align-items:center;justify-content:center;gap:6px;
  }
  .btn-outline{background:#fff;border:1px solid var(--navy);color:var(--navy);}
  .btn-primary{background:var(--green);color:#fff;}
  .btn-primary:hover{background:#219653;}
  .btn-outline:hover{background:var(--navy);color:#fff;}

  .barcode{margin-top:16px;text-align:center;color:var(--muted);font-size:10px;letter-spacing:.08em;}
  .barcode .bars{font-size:26px;letter-spacing:1px;line-height:.6;color:#333;margin-bottom:2px;}

  @media(max-width:980px){
    .content{flex-direction:column;}
    .right{width:100%;}
  }
  @media print{
    .sidebar,.topbar,.left,.receipt::before,.receipt::after,.receipt-actions,.pay-methods{display:none !important;}
    .content{padding:0;}
    .receipt{box-shadow:none;width:320px;margin:0 auto;}
  }
</style>
</head>
<body>
<div class="app">

  <aside class="sidebar">
    <div class="brand">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8h1a4 4 0 0 1 0 8h-1"/><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"/><line x1="6" y1="1" x2="6" y2="4"/><line x1="10" y1="1" x2="10" y2="4"/><line x1="14" y1="1" x2="14" y2="4"/></svg>
      Quản lý quán Cafe
    </div>
    <nav class="nav">
      <a href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>Trang chủ</a>
      <a href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21v-1a8 8 0 0 1 16 0v1"/></svg>Nhân viên</a>
      <a href="#" class="active"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 3h16v18l-4-2-4 2-4-2-4 2z"/></svg>Hóa đơn</a>
      <a href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M3 12h18M3 18h18"/></svg>Menu</a>
      <a href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 10h18"/></svg>Bàn</a>
      <a href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 7l-8-4-8 4v10l8 4 8-4z"/></svg>Kho</a>
      <a href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="8" r="3"/><path d="M2 21v-1a6 6 0 0 1 12 0v1"/><path d="M17 11a3 3 0 1 0 0-6"/><path d="M22 21v-1a5 5 0 0 0-4-4.9"/></svg>Khách hàng</a>
      <a href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="4" y1="20" x2="4" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="20" y1="20" x2="20" y2="14"/></svg>Thống kê</a>
    </nav>
    <a href="#" class="logout"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>Đăng xuất</a>
  </aside>

  <div class="main">
    <div class="topbar">
      <div>
        <div class="back">← Quay lại danh sách hóa đơn</div>
        <h1>Hóa đơn <span id="invoiceCode" style="color:var(--coffee-dark)">#HD00128</span></h1>
      </div>
      <div class="user">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21v-1a8 8 0 0 1 16 0v1"/></svg>
        Thu Ngân
      </div>
    </div>

    <div class="content">

      <!-- LEFT -->
      <div class="left">
        <div class="info-card">
          <div class="info-field">
            <label>Mã bàn</label>
            <select id="tableSel">
              <option>Bàn 01</option><option>Bàn 02</option><option selected>Bàn 05</option>
              <option>Bàn 07</option><option>Mang về</option>
            </select>
          </div>
          <div class="info-field">
            <label>Khách hàng</label>
            <input type="text" placeholder="Khách lẻ" value="Nguyễn Văn A">
          </div>
          <div class="info-field">
            <label>Nhân viên</label>
            <input type="text" value="Thu Ngân" disabled>
          </div>
          <div class="info-field">
            <label>Ngày tạo</label>
            <input type="text" value="21/07/2026 — 14:32" disabled>
          </div>
          <span class="status-pill"><span class="dot"></span>Đang phục vụ</span>
        </div>

        <div class="menu-header">
          <h2>Chọn món</h2>
          <div class="tabs">
            <div class="tab active" data-cat="all">Tất cả</div>
            <div class="tab" data-cat="coffee">Cà phê</div>
            <div class="tab" data-cat="tea">Trà</div>
            <div class="tab" data-cat="food">Bánh</div>
          </div>
        </div>

        <div class="menu-grid" id="menuGrid"></div>
      </div>

      <!-- RIGHT: RECEIPT -->
      <div class="right">
        <div class="receipt">
          <div class="receipt-head">
            <div class="cup">☕</div>
            <div class="shop">QUÁN CAFE MINH MÚP</div>
            <div class="addr"><br>ĐT: 0866158915</div>
          </div>
          <div class="receipt-meta">
            <span>Số HĐ: <b id="metaCode">HD00128</b></span>
            <span>Bàn: <b id="metaTable">05</b></span>
          </div>

          <div class="receipt-items" id="receiptItems">
            <div class="empty-hint">Chưa có món nào được chọn</div>
          </div>

          <div class="promo-box">
            <input type="text" id="promoInput" placeholder="Nhập mã giảm giá" autocomplete="off">
            <button type="button" onclick="applyPromo()">Áp dụng</button>
          </div>
          <div class="promo-msg" id="promoMsg"></div>

          <div class="receipt-totals">
            <div class="rt-row"><span>Tạm tính</span><span id="subTotal">0đ</span></div>
            <div class="rt-row"><span id="discLabel">Giảm giá</span><span id="discAmt">−0đ</span></div>
            <div class="rt-row"><span>VAT (8%)</span><span id="vatAmt">0đ</span></div>
            <div class="rt-row grand"><span>Tổng cộng</span><span class="amt" id="grandTotal">0đ</span></div>
          </div>

          <div class="pay-methods">
            <label><input type="radio" name="pay" checked><span>💵 Tiền mặt</span></label>
          </div>

          <div class="receipt-actions">
            <button class="btn btn-outline" onclick="window.print()">🖨 In hóa đơn</button>
            <button class="btn btn-primary">✓ Thanh toán</button>
          </div>

          <div class="barcode">
            <div class="bars">▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌</div>
            HD00128 — CẢM ƠN QUÝ KHÁCH!
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
const MENU = [
  {name:"Cà phê đen đá", price:22000, cat:"coffee", icon:"☕"},
  {name:"Cà phê sữa đá", price:25000, cat:"coffee", icon:"☕"},
  {name:"Bạc xỉu", price:28000, cat:"coffee", icon:"🥛"},
  {name:"Cappuccino", price:38000, cat:"coffee", icon:"☕"},
  {name:"Latte", price:39000, cat:"coffee", icon:"☕"},
  {name:"Espresso", price:32000, cat:"coffee", icon:"☕"},
  {name:"Trà đào cam sả", price:35000, cat:"tea", icon:"🍑"},
  {name:"Trà sữa trân châu", price:32000, cat:"tea", icon:"🧋"},
  {name:"Trà vải", price:30000, cat:"tea", icon:"🍵"},
  {name:"Nước cam ép", price:35000, cat:"tea", icon:"🍊"},
  {name:"Bánh croissant", price:28000, cat:"food", icon:"🥐"},
  {name:"Bánh tiramisu", price:42000, cat:"food", icon:"🍰"},
  {name:"Bánh mì que pate", price:20000, cat:"food", icon:"🥖"},
  {name:"Cookie bơ", price:18000, cat:"food", icon:"🍪"},
];

const fmt = n => n.toLocaleString('vi-VN') + 'đ';
let cart = []; // {name, price, qty}

// Mã giảm giá hợp lệ: mã -> % giảm
const PROMO_CODES = {
  "WELCOME10": 10,
  "SALE5": 5,
  "VIP15": 15,
  "CAFE20": 20
};
let appliedPromo = null;   // ví dụ "SALE5"
let appliedPercent = 0;    // % giảm đang áp dụng

function applyPromo(){
  var input = document.getElementById('promoInput');
  var msg = document.getElementById('promoMsg');
  var code = input.value.trim().toUpperCase();

  if(!code){
    msg.textContent = "Vui lòng nhập mã giảm giá.";
    msg.className = "promo-msg err";
    return;
  }
  if(PROMO_CODES.hasOwnProperty(code)){
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

function renderMenu(cat){
  cat = cat || "all";
  var grid = document.getElementById('menuGrid');
  var html = "";
  MENU.filter(function(m){ return cat==="all"||m.cat===cat; }).forEach(function(m){
    html += '<div class="menu-item" onclick="addToCart(\'' + m.name.replace(/'/g,"\\'") + '\',' + m.price + ')">'
      + '<div class="icon">' + m.icon + '</div>'
      + '<div class="name">' + m.name + '</div>'
      + '<div class="price">' + fmt(m.price) + '</div>'
      + '<div class="add-badge">+</div>'
      + '</div>';
  });
  grid.innerHTML = html;
}

function addToCart(name, price){
  const existing = cart.find(i=>i.name===name);
  if(existing) existing.qty++;
  else cart.push({name, price, qty:1});
  renderCart();
}
function changeQty(idx, delta){
  cart[idx].qty += delta;
  if(cart[idx].qty <= 0) cart.splice(idx,1);
  renderCart();
}
function removeItem(idx){
  cart.splice(idx,1);
  renderCart();
}

function renderCart(){
  var box = document.getElementById('receiptItems');
  if(cart.length===0){
    box.innerHTML = '<div class="empty-hint">Chưa có món nào được chọn</div>';
  } else {
    var html = "";
    cart.forEach(function(i, idx){
      html += '<div class="r-item">'
        + '<div class="rname">' + i.name + '<span class="u">' + fmt(i.price) + ' / phần</span></div>'
        + '<div class="r-qty">'
        +   '<button onclick="changeQty(' + idx + ',-1)">\u2212</button>'
        +   '<span>' + i.qty + '</span>'
        +   '<button onclick="changeQty(' + idx + ',1)">+</button>'
        + '</div>'
        + '<div class="r-sub">' + fmt(i.price*i.qty) + '</div>'
        + '<div class="r-rm" onclick="removeItem(' + idx + ')">\u2715</div>'
        + '</div>';
    });
    box.innerHTML = html;
  }

  var sub = cart.reduce(function(s,i){ return s+i.price*i.qty; }, 0);
  var disc = Math.round(sub*(appliedPercent/100));
  var vat = Math.round((sub-disc)*0.08);
  var total = sub - disc + vat;

  document.getElementById('subTotal').textContent = fmt(sub);
  document.getElementById('discLabel').textContent = appliedPercent > 0
    ? ("Giảm giá (" + appliedPercent + "%)")
    : "Giảm giá";
  document.getElementById('discAmt').textContent = '\u2212'+fmt(disc);
  document.getElementById('vatAmt').textContent = fmt(vat);
  document.getElementById('grandTotal').textContent = fmt(total);
}

document.querySelectorAll('.tab').forEach(tab=>{
  tab.addEventListener('click', ()=>{
    document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
    tab.classList.add('active');
    renderMenu(tab.dataset.cat);
  });
});

document.getElementById('tableSel').addEventListener('change', e=>{
  document.getElementById('metaTable').textContent = e.target.value.replace('Bàn ','') || '—';
});

renderMenu();
renderCart();
</script>
</body>
</html>
