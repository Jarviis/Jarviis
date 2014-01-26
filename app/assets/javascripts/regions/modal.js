Jarviis.Regions.Modal = Backbone.Marionette.Region.extend({
  el: "#modal",
  initialize: function () {
  },
  onShow: function() {
    this.$el.show();
  }
});
