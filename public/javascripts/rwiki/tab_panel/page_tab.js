Rwiki.TabPanel.PageTab = Ext.extend(Ext.Container, {
  constructor: function(config) {
    config = Ext.apply({
      closable: true,
      cls: 'page-container',
      iconCls: 'icon-page'
    }, config);

    Rwiki.TabPanel.PageTab.superclass.constructor.call(this, config);
  },

  getPageName: function() {
    return this.id;
  },

  /**
   * Update the page content.
   */
  setContent: function(htmlContent) {
    var pageName = this.getPageName();
    var pageContainer = $('#' + pageName.replace(/(\W)/g, '\\$1'));
    pageContainer.html(htmlContent);
  }
});
