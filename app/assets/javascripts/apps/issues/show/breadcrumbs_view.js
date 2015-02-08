Jarviis.module("Issues.Show", function(Show, Jarviis, Backbone, Marionette, $, _){

  var BreadcrumbView = Marionette.ItemView.extend({
    template: _.template('<a href="#"><%- step %></a>'),
    tagName: 'li'
  });

  Show.Breadcrumbs = Marionette.CollectionView.extend({
    tagName: "ol",
    className: "breadcrumb",
    childView: BreadcrumbView
  });

});

