var grid = document.querySelector('.grid-overview');
var iso;

imagesLoaded( grid, function() {
  // init Isotope after all images have loaded
  iso = new Isotope( grid, {
    layoutMode: 'fitRows',
    itemSelector: '.grid-overview-item',
    fitRows: {
      gutter: 10
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
  var filterFns = {
    decate1: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1699-12-31') && date < new Date('1709-12-31');
    },
    decate2: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1709-12-31') && date < new Date('1719-12-31');
    },
    decate3: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1719-12-31') && date < new Date('1729-12-31');
    },
    decate4: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1729-12-31') && date < new Date('1739-12-31');
    },
    decate5: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1739-12-31') && date < new Date('1749-12-31');
    },
    decate6: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1749-12-31') && date < new Date('1759-12-31');
    },
    decate7: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1759-12-31') && date < new Date('1769-12-31');
    },
    decate8: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1769-12-31') && date < new Date('1779-12-31');
    },
    decate9: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1779-12-31') && date < new Date('1789-12-31');
    },
    decate10: function() {
      var date = this.getAttribute('data-date');
      var date = new Date(date);
      return date > new Date('1789-12-31') && date < new Date('1799-12-31');
    }
  }
  document.getElementById("grid-select-year")
  .addEventListener('change', function() {
    var filterValue = this.value;
    iso.arrange({ filter: filterValue });
  });
  var buttons = document.getElementById("filter-button-group1");
  buttons.childNodes.forEach(function(button) {
    button.addEventListener('click', function() {
      var filterValue = this.getAttribute('data-filter');
      if (filterValue.includes("decate")) {
        filterValue = filterFns[filterValue]
      } else {
        filterValue = filterValue;
      }
      iso.arrange({ filter: filterValue });
    });
  });
});