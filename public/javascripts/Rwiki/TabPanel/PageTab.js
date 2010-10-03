Ext.ns('Rwiki.TabPanel');

Rwiki.TabPanel.PageTab = Ext.extend(Ext.Container, {
  constructor: function() {
    Ext.apply(this, {
      closable: true,
      cls: 'page-container',
      iconCls: 'icon-page'
    });

    Rwiki.TabPanel.PageTab.superclass.constructor.apply(this, arguments);
  },

  getPagePath: function() {
    return this.path;
  },

  setPagePath: function(path) {
    this.path = path;
  },

  /**
   * Update the page content.
   */
  setContent: function(htmlContent) {
    pageContainer = this.getPageContainer();
    pageContainer.html(htmlContent);
  },

  getPageContainer: function() {
    return $('#' + this.id);
  },

  setTitle: function(title) {
    $(this.tabEl).find('.x-tab-strip-text').text(title);
  }
});
