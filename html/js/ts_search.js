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
    placeholder: 'Suchen',
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
            <h5><a href="{{id}}">{{#helpers.snippet}}{ "attribute": "title", "highlightedTagName": "mark" }{{/helpers.snippet}}</a></h5>
            {{#full_text}}
            <p style="overflow:hidden;max-height:210px;">{{#helpers.snippet}}{ "attribute": "full_text", "highlightedTagName": "mark" }{{/helpers.snippet}}</p>
            {{/full_text}}
          `,
    },
    transformItems(items) {
      return items.map(item => {
        if (search.helper.state.query) {
          return item;
        } else {
          return { ...item, full_text: null };
        }
      });
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
  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: 'Sitzungsrahmen',
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-series",
    attribute: "sitzungsrahmen",
    cssClasses: {
      list: "list-unstyled",
      count: "badge m-2 badge-secondary",
      label: "d-flex align-items-center text-start",
      checkbox: "m-2",
    },
  }),
  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: 'Orte',
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-place",
    attribute: "orte",
    templates: {
      showMoreText(data, { html }) {
        return html`<span>${data.isShowingMore ? 'Weniger anzeigen' : 'Mehr anzeigen'}</span>`;
      },
    },
    searchable: true,
    showMore: true,
    showMoreLimit: 1000,
    limit: 5,
    searchablePlaceholder: "Nach Ort suchen",
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

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: 'Personen',
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-person",
    attribute: "personen",
    templates: {
      showMoreText(data, { html }) {
        return html`<span>${data.isShowingMore ? 'Weniger anzeigen' : 'Mehr anzeigen'}</span>`;
      },
    },
    searchable: true,
    limit: 5,
    showMore: true,
    showMoreLimit: 1000,
    searchablePlaceholder: "Nach Person suchen",
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
  instantsearch.widgets.panel({
    templates: {
      header: 'Jahr',
    },
  })(instantsearch.widgets.rangeInput)({
    container: "#refinement-range-year",
    attribute: "jahr",
    templates: {
      separatorText: "bis",
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