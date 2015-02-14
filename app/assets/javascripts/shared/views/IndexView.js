Marionette.IndexView = Marionette.CompositeView.extend({
    template: "#index-view-template",
    className: "panel panel-default", /* Bootstrap class for tables */
    childViewContainer: "tbody",
    events: {
      "click li.previous a": "previousPage",
      "click li.next a": "nextPage",
      "click li.page a": "page",
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
      var id = this.collection.state.currentPage;

      this.$('li.active').removeClass('active');
      this.$('li a[href='+ (id + 1) +']')
          .parent()
          .addClass('active');
    },
    serializeData: function () {
      var range = _.range(1, this.collection.state.totalPages + 1);

      return {
        pages: range,
        currentPage: this.collection.state.currentPage
      }
    }
});
