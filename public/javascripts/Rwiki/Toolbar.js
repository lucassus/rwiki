Ext.ns('Rwiki');

Rwiki.Toolbar = Ext.extend(Ext.Toolbar, {
  constructor: function(config) {
    config = Ext.apply({}, config);

    Rwiki.Toolbar.superclass.constructor.call(this, config);
    this.addEvents('toggleEditor');
  }
});
