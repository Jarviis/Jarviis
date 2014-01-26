Jarviis.Views.ListIssue = Backbone.Marionette.ItemView.extend({
  tagName: 'li',
  template: _.template("<a href='#'><%=title%></a>")
});
Jarviis.Views.NoIssueView = Backbone.Marionette.ItemView.extend({
  template: _.template('<p>Hooray! You have no open issues!</p>')
});

Jarviis.Views.IssuesView = Backbone.Marionette.CollectionView.extend({
  itemView: Jarviis.Views.ListIssue,
  emptyView: Jarviis.Views.NoIssueView
});
