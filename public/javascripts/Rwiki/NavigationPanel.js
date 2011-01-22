Ext.ns('Rwiki');

Rwiki.NavigationPanel = Ext.extend(Ext.Panel, {
  constructor: function() {

    Ext.apply(this, {
      region: 'west',
      layout: 'border',

      header: true,
      title: 'Navigation panel',

      split: true,
      collapsible: true,
      
      width: 255,
      minSize: 255,
      maxSize: 500,
      margins: '3 0 3 3',
      cmargins: '3 3 3 3'
    });

    Rwiki.NavigationPanel.superclass.constructor.apply(this, arguments);
  }
});
