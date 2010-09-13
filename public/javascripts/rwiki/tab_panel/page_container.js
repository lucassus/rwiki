Rwiki.TabPanel.PageContainer = Ext.extend(Ext.Container, {
  constructor: function(config) {
    config = Ext.apply({
      closable: true,
      cls: 'page-container',
      iconCls: 'icon-page'
    }, config);

    this.pageName = config.pageName;

    Rwiki.TabPanel.PageContainer.superclass.constructor.call(this, config);
  },

  getPageName: function() {
    return this.pageName;
  },

  /**
   * Update page content.
   */
  setContent: function(htmlContent) {
    var nodeId = Rwiki.escapedId(this.pageName);
    $(nodeId).html(htmlContent);
  }

//  show: function() {
//    this.hidden = false;
//    if (this.autoRender) {
//      this.render(Ext.isBoolean(this.autoRender) ? Ext.getBody() : this.autoRender);
//    }
//
//    if (this.rendered) {
//      this.onShow();
//    }
//
//    return this;
//  }
});
