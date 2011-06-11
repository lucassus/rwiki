Ext.ns('Rwiki');

Rwiki.Flash = function() {
  this._time = 2;
};

Rwiki.Flash.prototype = {
  success: function(message) {
    this._flash(message, 'success');
  },

  error: function(message) {
    this._flash(message, 'error');
  },

  warning: function(message) {
    this._flash(message, 'warning');
  },

  info: function(message) {
    this._flash(message, 'info');
  },

  _flash: function(message, type) {
    Ext.ux.Msg.flash({
      msg: message,
      time: this._time,
      type: type
    });
  }
};
