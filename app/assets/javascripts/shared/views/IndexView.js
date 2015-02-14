Marionette.IndexView = Marionette.CompositeView.extend({
  template: "#index-view-template",
  className: "panel panel-default", /* Bootstrap class for tables */
  childViewContainer: "tbody",

  events: {
    "click li.previous:not(.disabled) a": "previousPage",
    "click li.next:not(.disabled) a": "nextPage",
    "click li.page a": "page"
  },

  initialize: function (options) {
    Marionette.CompositeView.prototype.initialize.apply(this, arguments);

    options = options || {};

    if (options.title) {
      this.title = options.title;
    }

    this.collection.on('paginate', this.render, this);
  },

  page: function (ev) {
    ev.preventDefault();
    var id = $(ev.currentTarget).attr('href');

    this.collection.getPage(id - 1);
  },

  previousPage: function () {
    this.collection.getPreviousPage();
  },

  nextPage: function () {
    this.collection.getNextPage();
  },

  onRenderCollection: function () {
    var id = this.collection.state.currentPage + 1,
        totalPages = this.collection.state.totalPages,
        firstPage = this.collection.state.firstPage,
        disabled;

    this.$('li.active').removeClass('active');
    this.$('li a[href='+ id +']')
        .parent()
        .addClass('active');

    if (totalPages === id ) {
      disabled = "next";
    } else if (firstPage === id - 1) {
      disabled = "previous";
    }

    this.$('li.'+disabled)
        .addClass('disabled')
  },

  serializeData: function () {
    var range = _.range(1, this.collection.state.totalPages + 1);

    return {
      title: this.title,
      pages: range,
      currentPage: this.collection.state.currentPage
    }
  }
});
