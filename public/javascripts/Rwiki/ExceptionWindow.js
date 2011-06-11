Ext.ns('Rwiki');

Rwiki.ExceptionWindow = Ext.extend(Ext.Window, {

  constructor: function() {
    Ext.apply(this, {
      title: 'Exception',
      layout: 'border',
      maximizable: true,
      width: 750,
      height: 500,
      items: [
        new Ext.Panel({
        html: "<iframe id='exception-iframe' width='100%' height='100%' src=''></iframe>",
        region: 'center'
      })
      ]
    });

    Rwiki.ExceptionWindow.superclass.constructor.apply(this, arguments);
  },

  showResponse: function(response) {
    this.show();

    var ifrm = document.getElementById('exception-iframe');
    ifrm = (ifrm.contentWindow) ? ifrm.contentWindow : (ifrm.contentDocument.document) ? ifrm.contentDocument.document : ifrm.contentDocument;
    ifrm.document.open();
    ifrm.document.write(response.responseText);
    ifrm.document.close();
  }
});
