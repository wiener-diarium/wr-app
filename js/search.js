var project_collection_name = "gestrich_index"
const annoUrl = "https://anno.onb.ac.at/cgi-content/anno?aid=wrz&datum="
const annoImgUrl = "https://anno.onb.ac.at/cgi-content/annoshow?call=wrz|"

function makeAnnoLink(hit) {
    let hitDate = hit.day;
    let hitPage = hit.page;
    let hitDigit = hit.digitarium_issue;
    let hidId = hit.id;
    let hitGestrich = hit.gestrich;
    if (hitDigit) {
        let wr_app_id = hidId.split('__')[0].replace('wr_', '');
        return `${wr_app_id}.html#wr_page_${hitPage}`;
    } else if (hitGestrich) {
        let wr_app_id = hidId.split('__')[0];
        return `${wr_app_id}.html#wr_page_${hitPage}`;
    } else {
        return `${annoUrl}${hitDate}&seite=${hitPage}`;
    }
}
function makeAnnoImgUrl(hit) {
    let hitDate = hit.day;
    let hitPage = hit.page;
    return `${annoImgUrl}${hitDate}|${hitPage}|10.0|0`;
}
function makeTitle(hit) {
    let hitDigit = hit.digitarium_issue;
    let hitGestrich = hit.gestrich;
    if (hitDigit) {
        var title = hit.title.split(', ')[0];
    } else if (hitGestrich) {
        var title = hit.title.split(', ')[2];
    }
    return title;
}
const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
    server: {
        apiKey: "jgQAkG16CRrqpASNqV0Zn8xUNtZ5nq96",
        nodes: [
            {
                host: "typesense.acdh-dev.oeaw.ac.at",
                port: "443",
                protocol: "https",
            },
        ],
    },
    additionalSearchParameters: {
        query_by: "full_text,extra_full_text",
    },
});

