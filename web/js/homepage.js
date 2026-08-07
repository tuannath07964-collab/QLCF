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
                chartDataContainer.querySelectorAll(
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

                const emptyTitle =
                    chartEmpty.querySelector(
                        "strong"
                    );

                if (emptyTitle) {
                    emptyTitle.textContent =
                        "Không tải được biểu đồ";
                }
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
                                "rgba(127, 152, 119, 0.32)",

                            hoverBackgroundColor:
                                "rgba(96, 119, 92, 0.48)",

                            borderColor:
                                "#6f8969",

                            hoverBorderColor:
                                "#5e755a",

                            borderWidth: 1,

                            borderRadius: 7,

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

                    animation: {
                        duration: 700,
                        easing: "easeOutQuart"
                    },

                    plugins: {
                        legend: {
                            display: false
                        },

                        tooltip: {
                            backgroundColor:
                                "#5e4539",

                            titleColor:
                                "#fffaf0",

                            bodyColor:
                                "#fffaf0",

                            borderColor:
                                "#7f9877",

                            borderWidth: 1,

                            padding: 12,

                            displayColors: false,

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
                            border: {
                                color:
                                    "rgba(218, 207, 185, 0.9)"
                            },

                            grid: {
                                display: false
                            },

                            ticks: {
                                color:
                                    "#777066",

                                font: {
                                    size: 11,
                                    weight: "500"
                                },

                                autoSkip: true,

                                maxTicksLimit: 12,

                                maxRotation: 0
                            }
                        },

                        y: {
                            beginAtZero: true,

                            border: {
                                display: false
                            },

                            grid: {
                                color:
                                    "rgba(218, 207, 185, 0.72)",

                                drawTicks: false
                            },

                            ticks: {
                                color:
                                    "#777066",

                                padding: 8,

                                precision: 0,

                                stepSize: 1,

                                font: {
                                    size: 11,
                                    weight: "500"
                                }
                            },

                            title: {
                                display: true,

                                text:
                                    "Số hóa đơn",

                                color:
                                    "#777066",

                                font: {
                                    size: 12,
                                    weight: "600"
                                }
                            }
                        }
                    }
                }
            }
        );
    }
);