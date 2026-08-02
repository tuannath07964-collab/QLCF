document.addEventListener(
        "DOMContentLoaded",
        function () {
            const chartCanvas =
                    document.getElementById(
                            "invoiceTodayChart"
                    );

            const chartDataContainer =
                    document.getElementById(
                            "invoiceTodayChartData"
                    );

            const chartEmpty =
                    document.getElementById(
                            "invoiceTodayChartEmpty"
                    );

            if (
                !chartCanvas
                || !chartDataContainer
            ) {
                return;
            }

            const points =
                    Array.from(
                            chartDataContainer
                                    .querySelectorAll(
                                            "span[data-label]"
                                    )
                    );

            const labels =
                    points.map(
                            function (point) {
                                return point.dataset.label;
                            }
                    );

            const values =
                    points.map(
                            function (point) {
                                return Number(
                                        point.dataset.value
                                ) || 0;
                            }
                    );

            const totalInvoice =
                    values.reduce(
                            function (total, value) {
                                return total + value;
                            },
                            0
                    );

            if (totalInvoice === 0) {
                chartCanvas.classList.add(
                        "hidden"
                );

                if (chartEmpty) {
                    chartEmpty.classList.remove(
                            "hidden"
                    );
                }

                return;
            }

            if (typeof Chart === "undefined") {
                chartCanvas.classList.add(
                        "hidden"
                );

                if (chartEmpty) {
                    chartEmpty.classList.remove(
                            "hidden"
                    );

                    chartEmpty.querySelector(
                            "strong"
                    ).textContent =
                            "Không tải được biểu đồ";
                }

                return;
            }

            new Chart(
                    chartCanvas.getContext("2d"),
                    {
                        type: "bar",

                        data: {
                            labels: labels,

                            datasets: [
                                {
                                    label: "Số hóa đơn",

                                    data: values,

                                    backgroundColor:
                                            "rgba(48, 71, 94, 0.78)",

                                    borderColor:
                                            "#30475e",

                                    borderWidth: 1,

                                    borderRadius: 6,

                                    borderSkipped: false,

                                    maxBarThickness: 28
                                }
                            ]
                        },

                        options: {
                            responsive: true,

                            maintainAspectRatio: false,

                            interaction: {
                                intersect: false,
                                mode: "index"
                            },

                            plugins: {
                                legend: {
                                    display: false
                                },

                                tooltip: {
                                    callbacks: {
                                        title: function (
                                                tooltipItems
                                        ) {
                                            return "Khung giờ "
                                                    + tooltipItems[0]
                                                            .label;
                                        },

                                        label: function (
                                                context
                                        ) {
                                            return context.raw
                                                    + " hóa đơn";
                                        }
                                    }
                                }
                            },

                            scales: {
                                x: {
                                    grid: {
                                        display: false
                                    },

                                    ticks: {
                                        color: "#6f7d88",

                                        autoSkip: true,

                                        maxTicksLimit: 12,

                                        maxRotation: 0
                                    }
                                },

                                y: {
                                    beginAtZero: true,

                                    grid: {
                                        color:
                                                "rgba(225, 231, 235, 0.85)"
                                    },

                                    ticks: {
                                        color: "#6f7d88",

                                        precision: 0,

                                        stepSize: 1
                                    },

                                    title: {
                                        display: true,

                                        text: "Số hóa đơn",

                                        color: "#6f7d88"
                                    }
                                }
                            }
                        }
                    }
            );
        }
);