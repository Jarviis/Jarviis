Jarviis.module("Issues.List", function(List, ContactManager, Backbone, Marionette, $, _){
  List.Layout = Marionette.Layout.extend({
    template: "#contact-list-layout",

    regions: {
      panelRegion: "#panel-region",
      contactsRegion: "#contacts-region"
    }
  });

  List.Issue = Marionette.ItemView.extend({
    tagName: 'tr',
    template: _.template("<td><%-name%></td><td><%-description%></td>")
  });

  var NoIssueView = Backbone.Marionette.ItemView.extend({
    template: _.template('<p>Hooray! You have no open issues!</p>')
  });

  List.Issues = Marionette.CompositeView.extend({
    tagName: 'table',
    template: "#list-template",
    itemViewContainer: "tbody",
    itemView: List.Issue,
    emptyView: NoIssueView
  });

});
