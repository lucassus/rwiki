Ext.ns('Rwiki.TabPanel');

Rwiki.TabPanel.PageTab = Ext.extend(Ext.Container, {
  constructor: function(config) {
    config = Ext.apply({
      closable: true,
      cls: 'page-container',
      iconCls: 'icon-page'
    }, config);

    Rwiki.TabPanel.PageTab.superclass.constructor.call(this, config);

    this.on('pageLoaded', function(data) {
      if (this.getPagePath() != data.path) return;
      
      this.setContent(data.html);
    });
  },

  getPagePath: function() {
    return this.id;
  },

  /**
   * Update the page content.
   */
  setContent: function(htmlContent) {
    var path = this.getPagePath();
    var pageContainer = $('#' + path.replace(/(\W)/g, '\\$1'));
    pageContainer.html(htmlContent);
  },

  setTitle: function(title) {
    $(this.tabEl).find('.x-tab-strip-text').text(title);
  }
});
