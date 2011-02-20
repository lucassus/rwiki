Ext.ns('Rwiki');

/**
 * Custom button implementation.
 * @see http://tdg-i.com/535/quicktip-prevent-ext-js-buttons-from-stealing-focus
 */
Rwiki.Button = Ext.extend(Ext.Button, {

  constructor: function() {
    Rwiki.Button.superclass.constructor.apply(this, arguments);
  },

  onMouseDown: function(e) {
    if (!this.disabled && e.button === 0) {
      e.stopEvent(); // injected line here
      this.getClickEl(e).addClass('x-btn-click');
      this.doc.on('mouseup', this.onMouseUp, this);
    }
  },

  onMouseUp: function(e) {
    if (e.button === 0) {
      e.stopEvent(); // injected line here
      this.getClickEl(e, true).removeClass('x-btn-click');
      this.doc.un('mouseup', this.onMouseUp, this);
    }
  }

});
