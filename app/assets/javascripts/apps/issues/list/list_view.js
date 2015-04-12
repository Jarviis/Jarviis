Jarviis.module("Issues.List", function(List, Jarviis, Backbone, Marionette, $, _){

  List.Layout = Marionette.LayoutView.extend({
    template: "#issues-template",
    regions: {
      assigned: "#assigned",
      reported: "#reported",
      comments: "#comments"
    }
  });

  List.Issue = Marionette.ItemView.extend({
    tagName: 'tr',
    template: _.template("<td><a href='#<%- id %>'><%- name %></a></td><td><%- state %></td>"),

    events: {
      'click a': 'navigate'
    },

    navigate: function(e) {
      var id = this.model.id;

      e.preventDefault();

      Jarviis.navigate('issues/'+id);
      Jarviis.Issues.Show.Controller.showIssue(id);
    },

    serializeData: function () {
      var model = this.model.toJSON();
      return _.extend(model, {
        state: Jarviis.states(model.state)
      });
    }
  });

  var NoIssueView = Backbone.Marionette.ItemView.extend({
    tagName: "tr",
    className: "no-issue",
    template: _.template('<td colspan="2">Hooray! You have no open issues!</td>')
  });

  List.Issues = Marionette.IndexView.extend({
    childView: List.Issue,
    emptyView: NoIssueView
  });

});
