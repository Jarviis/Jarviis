Jarviis.module("Header", function(Header, Jarviis, Backbone, Marionette, $, _){

  var ResultView = Marionette.ItemView.extend({
    template: '#result-template',
    className: 'list-group-item',
    tagName: 'li'
  });

  Header.SearchView = Marionette.CompositeView.extend({
    template: '#search-template',
    className: 'form-group',
    childView: ResultView,
    childViewContainer: '#results',
    events: {
      'keyup #search-input': 'search'
    },
    initialize: function() {
      this.collection = new Backbone.Collection();
      this.search = _.debounce(this.search, 400);
    },
    selectPrevious: function() {
      console.log('previous');
    },
    selectNext: function() {
      console.log('next');
    },
    isUserSearch: function(keyword) {
      return keyword.search('@') === 0;
    },
    search: function(ev) {
      var self = this;
      var keyword = $(ev.currentTarget).val();
      if (!keyword) {
        return false;
      }
      var searchQuery = "issues:search";

      if (this.isUserSearch(keyword)) {
        searchQuery = "users:search";
        keyword = keyword.replace('@', '');
      }

      var fetchingResults = Jarviis.request(searchQuery, keyword);

      fetchingResults.done(function (collection) {
        self.collection.reset(collection.toJSON());
      });
    },
    onRenderCollection: function () {
      this.$('#results').removeClass('hidden');
    }
  });
});

