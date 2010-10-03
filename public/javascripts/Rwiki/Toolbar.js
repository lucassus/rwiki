Ext.ns('Rwiki');

Rwiki.Toolbar = Ext.extend(Ext.Toolbar, {
  constructor: function() {
    Rwiki.Toolbar.superclass.constructor.apply(this, arguments);
    this.addEvents('toggleEditor');
  }
});