const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
    searchClient,
    indexName: project_collection_name,
    routing: true,
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
            item: "w-20 border border-light rounded m-2 p-2 d-flex flex-column",
        },
        templates: {
            empty: "Keine Resultate für <q>{{ query }}</q>",
            item(hit, { html, components }) {
                console.log(hit);
                return html` 
                <a class="text-decoration-none text-dark" 
                    href='${makeAnnoLink(hit)}'
                    aria-label="Link zu Dokument: ${hit.title}">
                    <div class="row align-items-center">
                        <div class="col-md-4">
                            <img src="${makeAnnoImgUrl(hit)}" class="img-thumbnail" alt="Bild"/>
                        </div>
                        <div class="col-md-8">
                            <table class="table table-sm">
                                <tr>
                                    <td><strong>Ausgabe:</strong></td>
                                    <td>${makeTitle(hit)}</td>
                                </tr>
                                <tr>
                                    <td><strong>ID:</strong></td>
                                    <td>${hit.id}</td>
                                </tr>
                                <tr>
                                    <td><strong>Artikel:</strong></td>
                                    <td>${hit.article_count}</td>
                                </tr>
                                <tr>
                                    <td><strong>Seite:</strong></td>
                                    <td>${hit.page}</td>
                                </tr>
                                <tr>
                                    <td><strong>Jahr:</strong></td>
                                    <td>${hit.year}</td>
                                </tr>
                                <tr>
                                    <td><strong>Edition:</strong></td>
                                    <td>${hit.edition[0]}</td>
                                </tr>
                                <tr>
                                    <td><strong>Korrekturstatus:</strong></td>
                                    <td>${hit.corrections}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </a>
            `;
            },
        },
    }),

    // <p>${hit._snippetResult.full_text.matchedWords.length > 0 ? components.Snippet({ hit, attribute: 'full_text' }) : ''}</p>
    // <p>${hit.places.map((item) => html`<a href='${item.id}'><span class="badge rounded-pill m-1 bg-info">${item}</span></a>`)}
    // ${hit.keywords.map((item) => html`<a href='${item.id}'><span class="badge rounded-pill m-1 bg-success">${item}</span></a>`)}</p>
    // <p><small>sonstige Schlagworte:</small> ${hit.extra_full_text}</p>

    instantsearch.widgets.pagination({
        container: "#pagination",
    }),

    instantsearch.widgets.menu({
        container: "#menu-edition",
        attribute: "edition",
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
        container: "#corrections",
        attribute: "corrections",
        searchable: false,
        cssClasses: {
            searchableInput: "form-control form-control-sm m-2 border-light-2",
            searchableSubmit: "d-none",
            searchableReset: "d-none",
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge d-flex align-self-end m-2 badge-secondary hideme ",
            label: "d-flex align-items-start text-left text-capitalize",
            checkbox: "m-2",
        },
    }),
    instantsearch.widgets.refinementList({
        container: "#has-fulltext",
        attribute: "has_fulltext",
        searchable: false,
        cssClasses: {
            searchableInput: "form-control form-control-sm m-2 border-light-2",
            searchableSubmit: "d-none",
            searchableReset: "d-none",
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge d-flex align-self-end m-2 badge-secondary hideme ",
            label: "d-flex align-items-start text-left text-capitalize",
            checkbox: "m-2",
        },
    }),
    instantsearch.widgets.refinementList({
        container: "#digitarium-issue",
        attribute: "digitarium_issue",
        searchable: false,
        cssClasses: {
            searchableInput: "form-control form-control-sm m-2 border-light-2",
            searchableSubmit: "d-none",
            searchableReset: "d-none",
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge d-flex align-self-end m-2 badge-secondary hideme ",
            label: "d-flex align-items-start text-left text-capitalize",
            checkbox: "m-2",
        },
    }),
    instantsearch.widgets.refinementList({
        container: "#gestrich",
        attribute: "gestrich",
        searchable: false,
        cssClasses: {
            searchableInput: "form-control form-control-sm m-2 border-light-2",
            searchableSubmit: "d-none",
            searchableReset: "d-none",
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge d-flex align-self-end m-2 badge-secondary hideme ",
            label: "d-flex align-items-start text-left text-capitalize",
            checkbox: "m-2",
        },
    }),

    instantsearch.widgets.refinementList({
        container: "#refinement-list-keywords",
        attribute: "keywords",
        searchable: true,
        searchablePlaceholder: "Suchen",
        cssClasses: {
            searchableInput: "form-control form-control-sm m-2 border-light-2",
            searchableSubmit: "d-none",
            searchableReset: "d-none",
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge d-flex align-self-end m-2 badge-secondary hideme",
            label: "d-flex align-items-start text-left text-capitalize",
            checkbox: "m-2",
        },
    }),

    // instantsearch.widgets.refinementList({
    //     container: "#refinement-list-persons",
    //     attribute: "persons.title",
    //     searchable: true,
    //     cssClasses: {
    //         showMore: "btn btn-secondary btn-sm align-content-center",
    //         list: "list-unstyled",
    //         count: "badge m-2 badge-secondary hideme",
    //         label: "d-flex align-items-center",
    //         checkbox: "m-2",
    //     },
    // }),

    instantsearch.widgets.refinementList({
        container: "#refinement-list-places",
        attribute: "places",
        searchable: true,
        cssClasses: {
            showMore: "btn btn-secondary btn-sm align-content-center",
            list: "list-unstyled",
            count: "badge d-flex align-self-end m-2 badge-secondary hideme",
            label: "d-flex align-items-start text-left",
            checkbox: "m-2",
        },
    }),

    // instantsearch.widgets.refinementList({
    //     container: "#refinement-list-case",
    //     attribute: "case.title",
    //     searchable: true,
    //     searchablePlaceholder: "Suchen",
    //     cssClasses: {
    //         showMore: "btn btn-secondary btn-sm align-content-center",
    //         list: "list-unstyled",
    //         count: "badge m-2 badge-secondary hideme",
    //         label: "d-flex align-items-center text-capitalize",
    //         checkbox: "m-2",
    //     },
    // }),

    // instantsearch.widgets.refinementList({
    //     container: "#refinement-list-materials",
    //     attribute: "materials",
    //     searchable: true,
    //     cssClasses: {
    //         showMore: "btn btn-secondary btn-sm align-content-center",
    //         list: "list-unstyled",
    //         count: "badge m-2 badge-secondary hideme",
    //         label: "d-flex align-items-center text-capitalize",
    //         checkbox: "m-2",
    //     },
    // }),

    instantsearch.widgets.rangeInput({
        container: "#refinement-range-year",
        attribute: "year",
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

    instantsearch.widgets.rangeInput({
        container: "#refinement-article_count",
        attribute: "article_count",
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

    instantsearch.widgets.pagination({
        container: "#pagination",
        padding: 2,
        cssClasses: {
            list: "pagination my-4",
            item: "page-item",
            link: "page-link",
        },
    }),

    instantsearch.widgets.pagination({
        container: "#pagination0",
        padding: 2,
        cssClasses: {
            list: "pagination my-4",
            item: "page-item",
            link: "page-link",
        },
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

    instantsearch.widgets.sortBy({
        container: "#sort-by",
        items: [
            { label: "Jahr (aufsteigend)", value: "gestrich_index/sort/year:asc" },
            { label: "Jahr (absteigend)", value: "gestrich_index/sort/year:desc" },
        ],
    }),

    instantsearch.widgets.configure({
        hitsPerPage: 20,
        attributesToSnippet: ["full_text"],
    }),

]);

search.start();