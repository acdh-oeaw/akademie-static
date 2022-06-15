const searchClient = algoliasearch('6HORH2BX27', '6229475aab4e74d71d6c93b8161e0742');

const search = instantsearch({
    indexName: 'akademie-static',
    searchClient,
});

search.addWidgets([
    instantsearch.widgets.searchBox({
        container: '#searchbox',
    }),

    instantsearch.widgets.hits({
        container: '#hits',
        templates: {
            empty: 'No results',
            item: `
                <h4> {{ rec_id }}</h4>
                <h5><a href="{{ rec_id }}">{{ title }}</a></h5>
                <p>{{#helpers.snippet}}{ "attribute": "full_text" }{{/helpers.snippet}}</p>
            `
        }
    }),

    instantsearch.widgets.stats({
        container: '#stats-container'
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-places',
        attribute: 'places',
        searchable: true,
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-persons',
        attribute: 'persons',
        searchable: true,
    }),

    instantsearch.widgets.pagination({
        container: '#pagination',
        padding: 2,
    }),
    instantsearch.widgets.clearRefinements({
        container: '#clear-refinements',
    })


]);



search.addWidgets([
    instantsearch.widgets.configure({
        attributesToSnippet: ['full_text'],
    })
]);


search.start();