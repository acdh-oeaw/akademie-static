const project_collection_name = "akademie-static"
const main_search_field = "full_text"
const search_api_key = "mP7O7YJGYQ5GxMPkvFUV6XI90meuLg8U"  // custom search only key

const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
    server: {
        apiKey: search_api_key,
        nodes: [
            {
                host: "typesense.acdh-dev.oeaw.ac.at",
                port: "443",
                protocol: "https",
            },
        ],
    },
    additionalSearchParameters: {
        query_by: main_search_field,
    },
});

const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
    searchClient,
    indexName: project_collection_name,
});

search.addWidgets([
    instantsearch.widgets.searchBox({
        container: "#searchbox",
        autofocus: true,
        cssClasses: {
            form: "form-inline",
            input: "form-control col-md-11",
            submit: "btn",
            reset: "btn",
        },
    }),

    instantsearch.widgets.hits({
        container: "#hits",
        cssClasses: {
            item: "w-100"
        },
        templates: {
            empty: "Keine Resultate für <q>{{ query }}</q>",
            item: `
              <h5><a href="{{id}}.html">{{#helpers.snippet}}{ "attribute": "title", "highlightedTagName": "mark" }{{/helpers.snippet}}</a></h5>
              <p style="overflow:hidden;max-height:210px;">{{#helpers.snippet}}{ "attribute": "full_text", "highlightedTagName": "mark" }{{/helpers.snippet}}</p>
          `,
        },
    }),

    instantsearch.widgets.pagination({
        container: "#pagination",
    }),

    instantsearch.widgets.clearRefinements({
        container: "#clear-refinements",
        templates: {
            resetLabel: "Filter zurücksetzen",
        },
        cssClasses: {
            button: "btn",
        },
    }),


    instantsearch.widgets.currentRefinements({
        container: "#current-refinements",
        cssClasses: {
            delete: "btn",
            label: "badge",
        },
    }),

    instantsearch.widgets.stats({
        container: "#stats-container",
        templates: {
            text: `
            {{#areHitsSorted}}
              {{#hasNoSortedResults}}keine Treffer{{/hasNoSortedResults}}
              {{#hasOneSortedResults}}1 Treffer{{/hasOneSortedResults}}
              {{#hasManySortedResults}}{{#helpers.formatNumber}}{{nbSortedHits}}{{/helpers.formatNumber}} Treffer {{/hasManySortedResults}}
              aus {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}}
            {{/areHitsSorted}}
            {{^areHitsSorted}}
              {{#hasNoResults}}keine Treffer{{/hasNoResults}}
              {{#hasOneResult}}1 Treffer{{/hasOneResult}}
              {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} Treffer{{/hasManyResults}}
            {{/areHitsSorted}}
            gefunden in {{processingTimeMS}}ms
          `,
        },
    }),

    instantsearch.widgets.refinementList({
        container: "#refinement-list-place",
        attribute: "places",
        searchable: true,
        showMore: true,
        searchablePlaceholder: "Suchen",
        cssClasses: {
            searchableInput: "form-control form-control-sm m-2 border-light-2",
            searchableSubmit: "d-none",
            searchableReset: "d-none",
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge m-2 badge-secondary",
            label: "d-flex align-items-center text-capitalize",
            checkbox: "m-2",
        },
    }),

    instantsearch.widgets.refinementList({
        container: "#refinement-list-person",
        attribute: "persons",
        searchable: true,
        showMore: true,
        searchablePlaceholder: "Suchen",
        cssClasses: {
            searchableInput: "form-control form-control-sm m-2 border-light-2",
            searchableSubmit: "d-none",
            searchableReset: "d-none",
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge m-2 badge-secondary",
            label: "d-flex align-items-center text-start",
            checkbox: "m-2",
        },
    }),

    instantsearch.widgets.rangeInput({
        container: "#refinement-range-year",
        attribute: "year",
        templates: {
          separatorText: "to",
          submitText: "Suchen",
        },
        cssClasses: {
          form: "form-inline",
          input: "form-control",
          submit: "btn",
        },
      }),

    instantsearch.widgets.configure({
        hitsPerPage: 10,
        //attributesToSnippet: [main_search_field],
        attributesToSnippet: ["full_text"],
    }),

]);

search.start();