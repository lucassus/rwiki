Ext.ns('Rwiki');

Rwiki.SidePanel = Ext.extend(Ext.Panel, {
  constructor: function(config) {
    var defaultConfig = {
      region: 'west',
      id: 'west-panel',
      title: 'Pages',
      split: true,
      width: 265,
      minSize: 265,
      maxSize: 500,
      collapsible: true,
      autoScroll: true,
      margins: '0 0 5 5',
      cmargins: '0 0 0 0'
    };

    Rwiki.SidePanel.superclass.constructor.call(this, Ext.apply(defaultConfig, config));
  }
});
