Jarviis.Layouts = {}
Jarviis.Layouts.DashboardLayout = Backbone.Marionette.Layout.extend({
  template: "#dashboard-template",

  regions: {
    assigned: "#assigned",
    reported: "#reported",
  }
});
