Ext.ns('Rwiki');

Rwiki.Flash = function() {
  this._container = null;
  this._time = 2;
};

Rwiki.Flash.prototype = {
  success: function(message) {
    this._flash(message, 'Success');
  },

  error: function(message) {
    this._flash(message, 'Error');
  },

  warning: function(message) {
    this._flash(message, 'Warning');
  },

  info: function(message) {
    this._flash(message, 'Info');
  },

  _createBox: function(title, message) {
    return ['<div class="msg">',
      '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
      '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc"><h3>', title, '</h3>', message, '</div></div></div>',
      '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
      '</div>'].join('');
  },

  _flash: function(message, title) {
    if (!this._container) {
      this._container = Ext.DomHelper.insertFirst(document.body, { id:'msg-div' }, true);
    }

    this._container.alignTo(document, 't-t');
    var m = Ext.DomHelper.append(this._container, { html: this._createBox(title, message) }, true);
    m.slideIn('t').pause(1).ghost("t", { remove: true });
  }
};

