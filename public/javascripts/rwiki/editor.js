Rwiki.Editor = function(container) {
  var self = this;

  this.container = container;
  this.enabled = false;

  // hack for FF, clear text area on load
  this.container.val('');

  this.container.bind('keydown', function() {
    return self.enabled;
  });

  var timeout = null;
  this.container.bind('keyup', function() {
    if (!self.enabled) {
      return false;
    }

    clearTimeout(timeout);
    timeout = setTimeout(function() {
      self.container.trigger('contentChanged');
    }, 900);
  });

  this.clearContent = function() {
    container.val('');
    this.disable();
  };

  this.getContent = function() {
    return container.val();
  };

  this.setContent = function(content) {
    container.val(content);
    this.enable();
  };

  this.enable = function() {
    this.enabled = true;
  };

  this.disable = function() {
    this.enabled = false;
  };
};
