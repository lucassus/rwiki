Ext.ns('Rwiki');

Rwiki.Viewport = Ext.extend(Ext.Viewport, {
  layout: 'border',
  renderTo: Ext.getBody(),
  
  initComponent: function() {
    Rwiki.Viewport.superclass.initComponent.apply(this);
  }
});
