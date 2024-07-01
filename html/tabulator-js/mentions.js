function linkToDetailView(cell) {
    var cellData = cell.getData()
    var theLink = `<a href="${cellData.target}">${cellData.protocol}</a>`

    return theLink
}

var table = new Tabulator("#mentions", {
    langs: {
        "de": {
            "pagination": {
                "first": "Erste",
                "first_title": "Erste Seite",
                "last": "Letzte",
                "last_title": "Letzte Seite",
                "prev": "Vorherige",
                "prev_title": "Vorherige Seite",
                "next": "Nächste",
                "next_title": "Nächste Seite",
                "counter": {
                    "showing": "",
                    "of": "von",
                    "rows": "Erwähnungen",
                    "pages": "Seiten",
                },
            },
        },

    },
    locale: "de",
    data: mentions,
    layout: "fitColumns",
    responsiveLayout: "collapse",
    tooltips: true,
    pagination: true,
    paginationSize: 10,
    paginationCounter: "rows",
    initialSort: [
        { column: "target", dir: "asc" },
    ],
    columns: [
        { field: "protocol", formatter: linkToDetailView, formatterParams: { target: "_blank" }, headerFilter: "input" },
        { field: "target", visible: false },
    ],
});
