Jarviis.module("Issues.List", function(List, Jarviis, Backbone, Marionette, $, _){
  List.Layout = Marionette.Layout.extend({
    template: "#issues-template",
    regions: {
      assigned: "#assigned",
      reported: "#reported",
    }
  });

  List.Issue = Marionette.ItemView.extend({
    tagName: 'tr',
    template: _.template("<td><a href='#<%-id%>'><%-name%></a></td><td><%-state%></td>"),
    events: {
      'click a': 'navigate'
    },
    navigate: function(e) {
      e.preventDefault();
      var id = this.model.id;
      Jarviis.navigate('issues/'+id);
      Jarviis.Issues.Show.Controller.showIssue(id);
    }
  });

  var NoIssueView = Backbone.Marionette.ItemView.extend({
    template: _.template('<p>Hooray! You have no open issues!</p>')
  });

  List.Issues = Marionette.CompositeView.extend({
    tagName: 'table',
    className: 'table table-striped table-hover', /* Bootstrap class for tables */
    template: "#list-issues-template",
    itemViewContainer: "tbody",
    itemView: List.Issue,
    emptyView: NoIssueView
  });

});
