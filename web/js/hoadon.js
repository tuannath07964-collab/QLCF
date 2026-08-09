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
                    Array.from(
                            document.querySelectorAll(
                                    'input[name="customerMode"]'
                            )
                    );

            const savedCustomerSection =
                    document.getElementById(
                            "savedCustomerSection"
                    );

            const newCustomerSection =
                    document.getElementById(
                            "newCustomerSection"
                    );

            const guestCustomerSection =
                    document.getElementById(
                            "guestCustomerSection"
                    );

            const selectedCustomerCodeInput =
                    document.getElementById(
                            "selectedCustomerCodeInput"
                    );

            const customerSearchInput =
                    document.getElementById(
                            "customerSearchInput"
                    );

            const customerSearchButton =
                    document.getElementById(
                            "customerSearchButton"
                    );

            const customerSearchResults =
                    document.getElementById(
                            "customerSearchResults"
                    );

            const customerSearchEmpty =
                    document.getElementById(
                            "customerSearchEmpty"
                    );

            const customerSearchHelp =
                    document.getElementById(
                            "customerSearchHelp"
                    );

            const selectedCustomerCard =
                    document.getElementById(
                            "selectedCustomerCard"
                    );

            const selectedCustomerName =
                    document.getElementById(
                            "selectedCustomerName"
                    );

            const selectedCustomerDetail =
                    document.getElementById(
                            "selectedCustomerDetail"
                    );

            const selectedCustomerPoints =
                    document.getElementById(
                            "selectedCustomerPoints"
                    );

            const clearSelectedCustomerButton =
                    document.getElementById(
                            "clearSelectedCustomerButton"
                    );

            const customerSearchItems =
                    Array.from(
                            document.querySelectorAll(
                                    ".customer-search-item"
                            )
                    );

            const newCustomerName =
                    document.getElementById(
                            "newCustomerName"
                    );

            const newCustomerPhone =
                    document.getElementById(
                            "newCustomerPhone"
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
                                    voucherSelect
                                            .querySelectorAll(
                                                    "option[data-customer]"
                                            )
                            )
                            : [];


            function formatMoney(value) {

                return (
                        Number(value) || 0
                        ).toLocaleString(
                                "vi-VN"
                        )
                        + "đ";
            }


            function normalizeText(value) {

                return String(
                        value || ""
                        )
                        .toLowerCase()
                        .normalize("NFD")
                        .replace(
                                /[\u0300-\u036f]/g,
                                ""
                        )
                        .replace(
                                /đ/g,
                                "d"
                        )
                        .trim();
            }


            function getCustomerMode() {

                const selected =
                        document.querySelector(
                                'input[name="customerMode"]:checked'
                        );

                return selected
                        ? selected.value
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


            function findCartRow(code) {

                return getCartRows().find(
                        function (row) {

                            return row.dataset.code
                                    === code;
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


            function getSelectedCustomerCode() {

                if (
                        !selectedCustomerCodeInput
                        || selectedCustomerCodeInput.disabled
                ) {
                    return "";
                }

                return selectedCustomerCodeInput
                        .value
                        .trim();
            }


            function hideCustomerSearchResults() {

                if (customerSearchResults) {

                    customerSearchResults
                            .classList
                            .add("hidden");
                }
            }


            function setCustomerSearchMessage(
                    message,
                    error
            ) {

                if (!customerSearchHelp) {
                    return;
                }

                customerSearchHelp.textContent =
                        message;

                customerSearchHelp
                        .classList
                        .toggle(
                                "text-danger",
                                Boolean(error)
                        );
            }


            function clearSelectedCustomer(
                    clearSearch
            ) {

                if (selectedCustomerCodeInput) {

                    selectedCustomerCodeInput
                            .value = "";
                }

                if (
                        clearSearch
                        && customerSearchInput
                ) {

                    customerSearchInput.value =
                            "";
                }

                if (selectedCustomerCard) {

                    selectedCustomerCard
                            .classList
                            .add("hidden");
                }

                setCustomerSearchMessage(
                        "Nhập mã, họ tên hoặc số điện thoại để tìm khách hàng.",
                        false
                );

                filterVouchers(true);
            }


            function selectSavedCustomer(
                    item,
                    resetVoucher
            ) {

                if (
                        !item
                        || !selectedCustomerCodeInput
                ) {
                    return;
                }

                const code =
                        item.dataset.code || "";

                const name =
                        item.dataset.name || "";

                const phone =
                        item.dataset.phone || "";

                const points =
                        Number(
                                item.dataset.points
                        ) || 0;

                selectedCustomerCodeInput.value =
                        code;

                if (customerSearchInput) {

                    customerSearchInput.value =
                            [
                                code,
                                name,
                                phone
                            ]
                                    .filter(Boolean)
                                    .join(" - ");
                }

                if (selectedCustomerName) {

                    selectedCustomerName.textContent =
                            name || "—";
                }

                if (selectedCustomerDetail) {

                    selectedCustomerDetail.textContent =
                            code
                            + " · "
                            + (
                                    phone
                                    || "Chưa có số điện thoại"
                            );
                }

                if (selectedCustomerPoints) {

                    selectedCustomerPoints.textContent =
                            points
                            + " điểm";
                }

                if (selectedCustomerCard) {

                    selectedCustomerCard
                            .classList
                            .remove("hidden");
                }

                hideCustomerSearchResults();

                setCustomerSearchMessage(
                        "Đã chọn khách hàng.",
                        false
                );

                filterVouchers(
                        Boolean(resetVoucher)
                );
            }


            function searchSavedCustomers() {

                if (
                        !customerSearchInput
                        || !customerSearchResults
                ) {
                    return;
                }

                const keyword =
                        normalizeText(
                                customerSearchInput.value
                        );

                if (!keyword) {

                    hideCustomerSearchResults();

                    setCustomerSearchMessage(
                            "Nhập mã, họ tên hoặc số điện thoại để tìm khách hàng.",
                            false
                    );

                    return;
                }

                let count = 0;

                customerSearchItems.forEach(
                        function (item) {

                            const text =
                                    normalizeText(
                                            [
                                                item.dataset.code,
                                                item.dataset.name,
                                                item.dataset.phone
                                            ]
                                                    .filter(Boolean)
                                                    .join(" ")
                                    );

                            const matched =
                                    text.includes(
                                            keyword
                                    );

                            item.classList.toggle(
                                    "hidden",
                                    !matched
                            );

                            if (matched) {
                                count++;
                            }
                        }
                );

                if (customerSearchEmpty) {

                    customerSearchEmpty
                            .classList
                            .toggle(
                                    "hidden",
                                    count > 0
                            );
                }

                customerSearchResults
                        .classList
                        .remove("hidden");

                if (count === 0) {

                    setCustomerSearchMessage(
                            "Không tìm thấy khách hàng phù hợp.",
                            true
                    );

                } else {

                    setCustomerSearchMessage(
                            "Tìm thấy "
                            + count
                            + " khách hàng.",
                            false
                    );
                }
            }


            function restoreSelectedCustomer() {

                if (!selectedCustomerCodeInput) {
                    return;
                }

                const code =
                        selectedCustomerCodeInput
                                .value
                                .trim();

                if (!code) {
                    return;
                }

                const item =
                        customerSearchItems.find(
                                function (customer) {

                                    return customer
                                            .dataset
                                            .code
                                            === code;
                                }
                        );

                if (item) {

                    selectSavedCustomer(
                            item,
                            false
                    );
                }
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

                const code =
                        option
                                ? option.dataset.code || ""
                                : "";

                if (
                        code
                        && !voucherSelect.disabled
                ) {

                    voucherCodeElement.textContent =
                            code;

                    voucherPreview
                            .classList
                            .remove("hidden");

                } else {

                    voucherCodeElement.textContent =
                            "—";

                    voucherPreview
                            .classList
                            .add("hidden");
                }
            }


            function filterVouchers(
                    reset
            ) {

                if (!voucherSelect) {

                    updateInvoiceTotal();

                    return;
                }

                const saved =
                        getCustomerMode()
                        === "saved";

                const customerCode =
                        saved
                                ? getSelectedCustomerCode()
                                : "";

                let count = 0;

                voucherOptions.forEach(
                        function (option) {

                            const valid =
                                    customerCode !== ""
                                    && option.dataset.customer
                                    === customerCode;

                            option.hidden =
                                    !valid;

                            option.disabled =
                                    !valid;

                            if (valid) {
                                count++;
                            }
                        }
                );

                const current =
                        voucherSelect.options[
                                voucherSelect.selectedIndex
                        ];

                if (
                        reset
                        || !customerCode
                        || (
                                current
                                && current.dataset.customer
                                && current.dataset.customer
                                !== customerCode
                        )
                ) {

                    voucherSelect.value =
                            "";
                }

                voucherSelect.disabled =
                        !saved
                        || !customerCode
                        || count === 0;

                if (voucherHelpText) {

                    if (!saved) {

                        voucherHelpText.textContent =
                                "Chỉ khách hàng đã lưu mới được sử dụng voucher.";

                    } else if (!customerCode) {

                        voucherHelpText.textContent =
                                "Vui lòng chọn khách hàng.";

                    } else if (count === 0) {

                        voucherHelpText.textContent =
                                "Khách hàng không có voucher còn hiệu lực.";

                    } else {

                        voucherHelpText.textContent =
                                "Có "
                                + count
                                + " voucher còn hiệu lực.";
                    }
                }

                updateInvoiceTotal();
            }


            function syncCustomerMode(
                    resetVoucher
            ) {

                const mode =
                        getCustomerMode();

                const saved =
                        mode === "saved";

                const newCustomer =
                        mode === "new";

                const guest =
                        mode === "guest";

                if (savedCustomerSection) {

                    savedCustomerSection
                            .classList
                            .toggle(
                                    "hidden",
                                    !saved
                            );
                }

                if (newCustomerSection) {

                    newCustomerSection
                            .classList
                            .toggle(
                                    "hidden",
                                    !newCustomer
                            );
                }

                if (guestCustomerSection) {

                    guestCustomerSection
                            .classList
                            .toggle(
                                    "hidden",
                                    !guest
                            );
                }

                if (selectedCustomerCodeInput) {

                    selectedCustomerCodeInput.disabled =
                            !saved;
                }

                if (customerSearchInput) {

                    customerSearchInput.disabled =
                            !saved;
                }

                if (customerSearchButton) {

                    customerSearchButton.disabled =
                            !saved;
                }

                if (newCustomerName) {

                    newCustomerName.disabled =
                            !newCustomer;

                    newCustomerName.required =
                            newCustomer;
                }

                if (newCustomerPhone) {

                    newCustomerPhone.disabled =
                            !newCustomer;

                    newCustomerPhone.required =
                            newCustomer;
                }

                if (voucherSection) {

                    voucherSection
                            .classList
                            .toggle(
                                    "hidden",
                                    !saved
                            );
                }

                if (!saved) {

                    hideCustomerSearchResults();

                    if (voucherSelect) {

                        voucherSelect.value =
                                "";

                        voucherSelect.disabled =
                                true;
                    }
                }

                if (
                        newCustomer
                        && newCustomerName
                ) {

                    setTimeout(
                            function () {

                                newCustomerName.focus();
                            },
                            0
                    );
                }

                filterVouchers(
                        Boolean(resetVoucher)
                );
            }


            function calculateSubTotal() {

                let total = 0;

                getCartRows().forEach(
                        function (row) {

                            const price =
                                    Number(
                                            row.dataset.price
                                    ) || 0;

                            const input =
                                    row.querySelector(
                                            ".cart-quantity"
                                    );

                            let quantity =
                                    input
                                            ? Number(
                                                    input.value
                                            ) || 1
                                            : 1;

                            if (quantity < 1) {

                                quantity = 1;

                                if (input) {
                                    input.value = "1";
                                }
                            }

                            const lineTotal =
                                    price * quantity;

                            total += lineTotal;

                            const line =
                                    row.querySelector(
                                            ".cart-line-total"
                                    );

                            if (line) {

                                line.textContent =
                                        formatMoney(
                                                lineTotal
                                        );
                            }
                        }
                );

                return total;
            }


            function updateInvoiceTotal() {

                const subtotal =
                        calculateSubTotal();

                const vat =
                        Math.round(
                                subtotal * 0.08
                        );

                const beforeDiscount =
                        subtotal + vat;

                const voucher =
                        getVoucherValue();

                const total =
                        Math.max(
                                0,
                                beforeDiscount
                                - voucher
                        );

                if (subTotalValue) {

                    subTotalValue.textContent =
                            formatMoney(
                                    subtotal
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
                                    voucher
                            );
                }

                if (grandTotalValue) {

                    grandTotalValue.textContent =
                            formatMoney(
                                    total
                            );
                }

                updateVoucherPreview();

                updateEmptyCart();
            }


            function createImageElement(
                    imageUrl,
                    productName,
                    className,
                    fallbackClass
            ) {

                const wrapper =
                        document.createElement(
                                "span"
                        );

                wrapper.className =
                        className;

                const image =
                        document.createElement(
                                "img"
                        );

                image.src =
                        imageUrl;

                image.alt =
                        productName;

                image.loading =
                        "lazy";

                const fallback =
                        document.createElement(
                                "span"
                        );

                fallback.className =
                        fallbackClass;

                fallback.innerHTML =
                        '<i class="fa-solid fa-mug-hot"></i>';

                image.addEventListener(
                        "error",
                        function () {

                            image.style.display =
                                    "none";

                            fallback.style.display =
                                    "flex";
                        }
                );

                wrapper.appendChild(
                        image
                );

                wrapper.appendChild(
                        fallback
                );

                return wrapper;
            }


            function addProductToCart(
                    button
            ) {

                if (
                        !button
                        || button.disabled
                        || button
                                .classList
                                .contains(
                                        "disabled"
                                )
                ) {
                    return;
                }

                if (!cartTableBody) {
                    return;
                }

                const code =
                        button.dataset.code;

                const name =
                        button.dataset.name;

                const price =
                        Number(
                                button.dataset.price
                        ) || 0;

                const image =
                        button.dataset.image || "";

                const existing =
                        findCartRow(code);

                if (existing) {

                    const quantityInput =
                            existing.querySelector(
                                    ".cart-quantity"
                            );

                    if (quantityInput) {

                        quantityInput.value =
                                String(
                                        (
                                                Number(
                                                        quantityInput.value
                                                ) || 1
                                        ) + 1
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
                        code;

                row.dataset.name =
                        name;

                row.dataset.price =
                        String(price);

                row.dataset.image =
                        image;


                const productCell =
                        document.createElement(
                                "td"
                        );

                const productContainer =
                        document.createElement(
                                "div"
                        );

                productContainer.className =
                        "cart-product";

                productContainer.appendChild(
                        createImageElement(
                                image,
                                name,
                                "cart-product-image",
                                "cart-image-fallback"
                        )
                );

                const text =
                        document.createElement(
                                "span"
                        );

                text.className =
                        "cart-product-text";

                const strong =
                        document.createElement(
                                "strong"
                        );

                strong.textContent =
                        name;

                const small =
                        document.createElement(
                                "small"
                        );

                small.textContent =
                        formatMoney(
                                price
                        );

                text.appendChild(
                        strong
                );

                text.appendChild(
                        small
                );

                productContainer
                        .appendChild(
                                text
                        );

                productCell
                        .appendChild(
                                productContainer
                        );

                const hidden =
                        document.createElement(
                                "input"
                        );

                hidden.type =
                        "hidden";

                hidden.name =
                        "maSanPham";

                hidden.value =
                        code;

                productCell
                        .appendChild(
                                hidden
                        );


                const quantityCell =
                        document.createElement(
                                "td"
                        );

                const quantity =
                        document.createElement(
                                "input"
                        );

                quantity.className =
                        "cart-quantity";

                quantity.type =
                        "number";

                quantity.name =
                        "soLuong";

                quantity.value =
                        "1";

                quantity.min =
                        "1";

                quantity.step =
                        "1";

                quantityCell.appendChild(
                        quantity
                );


                const totalCell =
                        document.createElement(
                                "td"
                        );

                totalCell.className =
                        "cart-line-total";

                totalCell.textContent =
                        formatMoney(
                                price
                        );


                const removeCell =
                        document.createElement(
                                "td"
                        );

                const remove =
                        document.createElement(
                                "button"
                        );

                remove.className =
                        "cart-remove";

                remove.type =
                        "button";

                remove.innerHTML =
                        '<i class="fa-solid fa-xmark"></i>';

                removeCell.appendChild(
                        remove
                );


                row.appendChild(
                        productCell
                );

                row.appendChild(
                        quantityCell
                );

                row.appendChild(
                        totalCell
                );

                row.appendChild(
                        removeCell
                );

                cartTableBody
                        .appendChild(
                                row
                        );

                updateInvoiceTotal();
            }


            function validateCustomer() {

                const mode =
                        getCustomerMode();

                if (mode === "saved") {

                    if (
                            !getSelectedCustomerCode()
                    ) {

                        alert(
                                "Vui lòng tìm và chọn khách hàng đã lưu."
                        );

                        if (customerSearchInput) {

                            customerSearchInput
                                    .focus();
                        }

                        return false;
                    }

                    return true;
                }

                if (mode === "guest") {

                    return true;
                }

                const name =
                        newCustomerName
                                ? newCustomerName
                                        .value
                                        .trim()
                                : "";

                const phone =
                        newCustomerPhone
                                ? newCustomerPhone
                                        .value
                                        .replace(
                                                /\s+/g,
                                                ""
                                        )
                                : "";

                if (!name) {

                    alert(
                            "Vui lòng nhập họ tên khách hàng mới."
                    );

                    if (newCustomerName) {

                        newCustomerName
                                .focus();
                    }

                    return false;
                }

                if (!phone) {

                    alert(
                            "Vui lòng nhập số điện thoại khách hàng mới."
                    );

                    if (newCustomerPhone) {

                        newCustomerPhone
                                .focus();
                    }

                    return false;
                }

                if (
                        !/^0\d{8,10}$/
                                .test(
                                        phone
                                )
                ) {

                    alert(
                            "Số điện thoại phải bắt đầu bằng 0 và có từ 9 đến 11 chữ số."
                    );

                    if (newCustomerPhone) {

                        newCustomerPhone
                                .focus();
                    }

                    return false;
                }

                return true;
            }


            document.addEventListener(
                    "click",
                    function (event) {

                        const product =
                                event.target.closest(
                                        ".product-pick"
                                );

                        if (product) {

                            event.preventDefault();

                            addProductToCart(
                                    product
                            );

                            return;
                        }

                        const remove =
                                event.target.closest(
                                        ".cart-remove"
                                );

                        if (remove) {

                            event.preventDefault();

                            const row =
                                    remove.closest(
                                            ".cart-row"
                                    );

                            if (row) {

                                row.remove();
                            }

                            updateInvoiceTotal();

                            return;
                        }

                        if (
                                customerSearchResults
                                && !customerSearchResults
                                        .classList
                                        .contains(
                                                "hidden"
                                        )
                                && !customerSearchResults
                                        .contains(
                                                event.target
                                        )
                                && customerSearchInput
                                && !customerSearchInput
                                        .contains(
                                                event.target
                                        )
                                && customerSearchButton
                                && !customerSearchButton
                                        .contains(
                                                event.target
                                        )
                        ) {

                            hideCustomerSearchResults();
                        }
                    }
            );


            if (productSearch) {

                productSearch.addEventListener(
                        "input",
                        function () {

                            const keyword =
                                    normalizeText(
                                            productSearch.value
                                    );

                            document
                                    .querySelectorAll(
                                            ".product-pick"
                                    )
                                    .forEach(
                                            function (button) {

                                                const text =
                                                        normalizeText(
                                                                button.dataset.search
                                                        );

                                                button.style.display =
                                                        text.includes(
                                                                keyword
                                                        )
                                                                ? ""
                                                                : "none";
                                            }
                                    );
                        }
                );
            }


            if (cartTableBody) {

                cartTableBody.addEventListener(
                        "input",
                        function (event) {

                            if (
                                    !event.target
                                            .classList
                                            .contains(
                                                    "cart-quantity"
                                            )
                            ) {
                                return;
                            }

                            let value =
                                    Number(
                                            event.target.value
                                    ) || 1;

                            if (value < 1) {
                                value = 1;
                            }

                            event.target.value =
                                    String(value);

                            updateInvoiceTotal();
                        }
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


            if (customerSearchButton) {

                customerSearchButton
                        .addEventListener(
                                "click",
                                searchSavedCustomers
                        );
            }


            if (customerSearchInput) {

                customerSearchInput
                        .addEventListener(
                                "input",
                                function () {

                                    if (
                                            getSelectedCustomerCode()
                                    ) {

                                        clearSelectedCustomer(
                                                false
                                        );
                                    }

                                    searchSavedCustomers();
                                }
                        );

                customerSearchInput
                        .addEventListener(
                                "keydown",
                                function (event) {

                                    if (
                                            event.key
                                            === "Enter"
                                    ) {

                                        event.preventDefault();

                                        searchSavedCustomers();
                                    }
                                }
                        );
            }


            if (customerSearchResults) {

                customerSearchResults
                        .addEventListener(
                                "click",
                                function (event) {

                                    const item =
                                            event.target.closest(
                                                    ".customer-search-item"
                                            );

                                    if (!item) {
                                        return;
                                    }

                                    selectSavedCustomer(
                                            item,
                                            true
                                    );
                                }
                        );
            }


            if (clearSelectedCustomerButton) {

                clearSelectedCustomerButton
                        .addEventListener(
                                "click",
                                function () {

                                    clearSelectedCustomer(
                                            true
                                    );

                                    if (customerSearchInput) {

                                        customerSearchInput
                                                .focus();
                                    }
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

                cancelInvoiceButton
                        .addEventListener(
                                "click",
                                function () {

                                    const reason =
                                            window.prompt(
                                                    "Nhập lý do hủy hóa đơn:"
                                            );

                                    if (reason === null) {
                                        return;
                                    }

                                    if (!reason.trim()) {

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

                            const button =
                                    event.submitter;

                            const action =
                                    button
                                            ? button.value
                                            : "";

                            if (
                                    action !== "save"
                                    && action !== "pay"
                            ) {
                                return;
                            }

                            if (
                                    getCartRows().length
                                    === 0
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

                            const voucher =
                                    getVoucherValue();

                            const subtotal =
                                    calculateSubTotal();

                            const vat =
                                    Math.round(
                                            subtotal * 0.08
                                    );

                            if (
                                    voucher
                                    > subtotal + vat
                            ) {

                                event.preventDefault();

                                alert(
                                        "Mệnh giá voucher lớn hơn tổng giá trị hóa đơn."
                                );

                                return;
                            }

                            if (
                                    voucher > 0
                                    && voucherSelect
                            ) {

                                const option =
                                        voucherSelect.options[
                                                voucherSelect.selectedIndex
                                        ];

                                const code =
                                        option
                                                ? option.dataset.code || ""
                                                : "";

                                const confirmed =
                                        window.confirm(
                                                "Xác nhận sử dụng voucher "
                                                + code
                                                + " giảm "
                                                + formatMoney(
                                                        voucher
                                                )
                                                + "?"
                                        );

                                if (!confirmed) {

                                    event.preventDefault();
                                }
                            }
                        }
                );
            }


            restoreSelectedCustomer();

            if (
                    customerModeRadios.length > 0
            ) {

                syncCustomerMode(false);
            }

            updateInvoiceTotal();
        }
);