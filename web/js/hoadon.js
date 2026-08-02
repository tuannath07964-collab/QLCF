document.addEventListener(
        "DOMContentLoaded",
        function () {
            const invoiceForm =
                    document.getElementById(
                            "invoiceForm"
                    );

            const productSearch =
                    document.getElementById(
                            "productPickerSearch"
                    );

            const cartTableBody =
                    document.getElementById(
                            "cartTableBody"
                    );

            const emptyCart =
                    document.getElementById(
                            "emptyCart"
                    );

            const customerModeRadios =
                    document.querySelectorAll(
                            'input[name="customerMode"]'
                    );

            const savedCustomerSection =
                    document.getElementById(
                            "savedCustomerSection"
                    );

            const guestCustomerSection =
                    document.getElementById(
                            "guestCustomerSection"
                    );

            const customerSelect =
                    document.getElementById(
                            "customerSelect"
                    );

            const newCustomerName =
                    document.getElementById(
                            "newCustomerName"
                    );

            const newCustomerPhone =
                    document.getElementById(
                            "newCustomerPhone"
                    );

            const saveCustomerCheckbox =
                    document.getElementById(
                            "saveCustomerCheckbox"
                    );

            const voucherSection =
                    document.getElementById(
                            "voucherSection"
                    );

            const voucherSelect =
                    document.getElementById(
                            "voucherSelect"
                    );

            const voucherHelpText =
                    document.getElementById(
                            "voucherHelpText"
                    );

            const voucherPreview =
                    document.getElementById(
                            "selectedVoucherPreview"
                    );

            const voucherCodeElement =
                    document.getElementById(
                            "selectedVoucherCode"
                    );

            const usedVoucherValue =
                    document.getElementById(
                            "usedVoucherValue"
                    );

            const subTotalValue =
                    document.getElementById(
                            "subTotalValue"
                    );

            const vatValue =
                    document.getElementById(
                            "vatValue"
                    );

            const voucherDiscountValue =
                    document.getElementById(
                            "voucherDiscountValue"
                    );

            const grandTotalValue =
                    document.getElementById(
                            "grandTotalValue"
                    );

            const cancelInvoiceButton =
                    document.getElementById(
                            "cancelInvoiceButton"
                    );

            const cancelInvoiceForm =
                    document.getElementById(
                            "cancelInvoiceForm"
                    );

            const cancelReasonInput =
                    document.getElementById(
                            "cancelReasonInput"
                    );

            const voucherOptions =
                    voucherSelect
                    ? Array.from(
                            voucherSelect.querySelectorAll(
                                    "option[data-customer]"
                            )
                    )
                    : [];

            function formatMoney(value) {
                const number =
                        Number(value) || 0;

                return number
                        .toLocaleString(
                                "vi-VN"
                        )
                        + "đ";
            }

            function normalizeText(value) {
                return String(value || "")
                        .toLowerCase()
                        .normalize("NFD")
                        .replace(
                                /[\u0300-\u036f]/g,
                                ""
                        );
            }

            function getCustomerMode() {
                const selectedMode =
                        document.querySelector(
                                'input[name="customerMode"]:checked'
                        );

                return selectedMode
                        ? selectedMode.value
                        : "guest";
            }

            function getCartRows() {
                if (!cartTableBody) {
                    return [];
                }

                return Array.from(
                        cartTableBody.querySelectorAll(
                                ".cart-row"
                        )
                );
            }

            function findCartRow(
                    productCode
            ) {
                return getCartRows().find(
                        function (row) {
                            return row.dataset.code
                                    === productCode;
                        }
                );
            }

            function updateEmptyCart() {
                if (!emptyCart) {
                    return;
                }

                emptyCart.classList.toggle(
                        "hidden",
                        getCartRows().length > 0
                );
            }

            function getVoucherValue() {
                if (
                    voucherSelect
                    && !voucherSelect.disabled
                ) {
                    const option =
                            voucherSelect.options[
                                    voucherSelect.selectedIndex
                            ];

                    if (option) {
                        return Number(
                                option.dataset.value
                        ) || 0;
                    }
                }

                if (usedVoucherValue) {
                    return Number(
                            usedVoucherValue.value
                    ) || 0;
                }

                return 0;
            }

            function updateVoucherPreview() {
                if (
                    !voucherSelect
                    || !voucherPreview
                    || !voucherCodeElement
                ) {
                    return;
                }

                const option =
                        voucherSelect.options[
                                voucherSelect.selectedIndex
                        ];

                const voucherCode =
                        option
                        ? option.dataset.code || ""
                        : "";

                if (
                    voucherCode
                    && !voucherSelect.disabled
                ) {
                    voucherCodeElement.textContent =
                            voucherCode;

                    voucherPreview.classList.remove(
                            "hidden"
                    );

                } else {
                    voucherCodeElement.textContent =
                            "—";

                    voucherPreview.classList.add(
                            "hidden"
                    );
                }
            }

            function calculateSubTotal() {
                let subTotal = 0;

                getCartRows().forEach(
                        function (row) {
                            const price =
                                    Number(
                                            row.dataset.price
                                    ) || 0;

                            const quantityInput =
                                    row.querySelector(
                                            ".cart-quantity"
                                    );

                            let quantity =
                                    quantityInput
                                    ? Number(
                                            quantityInput.value
                                    ) || 1
                                    : 1;

                            if (quantity < 1) {
                                quantity = 1;

                                if (quantityInput) {
                                    quantityInput.value =
                                            "1";
                                }
                            }

                            const lineTotal =
                                    price * quantity;

                            subTotal += lineTotal;

                            const lineTotalElement =
                                    row.querySelector(
                                            ".cart-line-total"
                                    );

                            if (lineTotalElement) {
                                lineTotalElement.textContent =
                                        formatMoney(
                                                lineTotal
                                        );
                            }
                        }
                );

                return subTotal;
            }

            function updateInvoiceTotal() {
                const subTotal =
                        calculateSubTotal();

                const vat =
                        Math.round(
                                subTotal * 0.08
                        );

                const totalBeforeDiscount =
                        subTotal + vat;

                const voucherValue =
                        getVoucherValue();

                const grandTotal =
                        Math.max(
                                0,
                                totalBeforeDiscount
                                - voucherValue
                        );

                if (subTotalValue) {
                    subTotalValue.textContent =
                            formatMoney(
                                    subTotal
                            );
                }

                if (vatValue) {
                    vatValue.textContent =
                            formatMoney(
                                    vat
                            );
                }

                if (voucherDiscountValue) {
                    voucherDiscountValue.textContent =
                            "-"
                            + formatMoney(
                                    voucherValue
                            );

                    voucherDiscountValue
                            .classList
                            .toggle(
                                    "text-danger",
                                    voucherValue
                                    > totalBeforeDiscount
                            );
                }

                if (grandTotalValue) {
                    grandTotalValue.textContent =
                            formatMoney(
                                    grandTotal
                            );
                }

                updateVoucherPreview();
                updateEmptyCart();
            }

            function filterVouchers(
                    resetSelectedVoucher
            ) {
                if (!voucherSelect) {
                    updateInvoiceTotal();
                    return;
                }

                const useSavedCustomer =
                        getCustomerMode()
                        === "saved";

                const customerCode =
                        useSavedCustomer
                        && customerSelect
                        ? customerSelect.value
                        : "";

                let voucherCount = 0;

                voucherOptions.forEach(
                        function (option) {
                            const belongsToCustomer =
                                    customerCode !== ""
                                    && option.dataset.customer
                                    === customerCode;

                            option.hidden =
                                    !belongsToCustomer;

                            option.disabled =
                                    !belongsToCustomer;

                            if (belongsToCustomer) {
                                voucherCount++;
                            }
                        }
                );

                const selectedOption =
                        voucherSelect.options[
                                voucherSelect.selectedIndex
                        ];

                const selectedBelongsToCustomer =
                        selectedOption
                        && selectedOption.dataset.customer
                        && selectedOption.dataset.customer
                        === customerCode;

                if (
                    resetSelectedVoucher
                    || customerCode === ""
                    || (
                        selectedOption
                        && selectedOption.dataset.customer
                        && !selectedBelongsToCustomer
                    )
                ) {
                    voucherSelect.value = "";
                }

                voucherSelect.disabled =
                        !useSavedCustomer
                        || customerCode === "";

                if (voucherHelpText) {
                    if (!useSavedCustomer) {
                        voucherHelpText.textContent =
                                "Khách lẻ không thể sử dụng voucher.";

                    } else if (customerCode === "") {
                        voucherHelpText.textContent =
                                "Vui lòng chọn khách hàng đã lưu.";

                    } else if (voucherCount === 0) {
                        voucherHelpText.textContent =
                                "Khách hàng này không có voucher còn hiệu lực.";

                    } else {
                        voucherHelpText.textContent =
                                "Khách hàng có "
                                + voucherCount
                                + " voucher còn hiệu lực.";
                    }
                }

                updateInvoiceTotal();
            }

            function syncCustomerMode(
                    resetVoucher
            ) {
                const useSavedCustomer =
                        getCustomerMode()
                        === "saved";

                if (savedCustomerSection) {
                    savedCustomerSection
                            .classList
                            .toggle(
                                    "hidden",
                                    !useSavedCustomer
                            );
                }

                if (guestCustomerSection) {
                    guestCustomerSection
                            .classList
                            .toggle(
                                    "hidden",
                                    useSavedCustomer
                            );
                }

                if (customerSelect) {
                    customerSelect.disabled =
                            !useSavedCustomer;
                }

                if (newCustomerName) {
                    newCustomerName.disabled =
                            useSavedCustomer;
                }

                if (newCustomerPhone) {
                    newCustomerPhone.disabled =
                            useSavedCustomer;
                }

                if (saveCustomerCheckbox) {
                    saveCustomerCheckbox.disabled =
                            useSavedCustomer;
                }

                if (voucherSection) {
                    voucherSection
                            .classList
                            .toggle(
                                    "hidden",
                                    !useSavedCustomer
                            );
                }

                if (
                    !useSavedCustomer
                    && voucherSelect
                ) {
                    voucherSelect.value = "";
                    voucherSelect.disabled = true;
                }

                filterVouchers(
                        resetVoucher
                );
            }

            function createProductCell(
                    productCode,
                    productName,
                    productPrice
            ) {
                const cell =
                        document.createElement(
                                "td"
                        );

                const name =
                        document.createElement(
                                "strong"
                        );

                name.textContent =
                        productName;

                const price =
                        document.createElement(
                                "small"
                        );

                price.textContent =
                        formatMoney(
                                productPrice
                        );

                const hiddenInput =
                        document.createElement(
                                "input"
                        );

                hiddenInput.type =
                        "hidden";

                hiddenInput.name =
                        "maSanPham";

                hiddenInput.value =
                        productCode;

                cell.appendChild(name);
                cell.appendChild(price);
                cell.appendChild(hiddenInput);

                return cell;
            }

            function createQuantityCell() {
                const cell =
                        document.createElement(
                                "td"
                        );

                const input =
                        document.createElement(
                                "input"
                        );

                input.className =
                        "cart-quantity";

                input.type =
                        "number";

                input.name =
                        "soLuong";

                input.value =
                        "1";

                input.min =
                        "1";

                input.step =
                        "1";

                cell.appendChild(input);

                return cell;
            }

            function createLineTotalCell(
                    productPrice
            ) {
                const cell =
                        document.createElement(
                                "td"
                        );

                cell.className =
                        "cart-line-total";

                cell.textContent =
                        formatMoney(
                                productPrice
                        );

                return cell;
            }

            function createRemoveCell() {
                const cell =
                        document.createElement(
                                "td"
                        );

                const button =
                        document.createElement(
                                "button"
                        );

                button.className =
                        "cart-remove";

                button.type =
                        "button";

                button.title =
                        "Xóa sản phẩm";

                const icon =
                        document.createElement(
                                "i"
                        );

                icon.className =
                        "fa-solid fa-xmark";

                button.appendChild(icon);
                cell.appendChild(button);

                return cell;
            }

            function addProductToCart(
                    productButton
            ) {
                if (
                    !productButton
                    || productButton.disabled
                    || productButton.classList
                            .contains(
                                    "disabled"
                            )
                ) {
                    return;
                }

                if (!cartTableBody) {
                    return;
                }

                const productCode =
                        productButton.dataset.code;

                const productName =
                        productButton.dataset.name;

                const productPrice =
                        Number(
                                productButton.dataset.price
                        ) || 0;

                if (
                    !productCode
                    || !productName
                    || productPrice <= 0
                ) {
                    alert(
                            "Thông tin sản phẩm không hợp lệ."
                    );

                    return;
                }

                const existingRow =
                        findCartRow(
                                productCode
                        );

                if (existingRow) {
                    const quantityInput =
                            existingRow.querySelector(
                                    ".cart-quantity"
                            );

                    if (quantityInput) {
                        const currentQuantity =
                                Number(
                                        quantityInput.value
                                ) || 1;

                        quantityInput.value =
                                String(
                                        currentQuantity + 1
                                );
                    }

                    updateInvoiceTotal();
                    return;
                }

                const row =
                        document.createElement(
                                "tr"
                        );

                row.className =
                        "cart-row";

                row.dataset.code =
                        productCode;

                row.dataset.name =
                        productName;

                row.dataset.price =
                        String(
                                productPrice
                        );

                row.appendChild(
                        createProductCell(
                                productCode,
                                productName,
                                productPrice
                        )
                );

                row.appendChild(
                        createQuantityCell()
                );

                row.appendChild(
                        createLineTotalCell(
                                productPrice
                        )
                );

                row.appendChild(
                        createRemoveCell()
                );

                cartTableBody.appendChild(
                        row
                );

                updateInvoiceTotal();
            }

            function filterProducts() {
                if (!productSearch) {
                    return;
                }

                const keyword =
                        normalizeText(
                                productSearch.value
                        );

                document.querySelectorAll(
                        ".product-pick"
                ).forEach(
                        function (button) {
                            const searchText =
                                    normalizeText(
                                            button.dataset.search
                                    );

                            button.style.display =
                                    searchText.includes(
                                            keyword
                                    )
                                    ? ""
                                    : "none";
                        }
                );
            }

            function validateCustomer() {
                const mode =
                        getCustomerMode();

                if (mode === "saved") {
                    if (
                        !customerSelect
                        || customerSelect.value === ""
                    ) {
                        alert(
                                "Vui lòng chọn khách hàng đã lưu."
                        );

                        return false;
                    }

                    return true;
                }

                const guestName =
                        newCustomerName
                        ? newCustomerName.value.trim()
                        : "";

                const guestPhone =
                        newCustomerPhone
                        ? newCustomerPhone.value
                                .replace(
                                        /\s+/g,
                                        ""
                                )
                        : "";

                if (
                    guestPhone !== ""
                    && !/^0\d{8,10}$/
                            .test(
                                    guestPhone
                            )
                ) {
                    alert(
                            "Số điện thoại phải bắt đầu bằng 0 và có từ 9 đến 11 số."
                    );

                    return false;
                }

                if (
                    saveCustomerCheckbox
                    && saveCustomerCheckbox.checked
                ) {
                    if (guestName === "") {
                        alert(
                                "Vui lòng nhập tên khách hàng mới."
                        );

                        return false;
                    }

                    if (guestPhone === "") {
                        alert(
                                "Vui lòng nhập số điện thoại khách hàng mới."
                        );

                        return false;
                    }
                }

                return true;
            }

            document.addEventListener(
                    "click",
                    function (event) {
                        const productButton =
                                event.target.closest(
                                        ".product-pick"
                                );

                        if (productButton) {
                            event.preventDefault();

                            addProductToCart(
                                    productButton
                            );

                            return;
                        }

                        const removeButton =
                                event.target.closest(
                                        ".cart-remove"
                                );

                        if (removeButton) {
                            event.preventDefault();

                            const row =
                                    removeButton.closest(
                                            ".cart-row"
                                    );

                            if (row) {
                                row.remove();

                                updateInvoiceTotal();
                            }
                        }
                    }
            );

            if (cartTableBody) {
                cartTableBody.addEventListener(
                        "input",
                        function (event) {
                            if (
                                event.target.classList
                                        .contains(
                                                "cart-quantity"
                                        )
                            ) {
                                updateInvoiceTotal();
                            }
                        }
                );

                cartTableBody.addEventListener(
                        "change",
                        function (event) {
                            if (
                                !event.target.classList
                                        .contains(
                                                "cart-quantity"
                                        )
                            ) {
                                return;
                            }

                            let quantity =
                                    Number(
                                            event.target.value
                                    ) || 1;

                            if (quantity < 1) {
                                quantity = 1;
                            }

                            event.target.value =
                                    String(
                                            quantity
                                    );

                            updateInvoiceTotal();
                        }
                );
            }

            if (productSearch) {
                productSearch.addEventListener(
                        "input",
                        filterProducts
                );
            }

            customerModeRadios.forEach(
                    function (radio) {
                        radio.addEventListener(
                                "change",
                                function () {
                                    syncCustomerMode(
                                            true
                                    );
                                }
                        );
                    }
            );

            if (customerSelect) {
                customerSelect.addEventListener(
                        "change",
                        function () {
                            filterVouchers(
                                    true
                            );
                        }
                );
            }

            if (voucherSelect) {
                voucherSelect.addEventListener(
                        "change",
                        updateInvoiceTotal
                );
            }

            if (
                cancelInvoiceButton
                && cancelInvoiceForm
                && cancelReasonInput
            ) {
                cancelInvoiceButton.addEventListener(
                        "click",
                        function () {
                            const reason =
                                    window.prompt(
                                            "Nhập lý do hủy hóa đơn:"
                                    );

                            if (reason === null) {
                                return;
                            }

                            if (
                                reason.trim() === ""
                            ) {
                                alert(
                                        "Vui lòng nhập lý do hủy."
                                );

                                return;
                            }

                            if (
                                !window.confirm(
                                        "Xác nhận hủy hóa đơn?"
                                )
                            ) {
                                return;
                            }

                            cancelReasonInput.value =
                                    reason.trim();

                            cancelInvoiceForm.submit();
                        }
                );
            }

            if (invoiceForm) {
                invoiceForm.addEventListener(
                        "submit",
                        function (event) {
                            const submitButton =
                                    event.submitter;

                            const action =
                                    submitButton
                                    ? submitButton.value
                                    : "";

                            if (
                                action !== "save"
                                && action !== "pay"
                            ) {
                                return;
                            }

                            if (
                                getCartRows().length === 0
                            ) {
                                event.preventDefault();

                                alert(
                                        "Hóa đơn phải có ít nhất một sản phẩm."
                                );

                                return;
                            }

                            if (!validateCustomer()) {
                                event.preventDefault();
                                return;
                            }

                            if (action !== "pay") {
                                return;
                            }

                            const voucherValue =
                                    getVoucherValue();

                            const subTotal =
                                    calculateSubTotal();

                            const vat =
                                    Math.round(
                                            subTotal * 0.08
                                    );

                            const totalBeforeDiscount =
                                    subTotal + vat;

                            if (
                                voucherValue
                                > totalBeforeDiscount
                            ) {
                                event.preventDefault();

                                alert(
                                        "Mệnh giá voucher lớn hơn tổng giá trị hóa đơn."
                                );

                                return;
                            }

                            if (
                                voucherValue > 0
                                && voucherSelect
                            ) {
                                const option =
                                        voucherSelect.options[
                                                voucherSelect.selectedIndex
                                        ];

                                const voucherCode =
                                        option
                                        ? option.dataset.code
                                        : "";

                                if (
                                    !window.confirm(
                                            "Xác nhận dùng voucher "
                                            + voucherCode
                                            + " giảm "
                                            + formatMoney(
                                                    voucherValue
                                            )
                                            + "?"
                                    )
                                ) {
                                    event.preventDefault();
                                }
                            }
                        }
                );
            }

            if (
                customerModeRadios.length > 0
            ) {
                syncCustomerMode(
                        false
                );

            } else {
                updateInvoiceTotal();
            }
        }
);