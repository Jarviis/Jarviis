Jarviis.Regions.Modal = Backbone.Marionette.Region.extend({
  el: "#modal",
  onShow: function() {
    this.$el.show();
  }
});
