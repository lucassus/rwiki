Rwiki.Editor = function(container) {
  var self = this;
  this.enabled = false;

  // hack for FF, clear text area on load
  container.val('');

  container.bind('keydown', function() {
    return self.enabled;
  });

  var timeout = null;
  container.bind('keyup', function() {
    clearTimeout(timeout);

    if (!self.enabled) {
      return false;
    }

    timeout = setTimeout(function() {
      var content = container.val();
      var fileName = currentTab.id;

      $.ajax({
        type: 'POST',
        url: '/node/update',
        dataType: 'json',
        data: {
          node: fileName,
          content: self.getContent()
        },
        success: function(data) {
          $('#' + currentTab.id).html(data.html);
        }
      });

    }, 900);
  });

  return {
    clearContent: function() {
      container.val('');
      this.disable();
    },

    getContent: function() {
      return container.val();
    },

    setContent: function(content) {
      container.val(content);
      this.enable();
    },

    enable: function() {
      this.enabled = true;
    },

    disable: function() {
      this.enabled = false;
    }
  };
};
