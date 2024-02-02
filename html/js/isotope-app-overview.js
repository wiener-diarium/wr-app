var grid = document.querySelector('.grid-overview');
var iso;

imagesLoaded( grid, function() {
  // init Isotope after all images have loaded
  iso = new Isotope( grid, {
    layoutMode: 'fitRows',
    itemSelector: '.grid-overview-item',
    fitRows: {
      gutter: 20
    },
    getSortData: {
      name: '.grid-overview-item-header',
      category: '[data-category]',
      data: function( itemElem ) {
        var date = $( itemElem ).attr('data-date');
        return parseFloat( date.replace( /-/g, '') );
      }
    },
    sortBy: 'data'
  });
  document.getElementById("grid-select-year")
  .addEventListener('change', function( event ) {
    var filterValue = this.value;
    iso.arrange({ filter: filterValue });
  });
});