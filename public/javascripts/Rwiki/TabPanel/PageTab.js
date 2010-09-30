Ext.ns('Rwiki.TabPanel');

Rwiki.TabPanel.PageTab = Ext.extend(Ext.Container, {
  constructor: function(config) {
    config = Ext.apply({
      closable: true,
      cls: 'page-container',
      iconCls: 'icon-page'
    }, config);

    Rwiki.TabPanel.PageTab.superclass.constructor.call(this, config);

    this.on('pageContentLoaded', function(data) {
      if (this.getPagePath() != data.path) return;
      
      this.setContent(data.html);
    });
  },

  getPagePath: function() {
    return this.id;
  },

  setPagePath: function(id) {
    this.id = id;
  },

  /**
   * Update the page content.
   */
  setContent: function(htmlContent) {
    pageContainer = this.getPageContainer();
    pageContainer.html(htmlContent);
  },

  getPageContainer: function() {
    var path = this.getPagePath();
    var escapedSelector = '#' + path.replace(/(\W)/g, '\\$1');
    return $(escapedSelector);
  },

  setTitle: function(title) {
    $(this.tabEl).find('.x-tab-strip-text').text(title);
  }
});
